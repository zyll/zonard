@onload = =>
  bibi = new @ZoneHandler document.getElementById 'bibi'
  page = new @ZoneHandler document.getElementById 'page'
  page.pane.on 'change', (box)->
    console.log 'page', box
  bibi.pane.on 'change', (box)->
    console.log 'bibi', box
