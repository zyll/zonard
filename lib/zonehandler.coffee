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
    @pane = document.createElement('span')
    @pane.style.height = elStyle.height
    @pane.style.width = elStyle.width
    @pane.className = 'zonehandle-main'
    # borders
    @borders = {}
    for b in 'nesw'
      i = document.createElement 'span'
      i.className = "zonehandle-border-#{b}"
      @pane.appendChild i
      @borders[b] = i
    # handles
    @handles = {}
    for b in 'n ne e se s sw w nw'.split(' ')
      i = document.createElement 'span'
      i.className = "zonehandle-handle dir-#{b}"
      if b in ['n', 's']
        i.style.left = @el.getBoundingClientRect().width / 2 + 'px'
      if b in ['e', 'w']
        i.style.top = @el.getBoundingClientRect().height / 2 + 'px'
      if b in ['ne', 'e', 'se']
        i.style.left = @el.getBoundingClientRect().width - 5 + 'px'
      if b in ['se', 's', 'sw']
        i.style.top = @el.getBoundingClientRect().height - 5 + 'px'
      @handles[b] = i
      @pane.appendChild i

    # repack element inside the container
    parent = @el.parentNode
    parent.replaceChild @container, @el
    #@el.style.position = 'absolute'
    @el.style.top = 0
    @el.style.left = 0
    @container.appendChild @pane
    @container.appendChild @el

    @draggiffy()
    
  draggiffy: ->
    re = /dir\-([nsew]{1,2})/
    for i, handle of @handles
      draggie = new Draggabilly handle
      draggie.on 'dragStart', (handle, event, pointer)->
      draggie.on 'dragMove', (handle, event, pointer)=>
        dir = (re.exec handle.element.className)[1]
        if /n/.test dir
          @handles.ne.style.top = handle.position.y + 'px' unless dir is 'ne'
          @handles.n.style.top = handle.position.y + 'px' unless dir is 'n'
          @handles.nw.style.top = handle.position.y + 'px' unless dir is 'nw'
          @borders.n.style.top = handle.position.y + 'px'
      draggie.on 'dragEnd', (handle, event, pointer)->

    for border in @borders
      draggie = new Draggabilly border, containment: document.body
