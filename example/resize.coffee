# example of a cropping functionality implemented using zonard as manipulation
# tool over the image

# initializing a zoneHandler (cf zonard)
@onload = =>
  workspace = document.getElementById 'workspace'
  page = document.getElementById 'page'
  pane = new Zonard
  pane
    .boundsTo(page)
    .workspace(workspace)
    .draw()
    .draggiffy()
  resize = new Resize page
  pane.on 'change', resize.draw

class Resize
  constructor: (@el)->

  draw: (box)=>
    @el.style.width =  box.x2 - box.x1 + 'px'
    @el.style.height = box.y2 - box.y1 + 'px'
    # adjust the content position
    @el.style.left = box.x1 + 'px'
    @el.style.top = box.y1 + 'px'
