React = require 'react'

ProgressBar = React.createClass
  render: ->
    progressBar = this.props.progressBar
    label = this.props.label
    progress = if progressBar.total is -1 then '...' else (progressBar.current + '/' + progressBar.total)
    percent = switch progressBar.total
      when -1 then 0
      when 0 then 100
      else (progressBar.current / progressBar.total) * 100
    style =
      width: percent + '%'
      minWidth: '12em'
      paddingLeft: '10px'
      color: 'white'
      transition: 'width 0.5s ease'
    <div className="progress radius">
      <span className="meter" style={style}>{label} {progress}</span>
    </div>

module.exports = ProgressBar
