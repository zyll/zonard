# Add zone limiter ux and reporting capacity to an el.
class @ZoneHandler

  constructor: (@el)->
    elStyle = window.getComputedStyle @el

    # prepare container with an el styled copy
    @container = document.createElement('span')
    @container.className = 'zonehandle-container'
    for style in 'height width height display position top left right'.split ' '
      @container.style[style] = (elStyle[style] || @el[style])?.replace('static', 'relative')

    # add a border pane to the container
    @pane = document.createElement('span')
    @pane.style.height = elStyle.height
    @pane.style.width = elStyle.width
    @pane.className = 'zonehandle-main'
    # borders
    @borders = []
    for b in 'nesw'
      i = document.createElement 'span'
      i.className = "zonehandle-border-#{b}"
      @pane.appendChild i
      @borders.push i
    # handles
    @handles = []
    for b in 'n ne e se s sw w nw'.split(' ')
      i = document.createElement 'span'
      i.className = "zonehandle-handle dir-#{b}"
      @pane.appendChild i
      @handles.push i

    # repack element inside the container
    parent = @el.parentNode
    parent.replaceChild @container, @el
    @container.appendChild @el
    @container.appendChild @pane

    @draggiffy()
    
  draggiffy: ->
    for handle in @handles
      draggie = new Draggabilly handle, containment: document.body
      draggie.on 'dragStart', (handle, event, pointer)-> console.log 'start', handle, event, pointer
      draggie.on 'dragMove', (handle, event, pointer)-> console.log 'move', handle, event, pointer
      draggie.on 'dragEnd', (handle, event, pointer)-> console.log 'end', handle, event, pointer

    for border in @borders
      draggie = new Draggabilly border, containment: document.body
