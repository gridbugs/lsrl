define [
    'cell/feature'
    'type_system'
], (Feature, TypeSystem) ->

    class Wall extends Feature
        ->

    class Door extends Feature
        ->

    class Tree extends Feature
        ->

    TypeSystem.makeType 'Feature', {
        Wall
        Door
        Tree
    }
