define [
    'hud/hud'
    'util'
    'config'
], (GenericHud, Util, Config) ->

    class Hud extends GenericHud
        (@$hud) ->
        
        updateHud: (character) ->
            @$hud.empty()
            @$hud.append("<div>#{character.getName()}</div>")
            @$hud.append("<div>Curse: #{character.getCurrentHitPoints()}</div>")
    {
        Hud
    }
