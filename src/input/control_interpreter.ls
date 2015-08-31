define [
    'actions/action'
    'input/auto_move'
    'types'
    'structures/search'
    'util'
    'debug'
], (Action, AutoMove, Types, Search, Util, Debug) ->

    class ControlInterpreter
        (@character, @inputSource, @ui) ->


        getAction: (game_state, cb) ->
            Util.repeatWhileUndefined @inputSource.getControl, (control) ~>

                switch control.type
                |   Types.Control.Direction
                        action = new Action.Move @character, control.direction, game_state
                        if action.toCell.fixture.type != Types.Fixture.Wall
                            cb action
                        else
                            Util.printDrawer "Cannot move there."
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
                        @ui.selectCell @character.position, @character, game_state, (coord) ~>
                            kcell = @character.knowledge.grid.getCart(coord)
                            Util.printDrawer "You see here:"
                            if kcell.fixture.type == Types.Fixture.Null
                                switch (kcell.ground.type)
                                |   Types.Ground.Dirt => Util.printDrawer "Dirt floor"
                            else
                                switch (kcell.fixture.type)
                                |   Types.Fixture.Wall => Util.printDrawer "A wall"
                                |   Types.Fixture.Web => Util.printDrawer "A spider web"

                            if kcell.game_cell.items.length() > 0
                                kcell.game_cell.items.forEachItemType (_, items) ->
                                    Util.printDrawer "#{items.length()} #{items.first().getName()}"

                            @character.getAction game_state, cb
                |   Types.Control.Get
                        cell = @character.getCell()

                        if cell.items.empty()
                            Util.printDrawer "You see no items here."
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
                                Util.printDrawer "#{ch}: #{name}"
                            else if items.length() > 1
                                Util.printDrawer "#{ch}: #{items.length()} x #{name}"

                        @character.getAction game_state, cb
                |   Types.Control.Drop
                    Util.printDrawer "Select item to drop:"
                    @chooseInventoryItem (items) ~>
                        if items?

                            if items.length() > 1
                                Util.printDrawer "How many?"
                                Util.drawer.readInt items.length(), (i) ~>
                                    if i > items.length()
                                        Util.printDrawer "You don't have that many. Dropping #{items.length()}."
                                        i = items.length()
                                    action = new Action.Drop(@character, game_state, items.groupId, i)
                                    cb(action)
                            else
                                action = new Action.Drop(@character, game_state, items.groupId, 1)
                                cb(action)
                        else
                            Util.printDrawer "You aren't carrying any such item."
                            @character.getAction game_state, cb
                |   Types.Control.Test
                        Util.printDrawer "Enter a string:"
                        Util.drawer.readLine 'name', (i) ~>
                            Util.printDrawer "You entered: #{i}"
                            @character.getAction game_state, cb
                |   _
                        @character.getAction game_state, cb

        chooseInventoryItem: (cb) ->
            @inputSource.getChar (char) ~>
                item = @character.inventory.getGroupByLetter(char)
                if item?
                    cb(item)
                else
                    cb(void)

        chooseItem: (cell, cb) ->
            cb(cell.items.first())

        navigateToCell: (start_coord, game_state, cb) ->
            Util.printDrawer "Select cell to move to."
            @ui.selectCell start_coord, @character, game_state, (coord) ~>
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
                    Util.printDrawer "Can't reach selected cell."
                    @navigateToCell coord, game_state, cb

    {
        ControlInterpreter
    }
