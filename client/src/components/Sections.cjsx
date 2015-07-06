React = require 'react'
SectionSummary = require './SectionSummary'
SectionTable = require './SectionTable'

summariesSettings =
  dots: true
  infinite: true
  speed: 500
  slidesToShow: 1
  slidesToScroll: 1
  asNavFor: '#section-tables'

tablesSettings =
  dots: false
  infinite: true
  speed: 0
  slidesToShow: 1
  slidesToScroll: 1
  arrows: false
  asNavFor: '#section-summaries'

slickSliders = ->
  $('#section-summaries').slick summariesSettings
  $('#section-tables').slick tablesSettings

unslickSliders = ->
  $('#section-summaries').slick 'unslick'
  $('#section-tables').slick 'unslick'

Sections = React.createClass
  componentDidMount: slickSliders
  componentWillUpdate: unslickSliders
  componentDidUpdate: slickSliders
  render: ->
    sections = this.props.sections
    summaries = (
      <div>
        <SectionSummary
          key={section.key}
          section={section}
        />
      </div> for section in sections when section.requirements.length > 0
    )
    tables = (
      <div>
        <SectionTable
          key={section.key}
          section={section}
        />
      </div> for section in sections when section.requirements.length > 0
    )
    <div className="row">
      <div className="large-12 columns">
        <div id="section-summaries">
          {summaries}
        </div>
      </div>
      <div className="large-12 columns">
        <div id="section-tables">
          {tables}
        </div>
      </div>
    </div>

module.exports = Sections
