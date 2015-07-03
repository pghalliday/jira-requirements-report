React = require 'react'
Sections = require './Sections'

$ ->
  dataSocket = io()
  requirementSprintsProgress = 0
  requirementSprintsTotal = 0
  taskSprintsProgress = 0
  taskSprintsTotal = 0
  requirementsProgress = 0
  requirementsTotal = 0
  jiraRoot = undefined

  updateRequirementSprintsProgress = ->
    percent = requirementSprintsProgress / requirementSprintsTotal * 100
    $('#requirement-sprints-progress-bar').attr 'aria-valuemax', requirementSprintsTotal
    $('#requirement-sprints-progress-bar').css('width', percent + '%').attr 'aria-valuenow', requirementSprintsProgress
    $('#requirement-sprints-progress-span').text 'Requirement Sprints ' + requirementSprintsProgress + '/' + requirementSprintsTotal
    return

  dataSocket.on 'requirementSprintsTotal', (total) ->
    requirementSprintsTotal = total
    requirementSprintsProgress = 0
    updateRequirementSprintsProgress()
    return
  dataSocket.on 'requirementSprint', ->
    requirementSprintsProgress++
    updateRequirementSprintsProgress()
    return

  updateTaskSprintsProgress = ->
    percent = taskSprintsProgress / taskSprintsTotal * 100
    $('#task-sprints-progress-bar').attr 'aria-valuemax', taskSprintsTotal
    $('#task-sprints-progress-bar').css('width', percent + '%').attr 'aria-valuenow', taskSprintsProgress
    $('#task-sprints-progress-span').text 'Task Sprints ' + taskSprintsProgress + '/' + taskSprintsTotal
    return

  dataSocket.on 'taskSprintsTotal', (total) ->
    taskSprintsTotal = total
    taskSprintsProgress = 0
    updateTaskSprintsProgress()
    return
  dataSocket.on 'taskSprint', ->
    taskSprintsProgress++
    updateTaskSprintsProgress()
    return

  updateRequirementsProgress = ->
    percent = requirementsProgress / requirementsTotal * 100
    $('#requirements-progress-bar').attr 'aria-valuemax', requirementsTotal
    $('#requirements-progress-bar').css('width', percent + '%').attr 'aria-valuenow', requirementsProgress
    $('#requirements-progress-span').text 'Requirements ' + requirementsProgress + '/' + requirementsTotal
    return

  dataSocket.on 'requirementsTotal', (total) ->
    requirementsTotal = total
    requirementsProgress = 0
    updateRequirementsProgress()
    return
  dataSocket.on 'requirement', ->
    requirementsProgress++
    updateRequirementsProgress()
    return
  dataSocket.on 'init', (_jiraRoot) ->
    $('#progress-panel').removeClass 'hidden'
    jiraRoot = _jiraRoot
    return
  dataSocket.on 'connect', ->
    $.ajax(
      url: '/data'
      accepts: 'application/json').done (data) ->
      dataSocket.disconnect()
      requirementSprintsTotal = data.requirementSprints.length
      requirementSprintsProgress = data.requirementSprints.length
      updateRequirementSprintsProgress()
      taskSprintsTotal = data.taskSprints.length
      taskSprintsProgress = data.taskSprints.length
      updateTaskSprintsProgress()
      requirementsTotal = data.requirements.length
      requirementsProgress = data.requirements.length
      updateRequirementsProgress()
      setTimeout (->
        $('#progress-panel').addClass 'hidden'
        return
      ), 1000
      renderData data
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

  return
