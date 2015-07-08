React = require 'react'
classnames = require 'classnames'

Task = React.createClass
  render: ->
    task = @props.task
    appStore = @props.appStore
    labelClass = classnames
      label: true
      success: task.state is 'done'
      alert: task.state is 'notdone'
    <tr>
      <td><span className={labelClass}>{task.issuetype}</span></td>
      <td><a href={appStore.jiraRoot + '/browse/' + task.key} target="_blank">{task.key}</a></td>
      <td>{task.summary}</td>
      <td><span className="label">{task.sprint.name}</span></td>
    </tr>

module.exports = Task
