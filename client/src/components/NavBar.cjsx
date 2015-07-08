React = require 'react'

NavBar = React.createClass
  render: ->
    title = @props.title
    <div className="row">
      <div className="large-12 small-12 columns">
        <center>
          <h1>{title}</h1>
        </center>
      </div>
    </div>

module.exports = NavBar
