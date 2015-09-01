define [
], ->

    class UserInterface
        (@gameDrawer, @gameController, @gameConsole) ->

    {
        setUserInterface: (gameDrawer, gameController, gameConsole) ->
            @Global = new UserInterface(gameDrawer, gameController, gameConsole)

            bind = (obj, name) ->  obj[name].bind(obj)

            @readInteger = bind(@Global.gameConsole, 'readInteger')
            @readString = bind(@Global.gameConsole, 'readString')
            @print = bind(@Global.gameConsole, 'print')
            @printLine = bind(@Global.gameConsole, 'printLine')
            @clearLine = bind(@Global.gameConsole, 'clearLine')
            @newLine = bind(@Global.gameConsole, 'newLine')
    }
