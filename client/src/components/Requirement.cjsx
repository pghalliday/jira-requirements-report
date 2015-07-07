React = require 'react'
Task = require './Task'
appActions = require '../actions/appActions'

Requirement = React.createClass
  _expandToggle: ->
    appActions.toggleExpandRequirement @props.requirement
  render: ->
    requirement = @props.requirement
    complete = requirement.issuelinks.reduce(
      (count, task) ->
        if task.state is 'done'
          ++count
        else
          count
      , 0
    )
    appStore = @props.appStore
    <tr>
      <td>{requirement.issuetype}</td>
      <td><a href={appStore.jiraRoot + '/browse/' + requirement.key} target="_blank">{requirement.key}</a></td>
      <td>{requirement.summary}</td>
      <td><a onClick={@_expandToggle}><span className="label">{complete} / {requirement.issuelinks.length}</span></a></td>
    </tr>

module.exports = Requirement
