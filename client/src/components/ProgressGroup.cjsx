React = require 'react'
ProgressBar = require './ProgressBar'
appConstants = require '../constants/appConstants'

ProgressGroup = React.createClass
  render: ->
    progressGroup = this.props.progressGroup
    hidden = if progressGroup.hidden then 'hide' else ''
    rows = (<ProgressBar
      key={appConstants.PROGRESS_BARS[id].key}
      progressBar={progressGroup.progressBars[id]}
      label={appConstants.PROGRESS_BARS[id].label}
    /> for id in appConstants.PROGRESS_BAR_IDS)
    <div className={hidden}>
      <div className="row">
        <div className="large-12 columns">
          <div>Querying JIRA requirements data ...</div>
          {rows}
        </div>
      </div>
    </div>

module.exports = ProgressGroup
