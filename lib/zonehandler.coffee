# require eventEmitter
# require draggabilly

# Add zone limiter ux and reporting capacity to an el.
class @ZoneHandler
  constructor: (@el)->
    elStyle = window.getComputedStyle @el

    # prepare container with an el styled copy
    @container = document.createElement('span')
    @container.className = 'zonehandle-container'
    for style in 'height width height display position top left right'.split ' '
      @container.style[style] = (elStyle[style] || @el[style])
    @container.style.position = 'relative'
    # add a border pane to the container
    @pane = new Pane @el.getBoundingClientRect()

    # repack element inside the container
    parent = @el.parentNode
    parent.replaceChild @container, @el
    #@el.style.position = 'absolute'
    @el.style.top = 0
    @el.style.left = 0
    @container.appendChild @el
    @container.appendChild @pane.el
    @pane.draggiffy()
    
class Pane extends EventEmitter
  cardinals: 'n ne e se s sw w nw'.split(' ')
  constructor: (box)->
    @box =
      x1: 0
      y1: 0
      x2: box.width
      y2: box.height
    @el = document.createElement('span')
    @el.style.height = @box.y2
    @el.style.width = @box.x2
    @el.className = 'zonehandle-main'

    # borders
    @borders = {}
    for dir in 'nesw'
      b = new Border dir, @box
      @borders[dir] = b
      @el.appendChild b.el
      
    # handles
    @handles = {}
    for dir in @cardinals
      h = new Handle dir, @box
      @handles[dir] = h
      @el.appendChild h.el

  draggiffy: ->
    for i, handle of @handles
      draggie = new Draggabilly handle.el
      draggie.on 'dragStart', (handle, event, pointer)->
      draggie.on 'dragMove', @onMoveHandle

  onMoveHandle: (drag, event, pointer) =>
    re = /dir\-([nsew]{1,2})/
    dir = (re.exec drag.element.className)[1]

    # sync sibblings handler
    for h in @cardinals when h isnt dir
      com = (dir.match ///[#{h}]///)?[0]
      if com?.length
        if com in ['w', 'e']
          @handles[h].el.style.left = drag.position.x + 'px'
        if com in ['s', 'n']
          @handles[h].el.style.top = drag.position.y + 'px'

    # sync bounding box positions
    for b in dir
      if b is 'w'
        @box.x1 = drag.position.x
      if b is 'e'
        @box.x2 = drag.position.x
      if b is 'n'
        @box.y1 = drag.position.y
      if b is 's'
        @box.y2 =  drag.position.y

    # sync borders positions
    border.fitTo @box for dir, border of @borders

    # notice the change
    @emit 'change', @box


class Border
  constructor: (@dir, @box)->
    @el = document.createElement 'span'
    @el.className = "zonehandle-border-#{@dir}"
    @fitTo @box

  fitTo: (box)->
    if @dir in ['n', 's']
      @el.style.left = box.x1 + 'px'
      @el.style.width = box.x2 - box.x1 + 'px'
      @el.style.height = '2px'
    if @dir in ['e', 'w']
      @el.style.top = box.y1 + 'px'
      @el.style.height = box.y2 - box.y1 + 'px'
      @el.style.width = '2px'
    if @dir is 'n'
      @el.style.top = box.y1 + 'px'
    if @dir is 'e'
      @el.style.left = box.x2 + 'px'
    if @dir is 'w'
      @el.style.left = box.x1 + 'px'
    if @dir is 's'
      @el.style.top = box.y2 + 'px'

class Handle
  constructor: (@dir, @box)->
    @el = document.createElement 'span'
    @el.className = "zonehandle-handle dir-#{@dir}"
    if @dir in ['n', 's']
      @el.style.left = @box.x2 / 2 + 'px'
    if @dir in ['e', 'w']
      @el.style.top = @box.y2 / 2 + 'px'
    if @dir in ['ne', 'e', 'se']
      @el.style.left = @box.x2 - 5 + 'px'
    if dir in ['se', 's', 'sw']
      @el.style.top = @box.y2 - 5 + 'px'
