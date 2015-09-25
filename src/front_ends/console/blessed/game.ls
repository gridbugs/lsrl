define [
    'blessed'
    'common/game'
    'front_ends/console/blessed/drawing/drawer'
    'front_ends/console/blessed/drawing/tile'
    'front_ends/console/blessed/interface/input'
    'front_ends/console/blessed/interface/console'
    'front_ends/console/blessed/interface/hud'
    'interface/keymap'
    'util'
], (Blessed, BaseGame, Drawer, Tile, Input, Console, Hud, Keymap, Util) ->

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

            buffer = new OutputBuffer()
            @program = Blessed.program(buffer: false, output: buffer)
            @program.flushBuffer = buffer~flush

            @program.alternateBuffer()
            @program.enableMouse()
            @program.hideCursor()
            @program.clear()

            @program.on 'mouse', ->

            drawer = new Drawer(@program, Tile.TileTable, Tile.SpecialColours, 0, 0, 80, 30)
            convert = Keymap.convertFromDvorak
            input = new Input(@program, convert)
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
