React = require 'react'
Chartjs = require 'chart.js'
_ = require 'underscore'

NOTREADY_INDEX = 2
READY_INDEX = 1
DONE_INDEX = 0

chartOptions =
  redraw: true
  animation: false

SectionSummary = React.createClass
  _onresize: ->
    tableDiv = $ '#' + @_tableDivId
    chartDiv = $ '#' + @_chartDivId
    chartDivHorizontalPadding = parseInt(chartDiv.css('padding-left'))
    chartSize = (Math.min(tableDiv.innerHeight(), chartDiv.innerWidth()) - chartDivHorizontalPadding) + 'px'
    @_chartCanvas.height(chartSize)
    @_chartCanvas.width(chartSize)
    # replace cloned chart images with new sizes
    @_replaceClonedCharts()
  _replaceClonedCharts: ->
    if @_chart
      slickCloned = $ '.slick-cloned'
      clonedChart = slickCloned.find '.' + @_chartClass
      clonedChart.replaceWith '<img src="' + @_chart.toBase64Image() + '"/>'
  componentDidMount: ->
    section = @props.section
    @__onresize = _.debounce @_onresize, 250
    window.addEventListener 'resize', @__onresize
    @_chartCanvas = $ '#' + @_chartClass
    @_onresize()
    @_chart = new Chartjs(@_chartCanvas.get(0).getContext('2d')).Doughnut @_chartData, chartOptions
    # replace chart elements in cloned slides with images (but wait
    # until the slider has actually been initialized)
    setTimeout @_replaceClonedCharts, 0
  componentWillUnmount: ->
    window.removeEventListener 'resize', @__onresize
  render: ->
    tableStyle =
      width: '100%'
    cellStyle =
      textAlign: 'right'
    section = @props.section
    @_chartClass = 'section-summary-chart-' + section.key
    @_chartData = section.requirements.reduce(
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
    @_chartDivId = 'section-summary-chart-div-' + section.key
    @_tableDivId = 'section-summary-table-div-' + section.key
    chartStyle =
      padding: 0
      margin: 'auto'
      display: 'block'
    <div className="row">
      <div className="large-12 small-12 columns panel radius">
        <div className="row">
          <div className="large-6 medium-8 small-12 columns" id={@_chartDivId}>
            <canvas id={@_chartClass}  className={@_chartClass} style={chartStyle}/>
          </div>
          <div className="large-6 medium-4 small-12 columns" id={@_tableDivId}>
            <h3>{section.name}</h3>
            <hr/>
            <table style={tableStyle}>
              <tr>
                <th>Done</th>
                <td style={cellStyle}>{@_chartData[DONE_INDEX].value}</td>
              </tr>
              <tr>
                <th>Ready</th>
                <td style={cellStyle}>{@_chartData[READY_INDEX].value}</td>
              </tr>
              <tr>
                <th>Not Ready</th>
                <td style={cellStyle}>{@_chartData[NOTREADY_INDEX].value}</td>
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
