appDispatcher = require '../dispatcher/appDispatcher'
EventEmitter = require('events').EventEmitter
appConstants = require '../constants/appConstants'
login = require '../lib/login'
logout = require '../lib/logout'
getData = require '../lib/getData'

CHANGE_EVENT = 'change'

createProgressBar = (id) ->
  id: id
  total: -1
  current: -1

class AppStore extends EventEmitter
  constructor: ->
    @user = undefined
    @uid = undefined
    @notLoggedIn = false
    @loginError = undefined
    @loginErrorId = 0
    @title = undefined
    @jiraRoot = undefined
    @sections = undefined
    @errorNotification =
      hidden: true
      error: undefined
    @progressGroup =
      hidden: true
      progressBars: (createProgressBar(id) for id in appConstants.PROGRESS_BAR_IDS)
    @dispatcherIndex = appDispatcher.register (payload) =>
      action = payload.action
      switch action.actionType
        when appConstants.ACTION_LOGGED_IN
          user = action.user
          if user
            @notLoggedIn = false
            @loginError = undefined
            @user = action.user
            @uid = action.uid
            getData @uid
          else
            @notLoggedIn = true
            @loginError = undefined
            @user = undefined
            @uid = action.uid
          @emitChange()
        when appConstants.ACTION_LOGIN_ERROR
          @loginErrorId++
          @notLoggedIn = true
          @loginError = action.error
          @user = undefined
          @emitChange()
        when appConstants.ACTION_LOGIN
          login action.username, action.password, @uid
        when appConstants.ACTION_LOGOUT
          logout()
        when appConstants.ACTION_LOGGED_OUT
          @notLoggedIn = true
          @loginError = undefined
          @user = undefined
          @sections = undefined
          @progressGroup.progressBars = (createProgressBar(id) for id in appConstants.PROGRESS_BAR_IDS)
          @emitChange()
        when appConstants.ACTION_SET_TITLE
          @title = action.title
          @emitChange()
        when appConstants.ACTION_SET_JIRA_ROOT
          @jiraRoot = action.jiraRoot
          @emitChange()
        when appConstants.ACTION_SET_SECTIONS
          @sections = action.sections
          @emitChange()
        when appConstants.ACTION_ERROR_SHOW
          @errorNotification.hidden = false
          @errorNotification.error = action.error
          @emitChange()
        when appConstants.ACTION_PROGRESS_SHOW
          @progressGroup.hidden = false
          @emitChange()
        when appConstants.ACTION_PROGRESS_HIDE
          @progressGroup.hidden = true
          @emitChange()
        when appConstants.ACTION_PROGRESS_INIT
          progressBar = @progressGroup.progressBars[action.id]
          progressBar.total = action.total
          progressBar.current = 0
          @emitChange()
        when appConstants.ACTION_PROGRESS_SET
          progressBar = @progressGroup.progressBars[action.id]
          progressBar.total = action.total
          progressBar.current = action.current
          @emitChange()
        when appConstants.ACTION_PROGRESS_INCREMENT
          progressBar = @progressGroup.progressBars[action.id]
          progressBar.current++
          @emitChange()
        when appConstants.ACTION_TOGGLE_EXPAND_REQUIREMENT
          action.requirement.expanded = not action.requirement.expanded
          @emitChange()
      true

  emitChange: =>
    @emit CHANGE_EVENT

  addChangeListener: (callback) =>
    @on CHANGE_EVENT, callback

  removeChangeListener: (callback) =>
    @removeListener CHANGE_EVENT, callback

module.exports = new AppStore()
