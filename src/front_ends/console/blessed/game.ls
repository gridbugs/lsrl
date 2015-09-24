define [
    'common/game'
    'front_ends/console/blessed/drawing/drawer'
    'front_ends/console/blessed/interface/input'
    'front_ends/console/blessed/interface/console'
    'front_ends/console/blessed/interface/hud'
    'interface/keymap'
], (BaseGame, Drawer, Input, Console, Hud, Keymap) ->

    class Game extends BaseGame
        ->

            drawer = new Drawer()
            convert = Keymap.convertFromDvorak
            input = new Input()
            gconsole = new Console()
            hud = new Hud()

            super(drawer, input, gconsole, hud)
