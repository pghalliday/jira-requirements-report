appConstants = require '../constants/appConstants'
appActions = require '../actions/appActions'
io = require 'socket.io-client'
superagent = require 'superagent'

module.exports = ->
  progressSocket = io()
  for id in appConstants.PROGRESS_BAR_IDS
    do (id) ->
      progressSocket.on appConstants.PROGRESS_BARS[id].totalMessage, (total) ->
        appActions.initProgress id, total
      progressSocket.on appConstants.PROGRESS_BARS[id].itemMessage, ->
        appActions.incrementProgress id
  progressSocket.on 'connect', ->
    appActions.showProgress()
    superagent.get('/data').set('Accept', 'application/json').end (error, response) ->
      progressSocket.disconnect()
      setTimeout appActions.hideProgress, 2000
      if error and error.status is 400
        appActions.showError response.body.error
      else if error
        appActions.showError error.message
      else
        sections = []
        data = response.body
        console.log data
        for id in appConstants.PROGRESS_BAR_IDS
          total = data[appConstants.PROGRESS_BARS[id].key].length
          appActions.setProgress
            id: id
            total: total
            current: total
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
          requirements: data.requirements.filter (requirement) -> typeof requirement isnt 'undefined'
        appActions.setSections sections
