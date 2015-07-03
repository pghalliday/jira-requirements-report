React = require 'react'
Requirement = require './Requirement'

Section = React.createClass
  render: ->
    section = this.props.section
    rows = (<Requirement
      key={requirement.key}
      requirement={requirement}
    /> for requirement in section.requirements when requirement)
    <div>
      <div>{section.name}</div>
      <div>{rows}</div>
    </div>

module.exports = Section
