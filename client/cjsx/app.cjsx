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

  sectionHTML = (divId, title) ->
    HTML = '<div class="panel panel-info">'
    HTML += '<div class="panel-heading">'
    HTML += title
    HTML += '</div>'
    HTML += '<div class="panel-body">'
    HTML += '<div id="' + divId + '">'
    HTML += '</div>'
    HTML += '</div>'
    HTML += '</div>'
    HTML

  requirementHTML = (requirement) ->
    panelColor = undefined
    progressValue = undefined
    progressMax = undefined
    progressPercent = undefined
    progressColor = undefined
    requirementColor = undefined
    switch requirement.state
      when 'notready'
        panelColor = 'panel-danger'
        requirementColor = 'list-group-item-danger'
      when 'ready'
        panelColor = 'panel-info'
        requirementColor = 'list-group-item-info'
      when 'done'
        panelColor = 'panel-success'
        requirementColor = 'list-group-item-success'
    tasks = requirement.issuelinks
    progressMax = tasks.length
    if progressMax == 0
      progressValue = 0
      progressPercent = 0
      if requirement.state == 'done'
        progressColor = 'progress-bar-success'
        tasksPanelColor = 'panel-success'
        progressPercent = 100
      else if requirement.state == 'notready'
        progressColor = 'progress-bar-info'
        tasksPanelColor = 'panel-info'
      else
        progressColor = 'progress-bar-danger'
        tasksPanelColor = 'panel-danger'
    else
      progressValue = tasks.reduce(((count, task) ->
        count + (if task.state == 'done' then 1 else 0)
      ), 0)
      if progressValue == progressMax
        progressPercent = 100
        if requirement.state == 'notready'
          progressColor = 'progress-bar-info'
          tasksPanelColor = 'panel-info'
        else
          progressColor = 'progress-bar-success'
          tasksPanelColor = 'panel-success'
      else
        progressPercent = progressValue / progressMax * 100
        if requirement.state == 'done'
          progressColor = 'progress-bar-danger'
          tasksPanelColor = 'panel-danger'
        else
          progressColor = 'progress-bar-info'
          tasksPanelColor = 'panel-info'
    HTML = '<div class="panel ' + panelColor + '">'
    HTML += '<div class="list-group">'
    HTML += '<a class="list-group-item ' + requirementColor + '" href="' + jiraRoot + '/browse/' + requirement.key + '" target="_blank"><span class="label label-default">' + requirement.issuetype + '</span> ' + requirement.key + ' - ' + requirement.summary + '</a>'
    HTML += '</div>'
    HTML += '<div class="panel-body">'
    if progressMax > 0
      HTML += '<a role="button" data-toggle="collapse" href="#collapse' + requirement.id + '">'
    HTML += '<div class="progress">'
    HTML += '<div class="progress-bar ' + progressColor + '" role="progressbar" aria-valuenow="' + progressValue + '" aria-valuemin="0" aria-valuemax="' + progressMax + '" style="min-width: 3em; width: ' + progressPercent + '%;">'
    HTML += '<span id="progress-span">' + progressValue + ' / ' + progressMax + '</span>'
    HTML += '</div>'
    HTML += '</div>'
    if progressMax > 0
      HTML += '</a>'
    HTML += '</div>'
    HTML += '<div id="collapse' + requirement.id + '" class="panel-collapse collapse">'
    HTML += '<div class="list-group" style="padding: 0px 15px 15px;">'
    tasks.forEach (task) ->
      taskColor = if task.state == 'done' then 'list-group-item-success' else 'list-group-item-danger'
      HTML += '<a class="list-group-item ' + taskColor + '" href="' + jiraRoot + '/browse/' + task.key + '" target="_blank"><span class="label label-default">' + task.issuetype + '</span> ' + task.key + ' - ' + task.summary + '</a>'
      return
    HTML += '</div>'
    HTML += '</div>'
    HTML += '</div>'
    HTML

  renderData = (data) ->
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
      renderSprint sprint
      return
    renderBacklog data.requirements
    return

  addSection = (divId, title) ->
    sectionsDiv = $('#sections')
    sectionsDiv.append sectionHTML(divId, title)
    return

  renderSprint = (sprint) ->
    addSection 'sprint-' + sprint.id, sprint.name
    requirementList = $('#sprint-' + sprint.id)
    sprint.issues.forEach (requirement) ->
      requirementList.append requirementHTML(requirement)
      return
    return

  renderBacklog = (requirements) ->
    addSection 'backlog-requirements', 'Backlog'
    requirementList = $('#backlog-requirements')
    requirements.forEach (requirement) ->
      requirementList.append requirementHTML(requirement)
      return
    return

  return
