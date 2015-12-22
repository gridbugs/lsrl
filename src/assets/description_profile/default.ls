define [
    'types'
    'asset_system'
], (Types, AssetSystem) ->

    class Default
        (@character) ->

        seen: (character) ->
            return character in @character.controller.knowledge.visibleCharacters

        seenOrInvolved: (action) ->
            return @seen(action.character) or action.character == @character

        accept: (action) ->
            switch action.type
            |   Types.Action.BumpIntoWall
                    return action.character == @character
            |   Types.Action.AttackHit
                    return action.targetCharacter == @character or @seenOrInvolved(action)
            |   Types.Action.Die
                    return @seenOrInvolved(action)
            |   Types.Action.GetStuckInWeb
                    return action.character == @character
            |   Types.Action.StruggleInWeb
                    return action.character == @character
            |   Types.Action.BreakWeb
                    return action.character == @character
            |   Types.Action.BecomePoisoned
                    return action.character == @character
            |   Types.Action.Restore
                    return action.character == @character
            |   Types.Action.Wait
                    return action.character == @character
            |   Types.Action.Ascend
                    return action.character == @character
            |   Types.Action.Descend
                    return action.character == @character
            |   Types.Action.Take
                    return action.character == @character
            |   Types.Action.Drop
                    return action.character == @character
            |   Types.Action.Equip
                    return action.character == @character
            |   Types.Action.Unequip
                    return action.character == @character

            return false

    AssetSystem.exposeAsset('DescriptionProfile', Default)
