define [
    'cell/feature'
    'type_system'
], (Feature, TypeSystem) ->

    class Wall extends Feature
        ->
            super()

    class Door extends Feature
        ->
            super()

    class Tree extends Feature
        ->
            super()

    TypeSystem.makeType 'Feature', {
        Wall
        Door
        Tree
    }
