@onload = =>
  workspace = document.getElementById 'workspace'
  page = document.getElementById 'page'
  page2 = document.getElementById 'page2'
  pane = new Zonard
  pane
    .boundsTo(page)
    .workspace(workspace)
    .draw()
    .draggiffy()
  pane2 = new Zonard
  pane2
    .boundsTo(page2)
    .workspace(workspace)
    .draw()
    .draggiffy()

  pane.on 'change', (box)->
    console.log 'page', box

  select = document.getElementById 'focus'
  unselect = document.getElementById 'unfocus'

  select.addEventListener 'click', ->
    page.focus on

  unselect.addEventListener 'click', ->
    page.focus off
