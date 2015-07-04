module.exports =
  PROGRESS_BAR_IDS: [0..2]
  PROGRESS_BARS: [
    key: 'requirementSprints'
    totalMessage: 'requirementSprintsTotal'
    itemMessage: 'requirementSprint'
    label: 'Requirement Sprints'
  ,
    key: 'taskSprints'
    totalMessage: 'taskSprintsTotal'
    itemMessage: 'taskSprint'
    label: 'Task Sprints'
  ,
    key: 'requirements'
    totalMessage: 'requirementsTotal'
    itemMessage: 'requirement'
    label: 'Requirements'
  ]

  ACTION_SET_JIRA_ROOT: 'setJiraRoot'
  ACTION_ADD_SECTION: 'addSection'
  ACTION_ERROR_SHOW: 'errorShow'
  ACTION_PROGRESS_SHOW: 'progressShow'
  ACTION_PROGRESS_HIDE: 'progressHide'
  ACTION_PROGRESS_INIT: 'progressInit'
  ACTION_PROGRESS_SET: 'progressSet'
  ACTION_PROGRESS_INCREMENT: 'progressIncrement'

  ACTION_SOURCE_PROGRESS_SOCKET: 'progressSocket'
  ACTION_SOURCE_DATA_REQUEST: 'dataRequest'