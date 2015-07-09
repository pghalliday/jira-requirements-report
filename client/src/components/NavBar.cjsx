React = require 'react'
appActions = require '../actions/appActions'

NavBar = React.createClass
  _reinitFoundation: ->
    $(document).foundation 'topbar', 'reflow'
    logoutLink = React.findDOMNode(@refs.logoutLink)
    if logoutLink
      prevOnClick = logoutLink.onclick
      logoutLink.onclick = (event) =>
        if prevOnClick
          prevOnClick event
        @_onLogoutClick()
  _onLogoutClick: ->
    appActions.logout()
  componentDidMount: ->
    @_reinitFoundation()
  componentDidUpdate: ->
    @_reinitFoundation()
  render: ->
    title = @props.appStore.title
    user = @props.appStore.user
    logoutSection = if user
      <section className="top-bar-section">
        <ul className="right">
          <li className="divider hide-for-small"/>
          <li className="has-dropdown">
            <a>{user['display-name']}</a>
            <ul className="dropdown">
              <li>
                <a ref="logoutLink"><span>Logout</span></a>
              </li>
            </ul>
          </li>
        </ul>
      </section>
    <div>
      <div className="fixed">
        <nav className="top-bar" data-topbar="" role="navigation" data-options="is_hover: false">
          <ul className="title-area">
            <li className="name">
              <h1><a href="#">{title}</a></h1>
            </li>
            <li className="toggle-topbar menu-icon">
              <a href="#">
                <span>Menu</span>
              </a>
            </li>
          </ul>
          {logoutSection}
        </nav>
      </div>
      <br/>
    </div>

module.exports = NavBar
