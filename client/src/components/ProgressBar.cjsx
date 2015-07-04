React = require 'react'

ProgressBar = React.createClass
  render: ->
    progressBar = this.props.progressBar
    label = this.props.label
    progress = if progressBar.total is -1 then '...' else (progressBar.current + '/' + progressBar.total)
    <div>{label} {progress}</div>

module.exports = ProgressBar
