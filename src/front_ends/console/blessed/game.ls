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

    class Game extends BaseGame
        ->

            @seedRandom()

            @program = Blessed.program()
            
            @program.alternateBuffer()
            @program.enableMouse()
            @program.hideCursor()
            @program.clear()

            @program.on 'mouse', ->

            drawer = new Drawer(@program, Tile.TileTable, Tile.SpecialColours, 0, 0, 80, 30)
            convert = Keymap.convertFromDvorak
            input = new Input(@program)
            gconsole = new Console(@program)
            hud = new Hud(@program)
            
            @program.key('C-c', @~cleanup)

            super(drawer, input, gconsole, hud)

        cleanup: ->
            @program.clear();
            @program.disableMouse();
            @program.showCursor();
            @program.normalBuffer();
            process.exit(0);
