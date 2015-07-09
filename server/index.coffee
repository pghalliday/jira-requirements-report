fs = require 'fs'
Q = require 'q'
jiraRequirementsData = require 'jira-requirements-data'
express = require 'express'
bodyParser = require 'body-parser'
session = require 'express-session'
cookieParser = require 'cookie-parser'
app = express()
http = require('http').Server app
passport = require 'passport'
LocalStrategy = require('passport-local').Strategy
superagent = require 'superagent'

TEST_DATA = './test/data/data.json'
CONFIG = './config.json'

config = JSON.parse fs.readFileSync CONFIG

if not config.strictSSL
  process.env.NODE_TLS_REJECT_UNAUTHORIZED = '0'

search = (uid, username, password) ->
  jiraRequirementsData
    serverRoot: config.jiraRoot
    strictSSL: config.strictSSL
    user: username
    pass: password
    maxResults: config.maxResults
    project: config.project
    requirementsRapidView: config.requirementsRapidView
    tasksRapidView: config.tasksRapidView
    requirements: config.requirements
    tasks: config.tasks
    excludedStates: config.excludedStates
    onRequirementSprintsTotal: (total) ->
      io.sockets.in(uid).emit 'requirementSprintsTotal', total
    onRequirementSprint: () ->
      io.sockets.in(uid).emit 'requirementSprint'
    onTaskSprintsTotal: (total) ->
      io.sockets.in(uid).emit 'taskSprintsTotal', total
    onTaskSprint: () ->
      io.sockets.in(uid).emit 'taskSprint'
    onRequirementsTotal: (total) ->
      io.sockets.in(uid).emit 'requirementsTotal', total
    onRequirement: () ->
      io.sockets.in(uid).emit 'requirement'

testData = (uid, username, password) ->
  Q.nfcall(fs.readFile, TEST_DATA)
    .then (json) ->
      JSON.parse json
    .fail ->
      console.log 'loading test data'
      search(uid, username, password)
        .then (data) ->
          console.log 'writing test data to %s', TEST_DATA
          Q.nfcall fs.writeFile, TEST_DATA, JSON.stringify data
            .then ->
              data

data = (uid, username, password) ->
  if config.testMode
    testData uid, username, password
  else
    search uid, username, password

passport.use new LocalStrategy (username, password, done) ->
  superagent
    .post(config.crowdRoot + '/rest/usermanagement/1/authentication')
    .auth(config.crowdApplicationName, config.crowdApplicationPassword)
    .set('Accept', 'application/json')
    .query(
      username: username
    ).send(
      value: password
    ).end (error, response) ->
      if error and error.status is 400
        done response.body
      else if error
        done error
      else
        user =
          username: username
          password: password
          userObject: response.body
        done null, user

passport.serializeUser (user, done) ->
  done null, JSON.stringify user

passport.deserializeUser (serialized, done) ->
  done null, JSON.parse serialized

app.use express.static 'client/public'
app.use '/slick/', express.static 'node_modules/slick-carousel/slick/'
app.use '/jquery/', express.static 'node_modules/jquery/dist/'
app.use bodyParser.json()
app.use session
  resave: false
  saveUninitialized: true
  secret: config.expressSessionSecret
app.use passport.initialize()
app.use passport.session()

expressSessionCookieParse = cookieParser config.expressSessionSecret
io = require('socket.io') http
io.use (socket, next) ->
  deferred = Q.defer()
  deferred.promise
    .then ->
      next()
    .fail ->
      next new Error 'Cannot resolve connect session ID'
    .done()
  request = socket.request
  if request.headers.cookie
    expressSessionCookieParse request, null, (error) ->
      if error
        deferred.reject()
      else
        request.sessionID = request.signedCookies['connect.sid']
        if request.sessionID
          deferred.resolve()
        else
          deferred.reject()
  else
    deferred.reject()

app.set 'views', './server/views'
app.set 'view engine', 'jade'

app.post '/login', (req, res) ->
  passport.authenticate(
    'local', (error, user, info) ->
      if error
        res.status(401).json
          error: error
      else if user
        req.login user, (error) ->
          if error
            res.status(401).json
              error: error.toString()
          else
            res.json
              user: user.userObject
      else
        res.json
          error: info
  )(req, res)

app.get '/logout', (req, res) ->
  req.logout()
  res.json
    success: true

app.get '/loggedInUser', (req, res) ->
  if req.user
    res.json
      user: req.user.userObject
  else
    res.status(401).json
      error: 'NOT_LOGGED_IN'

app.get '/data', (req, res) ->
  if req.user
    uid = req.query.uid
    if uid
      data(uid, req.user.username, req.user.password)
      .then (data) ->
        res.json data
      .fail (error) ->
        res.json
          error: error
      .done()
    else
      res.status(400).json
        error: 'UID_MISSING'
  else
    res.status(401).json
      error: 'NOT_LOGGED_IN'

app.get  '/', (req, res) ->
  res.render 'index',
    title: config.title
    jiraRoot: config.jiraRoot

io.sockets.on 'connection', (socket) ->
  socket.on 'uid', (uid) ->
    socket.join uid
    socket.emit 'uidRegistered'

server = http.listen 3000, ->
  address = server.address()
  host = address.address
  port = address.port
  console.log 'Listening at http://%s:%s', host, port
