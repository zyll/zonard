@onload = =>
  bibi = new @ZoneHandler document.getElementById 'bibi'
  bibi.focus on
  page = new @ZoneHandler document.getElementById 'page'
  page.pane.on 'change', (box)->
    console.log 'page', box
  bibi.pane.on 'change', (box)->
    console.log 'bibi', box

  select = document.getElementById 'focus'
  unselect = document.getElementById 'unfocus'

  select.addEventListener 'click', ->
    page.focus on

  unselect.addEventListener 'click', ->
    page.focus off
