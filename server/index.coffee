fs = require 'fs'
Q = require 'q'
jiraRequirementsData = require 'jira-requirements-data'
express = require 'express'
bodyParser = require 'body-parser'
cookieParser = require 'cookie-parser'
session = require 'express-session'
app = express()
http = require('http').Server app
io = require('socket.io') http
passport = require 'passport'
LocalStrategy = require('passport-local').Strategy
superagent = require 'superagent'

TEST_DATA = './test/data/data.json'
CONFIG = './config.json'

config = JSON.parse fs.readFileSync CONFIG

if not config.strictSSL
  process.env.NODE_TLS_REJECT_UNAUTHORIZED = '0'

search = (sessionID, username, password) ->
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
      io.sockets.in(sessionID).emit 'requirementSprintsTotal', total
    onRequirementSprint: () ->
      io.sockets.in(sessionID).emit 'requirementSprint'
    onTaskSprintsTotal: (total) ->
      io.sockets.in(sessionID).emit 'taskSprintsTotal', total
    onTaskSprint: () ->
      io.sockets.in(sessionID).emit 'taskSprint'
    onRequirementsTotal: (total) ->
      io.sockets.in(sessionID).emit 'requirementsTotal', total
    onRequirement: () ->
      io.sockets.in(sessionID).emit 'requirement'

testData = (sessionID, username, password) ->
  Q.nfcall(fs.readFile, TEST_DATA)
    .then (json) ->
      JSON.parse json
    .fail ->
      console.log 'loading test data'
      search(sessionID, username, password)
        .then (data) ->
          console.log 'writing test data to %s', TEST_DATA
          Q.nfcall fs.writeFile, TEST_DATA, JSON.stringify data
            .then ->
              data

data = (sessionID, username, password) ->
  if config.testMode
    testData sessionID, username, password
  else
    search sessionID, username, password

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
        done null,
          username: username
          password: password
          userObject: response.body

passport.serializeUser (user, done) ->
  console.log user
  done null, JSON.stringify user

passport.deserializeUser (serialized, done) ->
  console.log serialized
  done null, JSON.parse serialized

app.use express.static 'client/public'
app.use '/slick/', express.static 'node_modules/slick-carousel/slick/'
app.use '/jquery/', express.static 'node_modules/jquery/dist/'
app.use bodyParser.json()
app.use cookieParser()
app.use session
  resave: false
  saveUninitialized: false
  secret: config.expressSessionSecret
app.use passport.initialize()
app.use passport.session()

app.set 'views', './server/views'
app.set 'view engine', 'jade'

app.post '/login', (req, res) ->
  passport.authenticate(
    'local', (error, user, info) ->
      res.json
        error: error
        user: user.userObject if user
  )(req, res)

app.get '/logout', (req, res) ->
  req.logout()
  res.json
    success: true

app.get '/loggedInUser', (req, res) ->
  console.log req.cookies
  if req.user
    res.json
      user: req.user.userObject
  else
    res.status(404).send 'Not Found'

app.get '/data', (req, res) ->
  console.log req.cookies
  if req.user
    data(req.sessionID, req.user.username, req.user.password)
    .then (data) ->
      res.json data
    .fail (error) ->
      res.json
        error: error
    .done()
  else
    res.status(400).json
      error: 'NOT_LOGGED_IN'

app.get  '/', (req, res) ->
  res.render 'index',
    title: config.title
    jiraRoot: config.jiraRoot

io.on 'connection', (socket) ->
  socket.join socket.handshake.sessionID

server = http.listen 3000, ->
  address = server.address()
  host = address.address
  port = address.port
  console.log 'Listening at http://%s:%s', host, port
