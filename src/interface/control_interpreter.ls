define [
    'actions/action'
    'interface/auto_move'
    'types'
    'structures/search'
    'interface/user_interface'
    'interface/cell_selector'
    'util'
    'debug'
], (Action, AutoMove, Types, Search, UserInterface, CellSelector, Util, Debug) ->

    class ControlInterpreter
        (@character) ->
            @selector = new CellSelector()

        getAction: (game_state, cb) ->
            control <~ Util.repeatWhileUndefined(UserInterface.getControl)

            switch control.type
            |   Types.Control.Direction
                    action = new Action.Move(@character, control.direction)

                    if action.toCell.character?
                        action = new Action.Attack(@character, control.direction)

                    cb action
                    /*
                    if action.toCell.fixture.type != Types.Fixture.Wall
                        cb action
                    else
                        UserInterface.printLine "Cannot move there."
                        @character.getAction game_state, cb
                    */
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
                    UserInterface.printLine "You see here:"
                    @selector.selectCell @character.position, @character, game_state, (coord) ~>
                        UserInterface.clearLine()
                        if not coord?
                            @character.getAction game_state, cb
                            return

                        kcell = @character.getKnowledge().grid.getCart(coord)
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
                        kcell = @character.getKnowledge().grid.getCart(coord)
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
                    else if cell.items.length() == 1
                        action = new Action.Take(@character, cell.items.first().groupId, 1)
                        cb(action)
                    else if cell.items.numTypes() == 1
                        UserInterface.print "How many? "
                        num_items <~ UserInterface.readInteger(cell.items.length())
                        action = new Action.Take(@character, cell.items.first().groupId, num_items)
                        cb(action)
                    else
                        UserInterface.printLine "Select item to pick up:"
                        cell.items.forEachMapping (ch, items) ->
                            Debug.assert(items.length() > 0, "No items")
                            name = items.first().getName()
                            if items.length() == 1
                                UserInterface.printLine "#{ch}: #{name}"
                            else if items.length() > 1
                                UserInterface.printLine "#{ch}: #{items.length()} x #{name}"

                        @chooseItem cell, (group) ~>
                            if group?
                                if group.length() > 1
                                    UserInterface.print "How many? "
                                    num_items <~ UserInterface.readInteger(group.length())
                                    action = new Action.Take(@character, group.groupId, num_items)
                                    cb(action)
                                else
                                    action = new Action.Take(@character, group.groupId, 1)
                                    cb(action)

                            else
                                UserInterface.printLine "No such item!"
                                @character.getAction game_state, cb


            |   Types.Control.Inventory
                    UserInterface.printLine "Inventory:"
                    if @character.getInventory().empty()
                        UserInterface.printLine "(empty)"
                    @character.getInventory().forEachMapping (ch, items) ->
                        Debug.assert(items.length() > 0, "No items")
                        name = items.first().getName()
                        if items.length() == 1
                            UserInterface.printLine "#{ch}: #{name}"
                        else if items.length() > 1
                            UserInterface.printLine "#{ch}: #{items.length()} x #{name}"

                    @character.getAction game_state, cb
            |   Types.Control.Drop

                    if @character.getInventory().empty()
                        UserInterface.printLine "You're not carrying any items."
                        @character.getAction game_state, cb
                        return

                    if @character.getInventory().length() == 1
                        action = new Action.Drop(@character, @character.getInventory().first().groupId, 1)
                        cb(action)
                        return

                    if @character.getInventory().numTypes() == 1
                        do
                            name = @character.getInventory().first().getName()
                            UserInterface.print "How many #{name}s? "
                            length = @character.getInventory().length()
                            num_items <~ UserInterface.readInteger(length)
                            if num_items > length
                                UserInterface.printLine "You don't have that many. Dropping #{length}."
                                num_items = length

                            action = new Action.Drop(@character, @character.getInventory().first().groupId, num_items)
                            cb(action)
                        return

                    UserInterface.printLine "Select item to drop:"

                    @character.getInventory().forEachMapping (ch, items) ->
                        Debug.assert(items.length() > 0, "No items")
                        name = items.first().getName()
                        if items.length() == 1
                            UserInterface.printLine "#{ch}: #{name}"
                        else if items.length() > 1
                            UserInterface.printLine "#{ch}: #{items.length()} x #{name}"

                    items <~ @chooseInventoryItem()
                    if items?
                        if items.length() > 1
                            UserInterface.print "How many? "
                            num_items <~ UserInterface.readInteger(items.length())
                            if num_items > items.length()
                                UserInterface.printLine "You don't have that many. Dropping #{items.length()}."
                                num_items = items.length()
                            action = new Action.Drop(@character, items.groupId, num_items)
                            cb(action)
                        else
                            action = new Action.Drop(@character, items.groupId, 1)
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
            item = @character.getInventory().getGroupByLetter(char)
            if item?
                cb(item)
            else
                cb(void)

        chooseItem: (cell, cb) ->
            char <~ UserInterface.getChar()
            group = cell.items.getGroupByLetter(char)
            if group?
                cb(group)
            else
                cb(void)

        navigateToCell: (start_coord, game_state, cb) ->
            UserInterface.printLine "Select cell to move to."
            @selector.selectCell start_coord, @character, game_state, (coord) ~>
                if not coord?
                    @character.getAction(game_state, cb)
                    return

                dest_cell = @character.grid.getCart coord

                result = Search.findPath @character.getKnowledgeCell(), \
                    ((c, d) -> c.game_cell.getMoveOutCost d), \
                    ((c) -> c.known and c.game_cell.isEmpty()), \
                    dest_cell

                if result?
                    @character.setAutoMove(new AutoMove.FollowPath(@character, result.directions))
                    @character.getAction game_state, cb
                else
                    UserInterface.printLine "Can't reach selected cell."
                    @navigateToCell coord, game_state, cb
