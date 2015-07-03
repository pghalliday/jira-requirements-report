React = require 'react'
Section = require './Section'

Sections = React.createClass
  render: ->
    sections = this.props.sections
    rows = (<Section
      key={section.key}
      section={section}
    /> for section in sections)
    <div>{rows}</div>

module.exports = Sections
