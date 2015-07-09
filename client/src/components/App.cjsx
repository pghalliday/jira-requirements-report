React = require 'react'
appStore = require '../stores/appStore'
ErrorNotification = require './ErrorNotification'
ProgressGroup = require './ProgressGroup'
Sections = require './Sections'
NavBar = require './NavBar'
LoginForm = require './LoginForm'

App = React.createClass
  _onChange: ->
    @forceUpdate()
  componentDidMount: ->
    appStore.addChangeListener @_onChange
  componentWillUnmount: ->
    appStore.removeChangeListener @_onChange
  render: ->
    content = if appStore.user
      <div>
        <ProgressGroup progressGroup={appStore.progressGroup}/>
        <ErrorNotification errorNotification={appStore.errorNotification}/>
        <Sections sections={appStore.sections} appStore={appStore}/>
      </div>
    else if appStore.notLoggedIn
      <LoginForm appStore={appStore}/>
    else
      <div className="row">
        <div className="small-12 columns"><center>Connecting...</center></div>
      </div>
    <div>
      <NavBar appStore={appStore}/>
      {content}
    </div>

module.exports = App
