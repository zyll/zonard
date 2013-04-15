# init of the canvas rendering context
# simple drawing to provide a background
class Canvas extends EventEmitter
  constructor: (domElement, imgSrc)->
    @context = domElement.getContext("2d")
    @el = domElement
    @img = new Image
    @img.src = imgSrc
    # add event listener to redraw the canvas when the
    # event "redraw" is captured
    @on('redraw', @draw)

    # initialize the canvas when the src image
    # is loaded
    @img.onload = =>
      cv = new Canvas(domElement, @img)
      #adjust the canvas' size to the image
      cv.el.width = @img.width
      cv.el.height = @img.height
      @.draw(
        x : 0,
        y : 0
      )

      @emit 'canvasReady'

  # draw some colored rectangles in the canvas...
  draw: (offset) =>
    @context.drawImage(@img ,offset.x ,offset.y)

@Canvas = Canvas
