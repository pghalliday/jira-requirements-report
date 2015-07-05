React = require 'react'
SectionSummary = require './SectionSummary'
SectionTable = require './SectionTable'
Slider = require 'react-slick'

Sections = React.createClass
  render: ->
    sections = this.props.sections
    settings =
      dots: true
      infinite: true
      speed: 500
      slidesToShow: 1
      slidesToScroll: 1
    slides = (<div>
      <SectionSummary
        key={section.key}
        section={section}
        />
    </div> for section in sections when section.requirements.length > 0)
    tables = (<SectionTable
      key={section.key}
      section={section}
      /> for section in sections when section.requirements.length > 0)
    <div className="row">
      <div className="large-12 columns">
        <Slider {...settings}>
          {slides}
        </Slider>
      </div>
      <div>
        {tables}
      </div>
    </div>

module.exports = Sections
