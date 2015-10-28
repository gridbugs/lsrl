define [
    'util'
    'config'
], (Util, Config) ->

    class Hud
        (@$hud) ->

        updateHud: (character) ->
            @$hud.empty()
            @$hud.append("<div>#{character.getName()}</div>")
            @$hud.append("<div>Curse: #{character.getCurrentHitPoints()}</div>")
            character.continuousEffects.forEach (effect) ~>
                @$hud.append("<div style='color:purple'>#{effect.toString()}</div>")
