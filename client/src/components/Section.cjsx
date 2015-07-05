React = require 'react'
Requirement = require './Requirement'
Doughnut = require('react-chartjs').Doughnut

NOTREADY_INDEX = 2
READY_INDEX = 1
DONE_INDEX = 0

Section = React.createClass
  render: ->
    section = this.props.section
    chartOptions = {}
    chartData = section.requirements.reduce(
      (data, requirement) ->
        switch requirement.state
          when 'notready' then data[NOTREADY_INDEX].value++
          when 'ready' then data[READY_INDEX].value++
          when 'done' then data[DONE_INDEX].value++
        data
      [
        value: 0
        color: '#46BFBD'
        highlight: '#5AD3D1'
        label: 'Done'
      ,
        value: 0
        color: '#FDB45C'
        highlight: '#FFC870'
        label: 'Ready'
      ,
        value: 0
        color: '#F7464A'
        highlight: '#FF5A5E'
        label: 'Not Ready'
      ]
    )
    rows = (<Requirement
      key={requirement.key}
      requirement={requirement}
    /> for requirement in section.requirements when requirement)
    <div>
      <div>{section.name}</div>
      <Doughnut data={chartData} options={chartOptions} width="200" height="200" />
      <div>{rows}</div>
    </div>

module.exports = Section
