appActions = require '../actions/appActions'
superagent = require 'superagent'

module.exports = (title, jiraRoot) ->
  appActions.setTitle title
  appActions.setJiraRoot jiraRoot
  superagent
    .get('/loggedInUser')
    .end (error, response) ->
      if not error
        appActions.loggedIn response.body.user
