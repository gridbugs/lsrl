define [
    'actions/action'
    'input/auto_move'
    'types'
    'structures/search'
    'input/user_interface'
    'input/cell_selector'
    'util'
    'debug'
], (Action, AutoMove, Types, Search, UserInterface, CellSelector, Util, Debug) ->

    class ControlInterpreter
        (@character) ->
            @selector = new CellSelector.CellSelector()

        getAction: (game_state, cb) ->
            control <~ Util.repeatWhileUndefined(UserInterface.getControl)

            switch control.type
            |   Types.Control.Direction
                    action = new Action.Move @character, control.direction, game_state
                    if action.toCell.fixture.type != Types.Fixture.Wall
                        cb action
                    else
                        UserInterface.printLine "Cannot move there."
                        @character.getAction game_state, cb
            |   Types.Control.AutoDirection
                    @character.setAutoMove(
                        new AutoMove.StraightLineMove @character, control.direction
                    )
                    @character.getAction game_state, cb
            |   Types.Control.AutoExplore
                    @character.setAutoMove(
                        new AutoMove.AutoExplore @character
                    )
                    @character.getAction game_state, cb
            |   Types.Control.NavigateToCell
                    @navigateToCell(@character.position, game_state, cb)
            |   Types.Control.Examine
                    UserInterface.newLine()
                    @selector.selectCell @character.position, @character, game_state, (coord) ~>
                        UserInterface.clearLine()
                        if not coord?
                            @character.getAction game_state, cb
                            return

                        kcell = @character.knowledge.grid.getCart(coord)
                        UserInterface.printLine "You see here:"
                        if kcell.fixture.type == Types.Fixture.Null
                            switch (kcell.ground.type)
                            |   Types.Ground.Dirt => UserInterface.printLine "Dirt floor"
                        else
                            switch (kcell.fixture.type)
                            |   Types.Fixture.Wall => UserInterface.printLine "A wall"
                            |   Types.Fixture.Web => UserInterface.printLine "A spider web"

                        if kcell.game_cell.items.length() > 0
                            kcell.game_cell.items.forEachItemType (_, items) ->
                                UserInterface.printLine "#{items.length()} #{items.first().getName()}"

                        @character.getAction game_state, cb

                    , (coord) ~>
                        UserInterface.clearLine()
                        kcell = @character.knowledge.grid.getCart(coord)
                        if kcell.fixture.type == Types.Fixture.Null
                            switch (kcell.ground.type)
                            |   Types.Ground.Dirt => UserInterface.print "Dirt floor"
                        else
                            switch (kcell.fixture.type)
                            |   Types.Fixture.Wall => UserInterface.print "A wall"
                            |   Types.Fixture.Web => UserInterface.print "A spider web"



            |   Types.Control.Get
                    cell = @character.getCell()

                    if cell.items.empty()
                        UserInterface.printLine "You see no items here."
                        @character.getAction game_state, cb
                    else
                        @chooseItem cell, (item) ~>
                            action = new Action.Take(@character, game_state, item.getGroupId(), 1)
                            cb(action)
            |   Types.Control.Inventory
                    @character.inventory.forEachMapping (ch, items) ->
                        Debug.assert(items.length() > 0, "No items")
                        name = items.first().getName()
                        if items.length() == 1
                            UserInterface.printLine "#{ch}: #{name}"
                        else if items.length() > 1
                            UserInterface.printLine "#{ch}: #{items.length()} x #{name}"

                    @character.getAction game_state, cb
            |   Types.Control.Drop
                UserInterface.printLine "Select item to drop:"
                @chooseInventoryItem (items) ~>
                    if items?
                        if items.length() > 1
                            UserInterface.print "How many? "
                            num_items <~ UserInterface.readInteger(items.length())
                            if num_items > items.length()
                                UserInterface.printLine "You don't have that many. Dropping #{items.length()}."
                                num_items = items.length()
                            action = new Action.Drop(@character, game_state, items.groupId, num_items)
                            cb(action)
                        else
                            action = new Action.Drop(@character, game_state, items.groupId, 1)
                            cb(action)
                    else
                        UserInterface.printLine "You aren't carrying any such item."
                        @character.getAction game_state, cb
            |   Types.Control.Test
                    UserInterface.print "Enter a string: "
                    UserInterface.readString "hello", (i) ~>
                        UserInterface.printLine "You entered: #{i}"
                        @character.getAction game_state, cb

            |   otherwise
                    @character.getAction game_state, cb

        chooseInventoryItem: (cb) ->
            char <~ UserInterface.getChar()
            item = @character.inventory.getGroupByLetter(char)
            if item?
                cb(item)
            else
                cb(void)

        chooseItem: (cell, cb) ->
            cb(cell.items.first())

        navigateToCell: (start_coord, game_state, cb) ->
            UserInterface.printLine "Select cell to move to."
            @selector.selectCell start_coord, @character, game_state, (coord) ~>
                if not coord?
                    @character.getAction(game_state, cb)
                    return

                dest_cell = @character.grid.getCart coord

                result = Search.findPath @character.getKnowledgeCell(), \
                    ((c, d) -> c.game_cell.getMoveOutCost d), \
                    ((c) -> c.known and c.fixture.type == Types.Fixture.Null), \
                    dest_cell

                if result?
                    @character.setAutoMove(new AutoMove.FollowPath(@character, result.directions))
                    @character.getAction game_state, cb
                else
                    UserInterface.printLine "Can't reach selected cell."
                    @navigateToCell coord, game_state, cb

    {
        ControlInterpreter
    }
