appConstants = require '../constants/appConstants'
appActions = require '../actions/appActions'
superagent = require 'superagent'

module.exports = (uid) ->
  setTimeout appActions.showProgress, 0
  superagent
    .get('/data')
    .query(
      uid: uid
    ).set('Accept', 'application/json')
    .end (error, response) ->
      setTimeout appActions.hideProgress, 2000
      if error and error.status is 400
        appActions.showError response.body.error
      else if error
        appActions.showError error.message
      else
        sections = []
        data = response.body
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
