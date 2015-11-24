define [
    'blessed'
    'common/game'
    'front_ends/console/blessed/interface/input'
    'front_ends/console/blessed/interface/console'
    'front_ends/console/blessed/interface/hud'
    'assets/assets'
    'util'
    'debug'
], (Blessed, BaseGame, Input, Console, Hud, Assets, Util, Debug) ->

    class OutputBuffer
        ->
            @buffer = void
            @writable = true

        on: (event) ->

        write: (text) ->
            if @buffer?
                @buffer += text
            else
                @buffer = text

        flush: ->
            if @buffer?
                process.stdout.write(@buffer)
                @buffer = void


    class Game extends BaseGame
        ->

            @seedRandom()
            
            Assets.Colour = Assets.ConsoleColour
            Assets.TileSet.UnicodeTileSet.install()
            Assets.TileSet.Default = Assets.TileSet.UnicodeTileSet

            buffer = new OutputBuffer()
            @program = Blessed.program(buffer: false, output: buffer)
            @program.flushBuffer = buffer~flush

            @program.alternateBuffer()
            @program.enableMouse()
            @program.hideCursor()
            @program.clear()

            @program.on 'mouse', ->

            drawer = new Assets.Drawer.BlessedUnicodeDrawer(@program, 0, 0, 80, 30)
            input = new Input(@program)
            gconsole = new Console(@program, input, 0, 36, 80, 12)
            hud = new Hud(@program, 0, 32, 80, 4)

            @program.key('C-c', @~cleanup)

            @program.flushBuffer()

            super(drawer, input, gconsole, hud)

        cleanup: ->
            @program.clear()
            @program.disableMouse()
            @program.showCursor()
            @program.normalBuffer()
            @program.flushBuffer()
            process.exit(0)
