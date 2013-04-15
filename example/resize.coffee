# example of a cropping functionality implemented using zonard as manipulation
# tool over the image

# initializing a zoneHandler (cf zonard)
@onload = =>
  new Resize document.getElementById 'page'

class Resize
  constructor: (@el)->
    elStyle = window.getComputedStyle @el
    @zh = new ZoneHandler el

    #listen for the events emitted by zonehandler.pane
    @zh.pane.on('change', @draw)

  draw: (box)=>
    @el.style.width = box.x2 - box.x1 + 'px'
    @el.style.height = box.y2 - box.y1 + 'px'
    #adjust the position of the content
    @el.style.left = box.x1 + 'px'
    @el.style.top =  box.y1 + 'px'
