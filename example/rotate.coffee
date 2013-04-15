# example of a rotate functionality implemented using zonard as manipulation
# tool over the image

# initializing a zoneHandler (cf zonard)
@onload = =>
  img = document.getElementById 'page'
  zone = new Rotate img
  cursor = document.getElementById 'cursor'
  slider = new Draggabilly cursor, containment: document.getElementById 'slider'
  slider.on 'dragMove', (handle, event, pointer)->
    zone.transform handle.position.x

class Rotate
  constructor: (@el)->
    elStyle = window.getComputedStyle @el
    @zh = new ZoneHandler @el
    @rotate = 0
    
    # settings transform target once
    @_transformVP = null
    for b in ['transform', 'webkitTransform', "MozTransform", 'msTransform', "OTransform"] when @el.style[b]?
      @_transformVP = b

  transform: (deg)->
    deg = deg % 360
    return if @rotate is deg
    @rotate = deg
    @el.style[@_transformVP] = "rotate(#{@rotate}deg)"
    # zone redraw
    box = @el.getBoundingClientRect(@el)
    @zh.pane.draw
      x1: box.left
      y1: box.top
      x2: box.width
      y2: box.height

  draw: (box)=>
    @el.style.width = box.x2 - box.x1 + 'px'
    @el.style.height = box.y2 - box.y1 + 'px'
    #adjust the position of the content
    @el.style.left = box.x1 + 'px'
    @el.style.top =  box.y1 + 'px'
