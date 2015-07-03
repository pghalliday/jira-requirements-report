React = require 'react'
Sections = require './components/Sections'
io = require 'socket.io-client'
request = require 'superagent'

dataSocket = io()
requirementSprintsProgress = 0
requirementSprintsTotal = 0
taskSprintsProgress = 0
taskSprintsTotal = 0
requirementsProgress = 0
requirementsTotal = 0
jiraRoot = undefined

dataSocket.on 'requirementSprintsTotal', (total) ->
  return

dataSocket.on 'requirementSprint', ->
  return

updateTaskSprintsProgress = ->
  return

dataSocket.on 'taskSprintsTotal', (total) ->
  return
dataSocket.on 'taskSprint', ->
  return

dataSocket.on 'requirementsTotal', (total) ->
  return

dataSocket.on 'requirement', ->
  return

dataSocket.on 'init', (_jiraRoot) ->
  return

dataSocket.on 'connect', ->
  request.get('/data').set('Accept', 'application/json').end (error, response) ->
    dataSocket.disconnect()
    if error
      console.log error
    else
      renderData response.body
    return
  return

renderData = (data) ->
  sections = []
  taskSprintsbyTaskId = data.taskSprints.reduce(((index, sprint) ->
    sprint.issues.forEach (issue) ->
      index[issue] = sprint
      return
    index
  ), Object.create(null))
  data.requirements.forEach (requirement) ->
    requirement.issuelinks.forEach (task) ->
      task.sprint = taskSprintsbyTaskId[task.id]
      return
    return
  requirementsIndex = data.requirements.reduce(((index, requirement, i) ->
    index[requirement.id] = i
    index
  ), Object.create(null))
  data.requirementSprints.forEach (sprint) ->
    sprint.issues.forEach (requirementId, i, issues) ->
      requirement = data.requirements[requirementsIndex[requirementId]]
      if requirement
        delete data.requirements[requirementsIndex[requirementId]]
        issues[i] = requirement
      else
        delete issues[i]
      return
    sections.push
      key: 'sprint-' + sprint.id
      name: sprint.name
      requirements: sprint.issues
    return
  sections.push
    key: 'backlog'
    name: 'Backlog'
    requirements: data.requirements
  React.render(
    <Sections
      sections={sections}
    />
    document.getElementById 'sections'
  )
  return

