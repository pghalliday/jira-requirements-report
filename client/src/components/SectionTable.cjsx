React = require 'react'
Requirement = require './Requirement'

Section = React.createClass
  render: ->
    section = @props.section
    appStore = @props.appStore
    rows = (<Requirement
      key={requirement.key}
      requirement={requirement}
      appStore={appStore}
    /> for requirement in section.requirements)
    <div className="row">{rows}</div>

module.exports = Section
