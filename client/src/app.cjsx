React = require 'react'
App = require './components/App'
init = require './lib/init'

React.render(
  <App />
  document.getElementById 'app'
)

init()
