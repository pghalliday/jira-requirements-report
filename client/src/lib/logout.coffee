appActions = require '../actions/appActions'
superagent = require 'superagent'
Q = require 'q'

module.exports = ->
  query = superagent
    .get '/logout'
  Q.ninvoke(query, 'end')
    .then (response) =>
      appActions.loggedOut()
    .done()
