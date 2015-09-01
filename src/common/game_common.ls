define [
    'input/user_interface'
    'tests/test'
    'util'
    'config'
    'debug'
], (UserInterface, Test, Util, Config, Debug) ->

    class GameCommon
        (drawer, input_source) ->
            @gameDrawer = drawer
            @inputSource = input_source
            @gameState = @test!
            @drawer = drawer
            if Config.RUN_TEST
                Util.printDebug "----- AVL Tree Test -------"
                Test.avlTreeTest()
                #Util.printDebug "----- Linked List Test -------"
                #Test.linkedListTest()

        test: -> Test.test @gameDrawer, @inputSource
        start: ->
            if Config.DRAW_MAP_ONLY
                return

            @gameState.scheduleActionSource @gameState.playerCharacter, 10
            @progressGameState!

        gameTimeToMs: (t) ->
            if Config.FAST_ANIMATION
                return 0
            else
                return t * 0.5

        progressGameState: ->
            action_source = @gameState.getCurrentActionSource!

            @gameState.progressSchedule!

            @gameState.playerCharacter.observe @gameState
            @drawer.drawCharacterKnowledge @gameState.playerCharacter, @gameState

            action_source.getAction @gameState, (action) ~>
                descriptions = @gameState.applyAction action
                for desc in descriptions
                    UserInterface.printLine desc


                /* Get time until current action source (in game time) */
                time = @gameState.getCurrentTimeDelta!

                /* Process the next action after the time has passed */
                setTimeout (~>@progressGameState!), (@gameTimeToMs time)

    {
        GameCommon
    }
