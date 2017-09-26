{CompositeDisposable} = require 'atom'

module.exports = Countdown =
  countdown: null
  msg: 'FIN!'
  time: null
  subscriptions: null
  ldstart: null
  ldend: null
  event: null
  bar: null
  display: false
  statusBar: null

  activate: (state) ->
    # Events subscribed to in atom's system can be easily cleaned up with a CompositeDisposable
    @subscriptions = new CompositeDisposable

    # Register command that toggles this view
    @subscriptions.add atom.commands.add 'atom-workspace', 'countdown:toggle': => @toggle()

  consumeStatusBar: (statusBar) ->
    Countdown.msg     = 'start'
    Countdown.ldstart = new Date()
    Countdown.ldend   = new Date()
    Countdown.ldend.setHours( Countdown.ldend.getHours() + 1)

    @event = document.createElement "span"
    @event.textContent = ""

    @time = document.createElement "span"
    @time.textContent = ""
    @time.style.marginRight = "4px"

    @countdown = document.createElement "span"
    @countdown.appendChild @time
    @countdown.appendChild @event

    @bar = statusBar.addRightTile item: @countdown

    setTimeout Countdown.redraw, 0
    setInterval Countdown.redraw, 1000

    @statusBar = statusBar

  deactivate: ->
    @subscriptions.dispose()
    @bar.destroy()
    @bar = null

  serialize: ->

  toggle: ->
    if @display
      @bar.destroy()
      @bar = null
      @display = false
    else
      @display = true

      if not @bar
        @consumeStatusBar(@statusBar)

  redraw: ->

    missing = Countdown.ldend.getTime() - new Date().getTime()

    signe   =  ""
    signe   =  "-" if missing < 0

    missing = Math.abs missing;

    milis   = missing%1000
    missing = Math.floor(missing/1000)

    secs    = missing%60
    missing = Math.floor(missing/60)

    mins    = missing%60
    missing = Math.floor(missing/60)

    missing = Math.floor(missing/24)

    if mins < 10
      mins = '0'+mins

    if secs < 10
      secs = '0'+secs

    if mins < 10 || signe == '-'
      Countdown.time.style.color =  "red"

    Countdown.time.textContent =  "[ " + signe + " "+ mins + ":" + secs + " ]"
