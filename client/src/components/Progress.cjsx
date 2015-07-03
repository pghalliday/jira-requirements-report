React = require 'react'

Progress = React.createClass
  getInitialState: ->
    store = @props.store
    total: store.total
    current: store.current
  componentDidMount: ->
    store = @props.store
    store.addChangeListener @_onChange
  componentWillUnmount: ->
    store = @props.store
    store.removeChangeListener @_onChange
