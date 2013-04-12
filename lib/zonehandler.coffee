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
    
class Pane
  cardinals: 'n ne e se s sw w nw'.split(' ')
  constructor: (@box)->
    @el = document.createElement('span')
    @el.style.height = @box.height
    @el.style.width = @box.width
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

    # sync borders position
    for b in dir
      if b in ['w', 'e']
        @borders[b].el.style.left = drag.position.x + 'px'
      if b in ['s', 'n']
        @borders[b].el.style.top = drag.position.y + 'px'

    # sync borders size


class Border
  constructor: (@dir, @box)->
    @el = document.createElement 'span'
    @el.className = "zonehandle-border-#{@dir}"
    if @dir in ['n', 's']
      @el.style.width = @box.width + 'px'
      @el.style.height = '2px'
    if @dir in ['e', 'w']
      @el.style.height = @box.height + 'px'
      @el.style.width = '2px'
    if @dir is 'e'
      @el.style.left = @box.width + 'px'
    if @dir is 's'
      @el.style.top = @box.height + 'px'

class Handle
  constructor: (@dir, @box)->
    @el = document.createElement 'span'
    @el.className = "zonehandle-handle dir-#{@dir}"
    if @dir in ['n', 's']
      @el.style.left = @box.width / 2 + 'px'
    if @dir in ['e', 'w']
      @el.style.top = @box.height / 2 + 'px'
    if @dir in ['ne', 'e', 'se']
      @el.style.left = @box.width - 5 + 'px'
    if dir in ['se', 's', 'sw']
      @el.style.top = @box.height - 5 + 'px'
