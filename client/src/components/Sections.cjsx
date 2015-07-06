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
  initialSlide: 0

tablesSettings =
  dots: false
  adaptiveHeight: true
  infinite: true
  speed: 0
  slidesToShow: 1
  slidesToScroll: 1
  arrows: false
  asNavFor: '#section-summaries'

slickSliders = ->
  $('#section-summaries').slick summariesSettings
  $('#section-tables').slick tablesSettings
  # remove reactid attribute from cloned slides so as not to upset react
  $('.slick-cloned').removeAttr 'data-reactid'

unslickSliders = ->
  summariesSettings.initialSlide = $('#section-summaries').slick 'slickCurrentSlide'
  $('#section-summaries').slick 'unslick'
  tablesSettings.initialSlide = $('#section-tables').slick 'slickCurrentSlide'
  $('#section-tables').slick 'unslick'

Sections = React.createClass
  componentDidMount: slickSliders
  componentWillUpdate: unslickSliders
  componentDidUpdate: slickSliders
  render: ->
    sections = this.props.sections
    summaries = (
      <div key={'section-summary-' + section.key}>
        <SectionSummary section={section}/>
      </div> for section in sections when section.requirements.length > 0
    )
    tables = (
      <div key={'section-table-' + section.key}>
        <SectionTable section={section}/>
      </div> for section in sections when section.requirements.length > 0
    )
    <div>
      <div className="row">
        <div className="large-8 columns">
          <div id="section-summaries">
            {summaries}
          </div>
        </div>
      </div>
      <div className="row">
        <div className="large-12 columns">
          <div id="section-tables">
            {tables}
          </div>
        </div>
      </div>
    </div>

module.exports = Sections
