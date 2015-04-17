{CompositeDisposable} = require 'atom'

module.exports = Countdown =
  countdown: null
  time: null
  subscriptions: null
  ldstart: new Date("Apr 17 2015 18:00:00 PDT")
  ldend: new Date ("Apr 19 2015 18:00:00 PDT")
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
    image = document.createElement "img"
    image.src = "atom://countdown/styles/ld.png"
    image.width = 16
    image.style.marginRight = "4px"

    @event = document.createElement "span"
    @event.textContent = "LD#32"

    @time = document.createElement "span"
    @time.textContent = ""
    @time.style.marginRight = "4px"

    @countdown = document.createElement "span"
    @countdown.appendChild image
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
    missing = Countdown.ldstart.getTime()-new Date().getTime()

    if missing < 0
      missing = Countdown.ldend.getTime()-new Date().getTime()

      if missing < 0 and missing > -3600000
        missing = missing+3600000

        milis = missing%1000
        missing = Math.floor(missing/1000)

        secs = missing%60
        missing = Math.floor(missing/60)

        mins = missing%60
        missing = Math.floor(missing/60)

        Countdown.time.textContent = "SUBMIT! " + mins + ":" + secs

        return
      else
        if missing < 0
          Countdown.time.textContent = "FIN!"
          return

    milis = missing%1000
    missing = Math.floor(missing/1000)

    secs = missing%60
    missing = Math.floor(missing/60)

    mins = missing%60
    missing = Math.floor(missing/60)

    hours = missing%24

    missing = Math.floor(missing/24)

    days = missing

    Countdown.time.textContent = days + "d " + hours + ":" + mins + ":" + secs
