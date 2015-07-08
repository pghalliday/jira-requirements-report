React = require 'react'

NavBar = React.createClass
  render: ->
    title = @props.title
    <div>
      <div className="fixed">
        <nav className="top-bar">
          <ul className="title-area">
            <li className="name">
              <h1><a href="#">{title}</a></h1>
            </li>
          </ul>
        </nav>
      </div>
      <br/>
      <br/>
      <br/>
    </div>

module.exports = NavBar
