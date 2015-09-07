define [
    'types'
    'util'
], (Types, Util) ->

    const ColourType =
        White: 15
        Black: 16
        LightGreen: 34
        DarkGreen: 22
        LightBrown: 94
        DarkBrown: 58
        LightBlue: 21
        LightGrey: 250
        DarkGrey: 240
        VeryDarkGrey: 236
        LightRed: 196
        Yellow:     11
        DarkYellow: 184


    T = (character, colour, bold) -> {
        character: character
        colour: ColourType[colour]
        pair: null
        bold: bold
    }

    const TileStyles = Util.table Types.Tile, {
        Error:      T '?', \LightRed
        Unknown:    T ' ', \Black
        Stone:      T '.', \LightGrey
        Dirt:       T '.', \DarkBrown
        Tree:       T '&', \DarkGreen
        Wall:       T '#', \DarkGrey
        SpiderWeb:  T '*', \LightGrey
        Moss:       T '.', \LightGreen
        ItemStone:  T '[', \LightGrey
        ItemPlant:  T '%', \LightGreen
        Door:       T '+', \LightGrey
        OpenDoor:   T '-', \LightGrey
        Human:      T 'h', \White, true
        Shrubbery:  T 'p', \LightGreen, true
        PlayerCharacter:    T '@', \White, true
    }

    const PlayerCharacterStyle = T '@', \White

    const SpecialColours =
        Unseen:     ColourType.VeryDarkGrey
        Selected:   ColourType.DarkYellow

    {
        TileStyles
        PlayerCharacterStyle
        ColourType
        SpecialColours
        createTile: T
    }
