React = require 'react'
appActions = require '../actions/appActions'
classnames = require 'classnames'

LoginForm = React.createClass
  _handleUsernameKeyCode: (event) ->
    if event.keyCode is 13
      passwordInput = React.findDOMNode @refs.password
      passwordInput.focus()
  _handlePasswordKeyCode: (event) ->
    if event.keyCode is 13
      button = React.findDOMNode @refs.button
      button.click()
  _handleUsernameChange: (event) ->
    @setState
      username: event.target.value
      password: @state.password
  _handlePasswordChange: (event) ->
    @setState
      username: @state.username
      password: event.target.value
  _handleButtonClick: ->
    appActions.login
      username: @state.username
      password: @state.password
  componentDidMount: ->
    usernameInput = React.findDOMNode @refs.username
    usernameInput.focus()
  componentDidUpdate: ->
    appStore = @props.appStore
    if appStore.loginError
      @_previousErrorId = @_errorId
      @_errorId = appStore.loginErrorId
      if @_previousErrorId isnt @_errorId
        usernameInput = React.findDOMNode @refs.username
        usernameInput.focus()
  getInitialState: ->
    username: ''
    password: ''
  render: ->
    appStore = @props.appStore
    username = @state.username
    password = @state.password
    error = appStore.loginError.message if appStore.loginError
    errorClass = classnames
      panel: true
      radius: true
      hide: typeof error is 'undefined'
      callout: true
    <div className="row">
      <div className="large-offset-3 large-6 medium-offset-2 medium-8 small-12 columns">
        <div className={errorClass}>
          {error}
        </div>
        <div className="panel radius">
          <input
            ref="username"
            onKeyDown={@_handleUsernameKeyCode}
            onChange={@_handleUsernameChange}
            type="text"
            value={username}
            placeholder="username"
            autofocus=""
          />
          <input
            ref="password"
            onKeyDown={@_handlePasswordKeyCode}
            onChange={@_handlePasswordChange}
            type="password"
            value={password}
            placeholder="password"
          />
          <button
            ref="button"
            onClick={@_handleButtonClick}
          >
            Log in
          </button>
        </div>
      </div>
    </div>

module.exports = LoginForm
