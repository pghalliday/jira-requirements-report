React = require 'react'
Task = require './Task'
appActions = require '../actions/appActions'
classnames = require 'classnames'

Requirement = React.createClass
  _expandToggle: ->
    appActions.toggleExpandRequirement @props.requirement
  render: ->
    requirement = @props.requirement
    total = requirement.issuelinks.length
    complete = requirement.issuelinks.reduce(
      (count, task) ->
        if task.state is 'done'
          ++count
        else
          count
      , 0
    )
    appStore = @props.appStore
    progressClass = classnames
      progress: true
      radius: true
      success: requirement.state is 'done'
      warning: requirement.state is 'ready'
      alert: requirement.state is 'notready'
    percent = if total is 0
      100
    else
      complete / total * 100
    progressStyle =
      minWidth: '3em'
      width: percent + '%'
      color: 'white'
      textAlign: 'center'
    <tr>
      <td>{requirement.issuetype}</td>
      <td><a href={appStore.jiraRoot + '/browse/' + requirement.key} target="_blank">{requirement.key}</a></td>
      <td>{requirement.summary}</td>
      <td className="progressCell">
        <a onClick={@_expandToggle}>
          <div className={progressClass}>
            <span className="meter" style={progressStyle}>
              {complete} / {total}
            </span>
          </div>
        </a>
      </td>
    </tr>

module.exports = Requirement
