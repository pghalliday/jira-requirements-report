React = require 'react'

Requirement = React.createClass
  render: ->
    requirement = this.props.requirement
    <div>{requirement.key} - {requirement.summary}</div>

module.exports = Requirement
