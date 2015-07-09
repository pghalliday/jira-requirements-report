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
  speed: 500
  slidesToShow: 1
  slidesToScroll: 1
  arrows: false
  asNavFor: '#section-summaries'

Sections = React.createClass
  _updateSlicks: ->
    sections = @props.sections
    if sections and not @_slickApplied
      $('#section-summaries').slick summariesSettings
      $('#section-tables').slick tablesSettings
      # remove reactid attribute from cloned slides so as not to upset react
      $('.slick-cloned').removeAttr 'data-reactid'
      $('.slick-cloned').find('*').removeAttr 'data-reactid'
      @_slickApplied = true
    else if not sections and @_slickApplied
      $('#section-summaries').slick 'unslick'
      $('#section-tables').slick 'unslick'
      @_slickApplied = false
  componentDidMount: ->
    @_slickApplied = false
    @_updateSlicks()
  componentDidUpdate: ->
    @_updateSlicks()
  render: ->
    sections = @props.sections
    appStore = @props.appStore
    summaries = []
    tables = []
    if sections
      summaries = (
        <div key={'section-summary-' + section.key}>
          <SectionSummary section={section} appStore={appStore}/>
        </div> for section in sections when section.requirements.length > 0
      )
      tables = (
        <div key={'section-table-' + section.key}>
          <SectionTable section={section} appStore={appStore}/>
        </div> for section in sections when section.requirements.length > 0
      )
    <div>
      <div className="row">
        <div className="large-8 large-offset-2 small-8 small-offset-2 columns">
          <div id="section-summaries">
            {summaries}
          </div>
        </div>
      </div>
      <div className="row">
        <div className="large-12 small-12 columns">
          <div id="section-tables">
            {tables}
          </div>
        </div>
      </div>
    </div>

module.exports = Sections
