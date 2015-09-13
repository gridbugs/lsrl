define [
    'hud/hud'
    'util'
    'config'
], (GenericHud, Util, Config) ->

    class Hud extends GenericHud
        (@hudWindow) ->
            @hudWindow.border()
        
        updateHud: (character) ->
            @hudWindow.clear()
            @hudWindow.border()
            @hudWindow.cursor(1, 1)
            @hudWindow.addstr("#{character.getName()}")
            @hudWindow.addstr("  Curse: #{character.getCurrentHitPoints()}")
            @hudWindow.refresh()

    {
        Hud
    }
