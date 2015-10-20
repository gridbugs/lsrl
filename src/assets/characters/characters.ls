define [
    'assets/characters/shrubberies'
    'assets/characters/human'
    'type_system'
    'util'
], (Shrubberies, Human, TypeSystem, Util) ->

    TypeSystem.makeType 'Character', Util.mergeObjects Shrubberies, {
        Human
    }
