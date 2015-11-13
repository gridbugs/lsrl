define [
    'assets/action/action'
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
                    else if action.toCell.feature.type == Types.Feature.Door and action.toCell.feature.isClosed()
                        action = new Action.OpenDoor(@character, control.direction)

                    cb(action)
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
            |   Types.Control.Wait
                    cb(new Action.Wait(@character, 10))
            |   Types.Control.Examine
                    UserInterface.printLine "You see here:"
                    @selector.selectCell @character.position, @character, game_state, (coord) ~>
                        UserInterface.clearLine()
                        if not coord?
                            @character.getAction game_state, cb
                            return
                        kcell = @character.getKnowledge().grid.getCart(coord)
                        UserInterface.printDescriptionLine(kcell.describe())
                        @character.getAction game_state, cb

                    , (coord) ~>
                        UserInterface.clearLine()
                        kcell = @character.getKnowledge().grid.getCart(coord)
                        UserInterface.printDescription(kcell.describe())

            |   Types.Control.Get
                    cell = @character.getCell()

                    if cell.items.empty()
                        UserInterface.printLine "You see no items here."
                        @character.getAction game_state, cb
                    else if cell.items.length() == 1
                        action = new Action.Take(@character, cell.items.first().getGroupId(), 1)
                        cb(action)
                    else if cell.items.numTypes() == 1
                        UserInterface.print "How many? "
                        num_items <~ UserInterface.readInteger(cell.items.length())
                        action = new Action.Take(@character, cell.items.first().getGroupId(), num_items)
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

            |   Types.Control.Descend
                cell = @character.getCell()
                if not cell.feature.isDescendable()
                    UserInterface.print "Cannot descend here."
                    return @character.getAction game_state, cb

                cb(new Action.Descend(@character, cell))
            |   Types.Control.Ascend
                cell = @character.getCell()
                if not cell.feature.isAscendable()
                    UserInterface.print "Cannot ascend here."
                    return @character.getAction game_state, cb

                cb(new Action.Ascend(@character, cell))
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
                    ((c, d) -> c.gameCell.getMoveOutCost(d)), \
                    ((c) ~>
                        return c.known and (c.gameCell.character == @character or (not c.gameCell.feature.isSolid()))), \
                    dest_cell

                if result?
                    @character.setAutoMove(new AutoMove.FollowPath(@character, result.directions))
                    @character.getAction game_state, cb
                else
                    UserInterface.printLine "Can't reach selected cell."
                    @navigateToCell coord, game_state, cb
