define [
    'interface/key'
    'interface/control_scheme'
    'asset_system'
], (Key, ControlScheme, AssetSystem) ->

    code = (char) ->
        return char.keyCodeAt(0)

    class Dvorak extends ControlScheme
        ->
            super({
                (Key.LEFT):         'West'
                (Key.RIGHT):        'East'
                (Key.UP):           'North'
                (Key.DOWN):         'South'
            })

    AssetSystem.exposeAssets 'ControlScheme', {
        Dvorak
    }
