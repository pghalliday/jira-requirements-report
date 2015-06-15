fs = require 'fs'
Q = require 'q'
jiraRequirementsData = require 'jira-requirements-data'
express = require 'express'
app = express()

TEST_DATA = './test/data/issues.json'
CONFIG = './config.json'

config = JSON.parse fs.readFileSync CONFIG

search = ->
  jiraRequirementsData
    serverRoot: config.serverRoot
    strictSSL: config.strictSSL
    user: config.user
    pass: config.pass
    maxResults: config.maxResults
    project: config.project
    issueTypes: config.issueTypes

testData = ->
  Q.nfcall(fs.readFile, TEST_DATA)
    .then (json) ->
      JSON.parse json
    .fail ->
      console.log 'loading test data'
      search()
        .then (issues) ->
          console.log 'writing test data to %s', TEST_DATA
          Q.nfcall fs.writeFile, TEST_DATA, JSON.stringify issues
            .then ->
              issues

data = ->
  if config.testMode
    testData()
  else
    search()

app.get '/', (req, res) ->
  data()
  .then (issues) ->
    res.json issues

app.get '/cache-test-data', (req, res) ->
  data

server = app.listen 3000, ->
  address = server.address()
  host = address.address
  port = address.port
  console.log 'Listening at http://%s:%s', host, port
