define [
    'actions/action'
    'types'
    'util'
], (Action, Types, Util) ->

    class PoisonShrubberyController
        (@character, @position, @grid) ->
            @adjacentCharacters = []

        getAction: (game_state, callback) ->

            potential_directions = @character.getCell().neighbours.map (.character) .map (character, direction) ->
                switch character?.type
                |   Types.Character.Human => return direction
                |   otherwise => return void
            .filter (?)
            
            if potential_directions.length == 0
                callback(new Action.Wait(@character, 40))
            else
                target_direction = Util.getRandomElement(potential_directions)
                callback(new Action.Attack(@character, target_direction))        
        

    {
        PoisonShrubberyController
    }
