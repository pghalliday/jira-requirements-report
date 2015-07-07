React = require 'react'

Task = React.createClass
  render: ->
    task = @props.task
    appStore = @props.appStore
    <div>{task.issuetype} - {task.key} - {task.summary}</div>

module.exports = Task
