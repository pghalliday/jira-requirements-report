React = require 'react'
Task = require './Task'

RequirementTasks = React.createClass
  render: ->
    requirement = @props.requirement
    appStore = @props.appStore
    rows = (
      <Task
        key={task.key}
        task={task}
        appStore={appStore}
      /> for task in requirement.issuelinks
    )
    <table width="100%">
      {rows}
    </table>

module.exports = RequirementTasks
