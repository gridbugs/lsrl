define [
    'interface/key'
    'interface/control_scheme'
    'interface/control'
    'asset_system'
], (Key, ControlScheme, Control, AssetSystem) ->

    code = (char) ->
        return char.toUpperCase().charCodeAt(0)

    class MouseControlScheme extends ControlScheme
        ->
            super()

        getMouseControl: (mouse_event) ->
            return [Control.NavigateToCell, mouse_event.coord]


    class ArrowKeys extends MouseControlScheme
        ->
            super()

            @add {
                /* Arrow key movement */
                (Key.LEFT):         'West'
                (Key.RIGHT):        'East'
                (Key.UP):           'North'
                (Key.DOWN):         'South'

                (Key.LEFT .|. Key.CONTROL):         'SouthWest'
                (Key.RIGHT .|. Key.CONTROL):        'NorthEast'
                (Key.UP .|. Key.CONTROL):           'NorthWest'
                (Key.DOWN .|. Key.CONTROL):         'SouthEast'

                /* Arrow key movement */
                (Key.LEFT .|. Key.SHIFT):         'AutoWest'
                (Key.RIGHT .|. Key.SHIFT):        'AutoEast'
                (Key.UP .|. Key.SHIFT):           'AutoNorth'
                (Key.DOWN .|. Key.SHIFT):         'AutoSouth'

                (Key.LEFT .|. Key.CONTROL .|. Key.SHIFT):         'AutoSouthWest'
                (Key.RIGHT .|. Key.CONTROL .|. Key.SHIFT):        'AutoNorthEast'
                (Key.UP .|. Key.CONTROL .|. Key.SHIFT):           'AutoNorthWest'
                (Key.DOWN .|. Key.CONTROL .|. Key.SHIFT):         'AutoSouthEast'

                /* Interface */
                (Key.ENTER):                    'Accept'
                (Key.ESCAPE):                   'Escape'
            }

    class Dvorak extends ArrowKeys
        ->
            super()

            @add {
                /* Movement */
                (code('d')):        'West'
                (code('n')):        'East'
                (code('h')):        'South'
                (code('t')):        'North'
                (code('f')):        'NorthWest'
                (code('g')):        'NorthEast'
                (code('x')):        'SouthWest'
                (code('b')):        'SouthEast'

                /* Auto Movement */
                (code('d') .|. Key.SHIFT):        'AutoWest'
                (code('n') .|. Key.SHIFT):        'AutoEast'
                (code('h') .|. Key.SHIFT):        'AutoSouth'
                (code('t') .|. Key.SHIFT):        'AutoNorth'
                (code('f') .|. Key.SHIFT):        'AutoNorthWest'
                (code('g') .|. Key.SHIFT):        'AutoNorthEast'
                (code('x') .|. Key.SHIFT):        'AutoSouthWest'
                (code('b') .|. Key.SHIFT):        'AutoSouthEast'

                /* Auto Exploration */
                (code('r')):                    'AutoExplore'
                (code('q') .|. Key.SHIFT):      'NavigateToCell'

                /* Interaction */
                (code('q')):            'Examine'
                (code('i')):            'Get'
                (code('e')):            'Drop'
                (code('c')):            'Inventory'
                (code('v')):            'Wait'
                (Key.PERIOD):           'Equip'

                /* Stairs */
                (code('v') .|. Key.SHIFT):  'Descend'
                (code('w') .|. Key.SHIFT):  'Ascend'
            }

    class Qwerty extends ArrowKeys
        ->
            super()

            @add {
                /* Movement */
                (code('h')):        'West'
                (code('l')):        'East'
                (code('j')):        'South'
                (code('k')):        'North'
                (code('y')):        'NorthWest'
                (code('u')):        'NorthEast'
                (code('b')):        'SouthWest'
                (code('n')):        'SouthEast'

                /* Auto Movement */
                (code('h') .|. Key.SHIFT):        'AutoWest'
                (code('l') .|. Key.SHIFT):        'AutoEast'
                (code('j') .|. Key.SHIFT):        'AutoSouth'
                (code('k') .|. Key.SHIFT):        'AutoNorth'
                (code('y') .|. Key.SHIFT):        'AutoNorthWest'
                (code('u') .|. Key.SHIFT):        'AutoNorthEast'
                (code('b') .|. Key.SHIFT):        'AutoSouthWest'
                (code('n') .|. Key.SHIFT):        'AutoSouthEast'

                /* Auto Exploration */
                (code('o')):                    'AutoExplore'
                (code('x') .|. Key.SHIFT):      'NavigateToCell'

                /* Interaction */
                (code('x')):            'Examine'
                (code('g')):            'Get'
                (code('d')):            'Drop'
                (code('i')):            'Inventory'
                (Key.PERIOD):           'Wait'
                (code('e')):            'Equip'

                /* Stairs */
                (Key.PERIOD .|. Key.SHIFT):     'Descend'
                (Key.COMMA .|. Key.SHIFT):      'Ascend'
            }

    AssetSystem.exposeAssets 'ControlScheme', {
        Dvorak
        Qwerty
    }
