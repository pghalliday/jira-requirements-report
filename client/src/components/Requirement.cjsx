React = require 'react'
Task = require './Task'
appActions = require '../actions/appActions'
ReactCSSTransitionGroup = require 'react/lib/ReactCSSTransitionGroup'

Requirement = React.createClass
  _expandToggle: ->
    appActions.toggleExpandRequirement @props.requirement
  render: ->
    requirement = @props.requirement
    rows = if requirement.expanded
      (<Task
        key={task.key}
        task={task}
      /> for task in requirement.issuelinks)
    else
      []
    <div>
      <div>{requirement.issuetype} - {requirement.key} - {requirement.summary} - <button onClick={@_expandToggle}>{requirement.issuelinks.length} linked issues</button></div>
      <ReactCSSTransitionGroup transitionName="tasks">
        {rows}
      </ReactCSSTransitionGroup>
    </div>

module.exports = Requirement
