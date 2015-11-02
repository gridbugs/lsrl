define [
    'system/controller'
    'assets/action/action'
    'types'
    'util'
    'asset_system'
], (Controller, Action, Types, Util, AssetSystem) ->

    class ShrubberyController extends Controller
        (@character, @position, @grid) ->
            super()
            @period = 5

        getAction: (game_state, callback) ->

            potential_directions = @character.getCell().neighbours.map (.character) .map (character, direction) ->
                switch character?.type
                |   Types.Character.Human => return direction
                |   otherwise => return void
            .filter (?)

            if potential_directions.length == 0
                callback(new Action.Wait(@character, @period))
            else
                target_direction = Util.getRandomElement(potential_directions)
                callback(new Action.Attack(@character, target_direction))

    class PoisonShrubberyController extends ShrubberyController
        (character, position, grid) ->
            super(character, position, grid)

    class CarnivorousShrubberyController extends ShrubberyController
        (character, position, grid) ->
            super(character, position, grid)


    AssetSystem.exposeAssets 'Controller', {
        PoisonShrubberyController
        CarnivorousShrubberyController
    }
