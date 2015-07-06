React = require 'react'
Doughnut = require('react-chartjs').Doughnut
_ = require 'underscore'

NOTREADY_INDEX = 2
READY_INDEX = 1
DONE_INDEX = 0

SectionSummary = React.createClass
  getInitialState: ->
    chartHidden: true
  componentDidMount: ->
    @__onresize = _.debounce @_onresize, 250
    window.addEventListener 'resize', @__onresize
    @setState
      chartHidden: false
  componentWillUnmount: ->
    window.removeEventListener 'resize', @__onresize
  _onresize: ->
    @forceUpdate()
  render: ->
    tableStyle =
      width: '100%'
    cellStyle =
      textAlign: 'right'
    section = @props.section
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
    chart = if @state.chartHidden
      <span>Loading...</span>
    else
      chartId = 'chart-section-' + section.key
      tableId = 'table-section-' + section.key
      tableDivHeight = $('#' + tableId).height()
      chartDivWidth = $('#' + chartId).width()
      chartSize = Math.min(tableDivHeight, chartDivWidth) + 'px'
      chartStyle =
        width: chartSize
        height: chartSize
      console.log chartSize
      chartOptions =
        redraw: true
      if chartSize isnt '0px'
        <Doughnut data={chartData} options={chartOptions} style={chartStyle}/>
      else
        <span>Loading...</span>
    <div className="row">
      <div className="large-12 small-12 columns panel radius">
        <div className="row">
          <div className="large-6 medium-8 small-12 columns" id={chartId}>
            {chart}
          </div>
          <div className="large-6 medium-4 small-12 columns" id={tableId}>
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

module.exports = SectionSummary
