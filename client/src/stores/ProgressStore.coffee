appDispatcher = require '../dispatcher/appDispatcher'
EventEmitter = require('events').EventEmitter
progressConstants = require '../constants/progressConstants'

CHANGE_EVENT = 'change'

class ProgressStore extends EventEmitter
  constructor: ->
    @total = -1
    @current = -1
    @dispatcherIndex = appDispatcher.register (payload) =>
      action = payload.action
      switch action.actionType
        when progressConstants.INIT
          @total = action.total
          @current = 0
          @emitChange()
        when progressConstants.INCREMENT
          @current++
          @emitChange()
      true

  emitChange: =>
    @emit CHANGE_EVENT

  addChangeListener: (callback) =>
    @on CHANGE_EVENT, callback

  removeChangeListener: (callback) =>
    @removeListener CHANGE_EVENT, callback

module.exports = ProgressStore
