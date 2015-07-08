React = require 'react'

ErrorNotification = React.createClass
  render: ->
    errorNotification = this.props.errorNotification
    hidden = if errorNotification.hidden then 'hide' else ''
    <div className={hidden}>
      <div className="row">
        <div className="large-12 small-12 columns">
          <div className="panel callout radius">
            {errorNotification.error}
          </div>
        </div>
      </div>
    </div>

module.exports = ErrorNotification
