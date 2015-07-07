React = require 'react'

Task = React.createClass
  render: ->
    task = @props.task
    appStore = @props.appStore
    <tr>
      <td>{task.issuetype}</td>
      <td><a href={appStore.jiraRoot + '/browse/' + task.key} target="_blank">{task.key}</a></td>
      <td>{task.summary}</td>
    </tr>

module.exports = Task
