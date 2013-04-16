# example of an implementation with several effects
# the crop manipulation and the resize manipulation
# are possible once they are selected with the
# buttons at the top of the page

@onload = =>

  el = document.getElementById("page")
  @zh = new ZoneHandler el
  @crop = new Crop(el, zh)
  @resize = new Resize(el, zh)

  document.getElementById("crop").onclick = =>
    if @resize.active is on then @resize.stop()
    if @zh.isFocus? and @zh.isFocus is on then @crop.stop()
    else @crop.start()

  document.getElementById("resize").onclick = =>
    if @crop.active is on then @crop.stop()
    if @zh.isFocus? and @zh.isFocus is on then @resize.stop()
    else @resize.start()

class Crop extends EventEmitter
  constructor: (@el,@zh)->
    # parameter that is on when the functionality is active
    @active = off

    elStyle = window.getComputedStyle @el
    # we relocate the el in a subcontainer to facilitate
    # the manipulation
    @container = document.createElement('span')
    @container.className = 'content-subcontainer'
    @container.style.position = 'relative'
    @container.style.overflow = "hidden"
    for style in 'height width height display position top left right'.split ' '
      @container.style[style] = (elStyle[style] || @el[style])

  start: =>
    # we detach el from its parent, and replace it by the subcontainer
    if @el.parentNode isnt @container
      @parent = @el.parentNode
      @parent.replaceChild @container, @el
      @container.appendChild @el

    # we render the zoneHandler
    @zh.focus()
    #listen for the events emitted by zonehandler.pane
    @zh.pane.on('change', @draw)
    @active = on

  stop: =>
    # we put back the el to its original position in the DOM

    #@container.removeChild @el
    #@parent.appendChild @el
    # we withdraw the zonehandler
    @zh.focus(off)
    #listen for the events emitted by zonehandler.pane
    @zh.pane.off('change', @draw)
    @active = off

  draw: (box)=>
    # adjust the size of the content
    @container.style.width = box.x2 - box.x1 + 'px'
    @container.style.height = box.y2 - box.y1 + 'px'
    #adjust the position of the content
    @el.style.left = -box.x1 + 'px'
    @el.style.top = -box.y1 + 'px'

    @container.style.left = box.x1 + 'px'
    @container.style.top = box.y1 + 'px'

class Resize
  constructor: (@el, @zh)->
    # parameter that is on when the functionality is active
    @active = off
    elStyle = window.getComputedStyle @el

  start: ->
    #listen for the events emitted by zonehandler.pane
    @zh.focus()
    @zh.pane.on('change', @draw)
    @active = on

  stop: ->
    @zh.focus(off)
    @zh.pane.off('change', @draw)
    @active = off

  draw: (box)=>
    @el.style.width = box.x2 - box.x1 + 'px'
    @el.style.height = box.y2 - box.y1 + 'px'
    #adjust the position of the content
    @el.style.left = box.x1 + 'px'
    @el.style.top =  box.y1 + 'px'
