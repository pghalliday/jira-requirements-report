appDispatcher = require '../dispatcher/appDispatcher'
appConstants = require '../constants/appConstants'

module.exports =
  login: (params) ->
    appDispatcher.handleViewAction
      actionType: appConstants.ACTION_LOGIN
      username: params.username
      password: params.password
  loggedIn: (params) ->
    appDispatcher.handleViewAction
      actionType: appConstants.ACTION_LOGGED_IN
      user: params.user
      uid: params.uid
  loginError: (error) ->
    appDispatcher.handleViewAction
      actionType: appConstants.ACTION_LOGIN_ERROR
      error: error
  logout: (params) ->
    appDispatcher.handleViewAction
      actionType: appConstants.ACTION_LOGOUT
  loggedOut: (params) ->
    appDispatcher.handleViewAction
      actionType: appConstants.ACTION_LOGGED_OUT
  initProgress: (id, total) ->
    appDispatcher.handleProgressSocketAction
      actionType: appConstants.ACTION_PROGRESS_INIT
      id: id
      total: total
  setProgress: (params) ->
    appDispatcher.handleDataRequestAction
      actionType: appConstants.ACTION_PROGRESS_SET
      id: params.id
      total: params.total
      current: params.current
  incrementProgress: (id) ->
    appDispatcher.handleProgressSocketAction
      actionType: appConstants.ACTION_PROGRESS_INCREMENT
      id: id
  setTitle: (title) ->
    appDispatcher.handleInitAction
      actionType: appConstants.ACTION_SET_TITLE
      title: title
  setJiraRoot: (jiraRoot) ->
    appDispatcher.handleInitAction
      actionType: appConstants.ACTION_SET_JIRA_ROOT
      jiraRoot: jiraRoot
  showProgress: ->
    appDispatcher.handleProgressSocketAction
      actionType: appConstants.ACTION_PROGRESS_SHOW
  hideProgress: ->
    appDispatcher.handleProgressSocketAction
      actionType: appConstants.ACTION_PROGRESS_HIDE
  showError: (error) ->
    appDispatcher.handleDataRequestAction
      actionType: appConstants.ACTION_ERROR_SHOW
      error: error
  setSections: (sections) ->
    appDispatcher.handleDataRequestAction
      actionType: appConstants.ACTION_SET_SECTIONS
      sections: sections
  toggleExpandRequirement: (requirement) ->
    appDispatcher.handleViewAction
      actionType: appConstants.ACTION_TOGGLE_EXPAND_REQUIREMENT
      requirement: requirement
