appActions = require '../actions/appActions'
superagent = require 'superagent'
Q = require 'q'

module.exports = (username, password) ->
  query = superagent
    .post('/login')
    .send
      username: username
      password: password
  Q.ninvoke(query, 'end')
    .then (response) =>
      data = response.body
      if data.error
        appActions.loginError data.error
      else
        appActions.loggedIn data.user
    .fail (error) =>
      appActions.loginError error
    .done()
