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
        <Sections sections={appStore.sections} appStore={appStore}/>
      </div>
    else
      <LoginForm appStore={appStore}/>
    <div>
      <NavBar appStore={appStore}/>
      <ErrorNotification errorNotification={appStore.errorNotification}/>
      {content}
    </div>

module.exports = App
