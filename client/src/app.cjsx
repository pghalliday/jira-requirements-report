React = require 'react'
App = require './components/App'
init = require './lib/init'

if typeof window isnt 'undefined'
  window.onload = ->
    React.render(
      <App />
      document.getElementById 'app'
    )
    init(title, jiraRoot)
