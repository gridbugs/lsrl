define [
    'util'
    'config'
], (Util, Config) ->

    class Hud
        (@hudWindow) ->
            @hudWindow.border()

        updateHud: (character) ->
            @hudWindow.clear()
            @hudWindow.border()
            @hudWindow.cursor(1, 1)
            @hudWindow.addstr("#{character.getName()}")
            @hudWindow.addstr("  Curse: #{character.getCurrentHitPoints()}")
            @hudWindow.refresh()
