define [
    'front_ends/browser/html_description_interpreter'
    'util'
    'config'
], (DescriptionInterpreter, Util, Config) ->

    class Hud
        (@$hud) ->

        updateHud: (character) ->
            @$hud.empty()
            @$hud.append("<div>#{character.getName()}</div>")
            @$hud.append("<div>HP: #{character.getCurrentHitPoints()}</div>")
            @$hud.append("<div>Depth: #{character.level.depth}</div>")
            character.continuousEffects.forEach (effect) ~>
                @$hud.append("<div>#{DescriptionInterpreter.descriptionToHtmlString(effect.describe())}</div>")
