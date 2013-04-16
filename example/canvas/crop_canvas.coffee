# example of a cropping functionality implemented using zonard as manipulation
# tool over a canvas element

# initializing a zoneHandler (cf zonard)
@initZH = =>
  @crop = new Crop(@cv.el,@cv)

@onload = =>
  imageSrc = 'http://tdistler.com/media/images/MotivationalProgramming_3.jpg'
  @cv = new Canvas(document.getElementById('page'), imageSrc)
  @cv.on('canvasReady', @initZH)

# Crop has to be called on a canvas already initialized!
class Crop extends EventEmitter
  constructor: (@el, @cv)->
    # el will hold the target content we want to crop
    @zh = new ZoneHandler(@cv.el)
    @zh.focus()
    @el = el
    elStyle = window.getComputedStyle @el

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

    # check if the content considered here is an image
    # or a canvas
    switch (@el.tagName)
      when "IMG"
        @zh.pane.on('change', @cropImage)
      when "CANVAS"
        @zh.pane.on('change', @cropCanvas)


  cropImage: (box)=>
    # adjust the size of the content
    @container.style.width = box.x2 - box.x1 + 'px'
    @container.style.height = box.y2 - box.y1 + 'px'
    #adjust the position of the content
    @el.style.left = -box.x1 + 'px'
    @el.style.top = -box.y1 + 'px'

    @container.style.left = box.x1 + 'px'
    @container.style.top = box.y1 + 'px'

  cropCanvas: (box)=>
    # adjust the size of the content
    @container.style.width = box.x2 - box.x1 + 'px'
    @container.style.height = box.y2 - box.y1 + 'px'
    #adjust the position of the content in the canvas
    @cv.emit('redraw',
      x: -box.x1,
      y: -box.y1
    )

    @container.style.left = box.x1 + 'px'
    @container.style.top = box.y1 + 'px'
