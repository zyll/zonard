# example of a cropping functionality implemented using zonard as manipulation
# tool over the image

# initializing a zoneHandler (cf zonard)
@onload = =>
 zh = new ZoneHandler(document.getElementById('page'))
 @crop = new Crop(zh)

class Crop extends EventEmitter
  constructor: (zh)->
    @zh = zh
    @zh.content.style.overflow = "hidden"

    # keep track of the original dimensions
    # of the image
    #elClientRect = zh.el.getBoundingClientRect()
    @originalImage =
      width: @zh.el.style.width
      height: @zh.el.style.height
      # initial coordinates of the content
      #x0: elClientRect.left
      #y0: elClientRect.top
    #

    @zh.pane.on('change',@cropImage)
  #@zh.container.style.overflow="hidden"
  #@zh.el.style.top="-100px"


  cropImage: =>
    coords = @zh.pane.box
    # adjust the size of the content
    @zh.content.style.width = coords.x2 - coords.x1 + 'px'
    @zh.content.style.height = coords.y2 - coords.y1 + 'px'
    #adjust the position of the content
    @zh.el.style.left = -coords.x1 + 'px'
    @zh.el.style.top = -coords.y1 + 'px'

    @zh.content.style.left = coords.x1 + 'px'
    @zh.content.style.top = coords.y1 + 'px'
