# example of a cropping functionality implemented using zonard as manipulation
# tool over the image

# initializing a zoneHandler (cf zonard)
@onload = =>
  new Crop document.getElementById 'page'

class Crop extends EventEmitter
  constructor: (@el)->
    elStyle = window.getComputedStyle @el
    @zh = new ZoneHandler el

    # we relocate the el in a subcontainer to facilitate
    # the manipulation
    @container = document.createElement('span')
    @container.className = 'content-subcontainer'
    @container.style.position = 'relative'
    @container.style.overflow = "hidden"
    for style in 'height width height display position top left right'.split ' '
      @container.style[style] = (elStyle[style] || @el[style])

    # we detach el from its parent, and replace it by the subcontainer
    parent = @el.parentNode
    parent.replaceChild @container, @el
    @container.appendChild @el

    #listen for the events emitted by zonehandler.pane
    @zh.pane.on('change', @draw)

  draw: (box)=>
    # adjust the size of the content
    @container.style.width = box.x2 - box.x1 + 'px'
    @container.style.height = box.y2 - box.y1 + 'px'
    #adjust the position of the content
    @el.style.left = -box.x1 + 'px'
    @el.style.top = -box.y1 + 'px'

    @container.style.left = box.x1 + 'px'
    @container.style.top = box.y1 + 'px'
