React = require 'react'
appStore = require '../stores/appStore'
ErrorNotification = require './ErrorNotification'
ProgressGroup = require './ProgressGroup'
Sections = require './Sections'

App = React.createClass
  _onChange: ->
    @forceUpdate()
  componentDidMount: ->
    appStore.addChangeListener @_onChange
  componentWillUnmount: ->
    appStore.removeChangeListener @_onChange
  render: ->
    <div>
      <ProgressGroup progressGroup={appStore.progressGroup}/>
      <ErrorNotification errorNotification={appStore.errorNotification}/>
      <Sections sections={appStore.sections} appStore={appStore}/>
    </div>

module.exports = App
