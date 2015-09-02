define [
], ->

    class UserInterface
        (@gameDrawer, @gameController, @gameConsole) ->

    {
        setUserInterface: (gameDrawer, gameController, gameConsole) ->
            @Global = new UserInterface(gameDrawer, gameController, gameConsole)

            bind = (obj, name) ->  obj[name].bind(obj)

            @readInteger = bind(gameConsole, 'readInteger')
            @readString = bind(gameConsole, 'readString')
            @print = bind(gameConsole, 'print')
            @printLine = bind(gameConsole, 'printLine')
            @clearLine = bind(gameConsole, 'clearLine')
            @newLine = bind(gameConsole, 'newLine')

            @drawCharacterKnowledge = bind(gameDrawer, 'drawCharacterKnowledge')
    }
