React = require 'react'
Requirement = require './Requirement'
RequirementTasks = require './RequirementTasks'
ReactCSSTransitionGroup = require 'react/lib/ReactCSSTransitionGroup'
_ = require 'underscore'

SectionTable = React.createClass
  render: ->
    section = @props.section
    appStore = @props.appStore
    requirementRows = (
      <Requirement
        key={'requirement-' + requirement.key}
        requirement={requirement}
        appStore={appStore}
      /> for requirement in section.requirements
    )
    requirementTasksRows = (
      for requirement in section.requirements
        rowKey = 'requirement-tasks-row' + requirement.key
        requirementTasks = if requirement.expanded
          <RequirementTasks
            requirement={requirement}
            appStore={appStore}
          />
        transitionGroup =
          <ReactCSSTransitionGroup
            transitionName="tasks"
            key={'requirement-tasks-' + requirement.key}
          >
            {requirementTasks}
          </ReactCSSTransitionGroup>
        if requirement.expanded
          <tr key={rowKey}><td colSpan="4">{requirementTasks}</td></tr>
        else
          <tr key={rowKey} className="hide"><td colSpan="4">{requirementTasks}</td></tr>
    )
    rows = _.flatten _.zip(requirementRows, requirementTasksRows), true
    <table width="100%">{rows}</table>

module.exports = SectionTable
