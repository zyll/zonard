# example of a cropping functionality implemented using zonard as manipulation
# tool over the image

# initializing a zoneHandler (cf zonard)
@onload = =>
 @zh = new ZoneHandler(document.getElementById('page'))
 @crop()

@crop = ->
  @zh.container.style.overflow="hidden"
  #@zh.el.style.top="-100px"

