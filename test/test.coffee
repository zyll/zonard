describe 'decorate an element', ->

  beforeEach ->
    @container = document.createElement 'div'
    @el = document.createElement 'div'
    document.body.appendChild @container
    @container.appendChild @el
    @el.style.height = '100px'
    @el.style.width = '50px'
    injectZoneHandler @el

  afterEach ->
    document.body.removeChild @container

  it 'add a zonehandler element', ->
    expect(@container.getElementsByClassName('zonehandler-main').length).to.equal 1

  describe 'zone handler', ->
    beforeEach ->
      @zonehandler = @container.getElementsByClassName('zonehandler-main')[0]

    it 'zonehandler has 12 elements', ->
      expect(@zonehandler.childNodes.length).to.eql 12
