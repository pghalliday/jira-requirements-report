React = require 'react'
Doughnut = require('react-chartjs').Doughnut

NOTREADY_INDEX = 2
READY_INDEX = 1
DONE_INDEX = 0

Section = React.createClass
  render: ->
    tableStyle =
      width: '100%'
    cellStyle =
      textAlign: 'right'
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
    <div className="row">
      <div className="large-12 columns panel radius">
        <div className="row">
          <div className="large-6 columns">
            <Doughnut data={chartData} options={chartOptions} width="275" height="275" />
          </div>
          <div className="large-6 columns">
            <h3>{section.name}</h3>
            <hr/>
            <table style={tableStyle}>
              <tr>
                <th>Done</th>
                <td style={cellStyle}>{chartData[DONE_INDEX].value}</td>
              </tr>
              <tr>
                <th>Ready</th>
                <td style={cellStyle}>{chartData[READY_INDEX].value}</td>
              </tr>
              <tr>
                <th>Not Ready</th>
                <td style={cellStyle}>{chartData[NOTREADY_INDEX].value}</td>
              </tr>
            </table>
            <hr/>
            <table style={tableStyle}>
              <tr>
                <th>Total</th>
                <td style={cellStyle}>{section.requirements.length}</td>
              </tr>
            </table>
          </div>
        </div>
      </div>
    </div>

module.exports = Section
