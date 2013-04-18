# require eventEmitter
# require draggabilly

class @Zonard extends EventEmitter
  cardinals: 'n ne e se s sw w nw'.split(' ')
  constructor: ()->
    @el = document.createElement('span')
    @el.className = 'zonehandle-main'

    # borders
    @borders = {}
    for dir in 'nesw'
      b = new Border dir
      @borders[dir] = b
      @el.appendChild b.el
      
    # handles
    @handles = {}
    for dir in @cardinals
      h = new Handle dir
      @handles[dir] = h
      @el.appendChild h.el

  workspace: (@workspace)->
    @workspace.appendChild @el
    @

  boundsTo: (el)->
    comp = window.getComputedStyle el
    left = (parseInt comp.getPropertyValue 'left') || 0
    top = (parseInt comp.getPropertyValue 'top') || 0
    @box =
      x1: left
      y1: top
      x2: parseInt(comp.getPropertyValue 'width') + left
      y2: parseInt(comp.getPropertyValue 'height') + top
    @

  draggiffy: ->
    return if @_dragiffied
    for i, handle of @handles
      draggie = new Draggabilly handle.el
      draggie.on 'dragStart', (handle, event, pointer)->
      draggie.on 'dragMove', @onMoveHandle
    for i, border of @borders
      draggie = new Draggabilly border.el
      draggie.on 'dragStart', (border, event, pointer)->
      draggie.on 'dragMove', @onMoveBorder
    @_dragiffied = on
    @

  onMoveHandle: (drag) =>
    re = /dir\-([nsew]{1,2})/
    dir = (re.exec drag.element.className)[1]

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
    border.fitTo @box for dirb, border of @borders
    handle.fitTo @box for dirh, handle of @handles when dirh isnt dir

    # notice the change
    @emit 'change', @box

  onMoveBorder: (drag) =>
    re = /dir\-([nsew]{1,2})/
    dir = (re.exec drag.element.className)[1]

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
    border.fitTo @box for dirb, border of @borders when dirb isnt dir
    handle.fitTo @box for dirh, handle of @handles

    # notice the change
    @emit 'change', @box

  draw: (box) =>
    @box = box if box?
    border.fitTo @box for dir, border of @borders
    handle.fitTo @box for dir, handle of @handles
    @


class Border
  constructor: (@dir)->
    @el = document.createElement 'span'
    @el.className = "zonehandle-border dir-#{@dir}"

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
  constructor: (@dir)->
    @el = document.createElement 'span'
    @el.className = "zonehandle-handle dir-#{@dir}"

  fitTo: (box)->
    if @dir in ['n', 's']
      @el.style.left = box.x1 + (box.x2 - box.x1) / 2 - 2.5 + 'px'
    if @dir in ['e', 'w']
      @el.style.top = box.y1 + (box.y2 - box.y1) / 2 - 2.5 + 'px'
    for d in @dir
      switch d
        when 'n'
          @el.style.top = box.y1 - 5 + 'px'
        when 'e'
          @el.style.left = box.x2 - 5 + 'px'
        when 'w'
          @el.style.left = box.x1 - 5 + 'px'
        when 's'
          @el.style.top = box.y2 - 5 + 'px'
