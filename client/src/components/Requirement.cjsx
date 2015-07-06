React = require 'react'
Task = require './Task'
appActions = require '../actions/appActions'

Requirement = React.createClass
  _expandToggle: ->
    appActions.toggleExpandRequirement @props.requirement
  render: ->
    requirement = @props.requirement
    tasksStyle =
      height: if requirement.expanded then 'auto' else '0px'
      overflow: 'hidden'
    rows = (<Task
      key={task.key}
      task={task}
    /> for task in requirement.issuelinks)
    <div>
      <div>{requirement.issuetype} - {requirement.key} - {requirement.summary} - <button onClick={@_expandToggle}>{rows.length} linked issues</button></div>
      <div style={tasksStyle}>{rows}</div>
    </div>

module.exports = Requirement
