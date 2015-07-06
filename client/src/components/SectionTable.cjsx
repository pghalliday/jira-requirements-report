React = require 'react'
Requirement = require './Requirement'

Section = React.createClass
  render: ->
    section = this.props.section
    rows = (<Requirement
      key={requirement.key}
      requirement={requirement}
    /> for requirement in section.requirements)
    <div className="row">{rows}</div>

module.exports = Section
