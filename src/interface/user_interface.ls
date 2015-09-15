define [
], ->

    class UserInterface
        (@gameDrawer, @gameController, @gameConsole, @gameHud) ->

    {
        setUserInterface: (gameDrawer, gameController, gameConsole, gameHud) ->
            @Global = new UserInterface(gameDrawer, gameController, gameConsole, gameHud)

            bind = (obj, name) ->  obj[name].bind(obj)

            @readInteger = bind(gameConsole, 'readInteger')
            @readString = bind(gameConsole, 'readString')
            @print = bind(gameConsole, 'print')
            @printLine = bind(gameConsole, 'printLine')
            @clearLine = bind(gameConsole, 'clearLine')
            @newLine = bind(gameConsole, 'newLine')

            @drawCharacterKnowledge = bind(gameDrawer, 'drawCharacterKnowledge')
            @drawCellSelectOverlay = bind(gameDrawer, 'drawCellSelectOverlay')

            @getControl = bind(gameController, 'getControl')
            @getChar = bind(gameController, 'getChar')

            @updateHud = bind(gameHud, 'updateHud')
    }
