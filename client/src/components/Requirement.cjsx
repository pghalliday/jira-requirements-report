React = require 'react'
Task = require './Task'

Requirement = React.createClass
  render: ->
    requirement = this.props.requirement
    rows = (<Task
      key={task.key}
      task={task}
    /> for task in requirement.issuelinks)
    <div>
      <div>{requirement.issuetype} - {requirement.key} - {requirement.summary}</div>
      <div>{rows}</div>
    </div>

module.exports = Requirement
