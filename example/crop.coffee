# example of a cropping functionality implemented using zonard as manipulation
# tool over the image

# initializing a zoneHandler (cf zonard)
@onload = =>
  zh = new ZoneHandler(document.getElementById('page'))
  @crop = new Crop(zh.el, zh.pane)

class Crop extends EventEmitter
  constructor: (el, zhpane)->
    # el will hold the target content we want to crop
    @el = el
    elStyle = window.getComputedStyle @el

    # we relocate the el in a subcontainer to facilitate
    # the manipulation
    @elContainer = document.createElement('span')
    @elContainer.className = 'content-subcontainer'
    @elContainer.style.position = 'relative'
    @elContainer.style.overflow = "hidden"
    for style in 'height width height display position top left right'.split ' '
      @elContainer.style[style] = (elStyle[style] || @el[style])

    # we detach el from its parent, and replace it by the subcontainer
    parent = @el.parentNode
    parent.replaceChild @elContainer, @el

    @elContainer.appendChild @el

    # keep track of the original dimensions
    # of the image
    #elClientRect = zh.el.getBoundingClientRect()
    @originalImage =
      width: @el.style.width
      height: @el.style.height
      # initial coordinates of the content
      #x0: elClientRect.left
      #y0: elClientRect.top
    #

    #listen for the events emitted by zonehandler.pane
    zhpane.on('change',@cropImage)


  cropImage: (box)=>
    coords = box
    # adjust the size of the content
    @elContainer.style.width = coords.x2 - coords.x1 + 'px'
    @elContainer.style.height = coords.y2 - coords.y1 + 'px'
    #adjust the position of the content
    @el.style.left = -coords.x1 + 'px'
    @el.style.top = -coords.y1 + 'px'

    @elContainer.style.left = coords.x1 + 'px'
    @elContainer.style.top = coords.y1 + 'px'
