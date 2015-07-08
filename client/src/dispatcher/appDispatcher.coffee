Dispatcher = require('flux').Dispatcher
appConstants = require '../constants/appConstants'

class AppDispatcher extends Dispatcher
  handleProgressSocketAction: (action) =>
    @dispatch
      source: appConstants.ACTION_SOURCE_PROGRESS_SOCKET
      action: action
  handleDataRequestAction: (action) =>
    @dispatch
      source: appConstants.ACTION_SOURCE_DATA_REQUEST
      action: action
  handleViewAction: (action) =>
    @dispatch
      source: appConstants.ACTION_SOURCE_VIEW
      action: action
  handleInitAction: (action) =>
    @dispatch
      source: appConstants.ACTION_SOURCE_INIT
      action: action

module.exports = new AppDispatcher()
