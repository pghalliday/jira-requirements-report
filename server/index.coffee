fs = require 'fs'
Q = require 'q'
jiraRequirementsData = require 'jira-requirements-data'
express = require 'express'
app = express()
http = require('http').Server app
io = require('socket.io') http

TEST_DATA = './test/data/data.json'
CONFIG = './config.json'

config = JSON.parse fs.readFileSync CONFIG

if not config.strictSSL
  process.env.NODE_TLS_REJECT_UNAUTHORIZED = '0'

search = (sessionID) ->
  jiraRequirementsData
    serverRoot: config.jiraRoot
    strictSSL: config.strictSSL
    user: config.user
    pass: config.pass
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

testData = (sessionID) ->
  Q.nfcall(fs.readFile, TEST_DATA)
    .then (json) ->
      JSON.parse json
    .fail ->
      console.log 'loading test data'
      search(sessionID)
        .then (data) ->
          console.log 'writing test data to %s', TEST_DATA
          Q.nfcall fs.writeFile, TEST_DATA, JSON.stringify data
            .then ->
              data

data = (sessionID) ->
  if config.testMode
    testData sessionID
  else
    search sessionID

app.use express.static 'client/public'
app.use '/slick/', express.static 'node_modules/slick-carousel/slick/'
app.use '/jquery/', express.static 'node_modules/jquery/dist/'

app.set 'views', './server/views'
app.set 'view engine', 'jade'

app.get '/data', (req, res) ->
  data(req.sessionID)
  .then (data) ->
    res.json data
  .done()

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
