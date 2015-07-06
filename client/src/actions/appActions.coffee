appDispatcher = require '../dispatcher/appDispatcher'
appConstants = require '../constants/appConstants'

module.exports =
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
  setJiraRoot: (jiraRoot) ->
    appDispatcher.handleProgressSocketAction
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
  addSection: (section) ->
    appDispatcher.handleDataRequestAction
      actionType: appConstants.ACTION_ADD_SECTION
      section: section
  toggleExpandRequirement: (requirement) ->
    appDispatcher.handleViewAction
      actionType: appConstants.ACTION_TOGGLE_EXPAND_REQUIREMENT
      requirement: requirement
