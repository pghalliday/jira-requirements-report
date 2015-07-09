appConstants = require '../constants/appConstants'
appActions = require '../actions/appActions'
superagent = require 'superagent'
io = require 'socket.io-client'
uuid = require 'uuid'

module.exports = (title, jiraRoot) ->
  appActions.setTitle title
  appActions.setJiraRoot jiraRoot
  uid = uuid.v4()
  progressSocket = io.connect()
  for id in appConstants.PROGRESS_BAR_IDS
    do (id) ->
      progressSocket.on appConstants.PROGRESS_BARS[id].totalMessage, (total) ->
        appActions.initProgress id, total
      progressSocket.on appConstants.PROGRESS_BARS[id].itemMessage, ->
        appActions.incrementProgress id
  progressSocket.on 'uidRegistered', ->
    superagent
      .get('/loggedInUser')
      .end (error, response) ->
        if not error
          appActions.loggedIn
            user: response.body.user
            uid: uid
        else
          appActions.loggedIn
            uid: uid
  progressSocket.on 'connect', ->
    progressSocket.emit 'uid', uid
