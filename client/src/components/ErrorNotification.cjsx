React = require 'react'

ErrorNotification = React.createClass
  render: ->
    errorNotification = this.props.errorNotification
    hidden = if errorNotification.hidden then 'hide' else ''
    <div className={hidden}>{errorNotification.error}</div>

module.exports = ErrorNotification
