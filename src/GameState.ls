require! './Actor.ls'

export class GameState
    (actor) ->
        @only_actor = actor
    getCurrentActor: -> @only_actor
    processAction: -> 50
