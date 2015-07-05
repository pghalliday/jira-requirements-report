React = require 'react'

Task = React.createClass
  render: ->
    task = this.props.task
    <div>{task.issuetype} - {task.key} - {task.summary}</div>

module.exports = Task
