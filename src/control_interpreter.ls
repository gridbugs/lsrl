define [
    \action
    \auto_move
    \types
    \search
    \util
], (Action, AutoMove, Types, Search, Util) ->
    
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

                            
                            @character.getAction game_state, cb
                |   Types.Control.Get
                        cell = @character.getCell()

                        if cell.items.empty()
                            Util.printDrawer "You see no items here."
                            @character.getAction game_state, cb
                        else
                            @chooseItem cell, (item) ~>
                                action = new Action.Take(@character, game_state, item)
                                cb(action)
                |   Types.Control.Inventory
                        @character.inventoryAlphabet.forEachAlphabet (char, items) ->
                            name = items[0].getName()
                            if items.length == 1
                                Util.printDrawer "#{char}: #{name}"
                            else if items.length > 1
                                Util.printDrawer "#{char}: #{items.length} x #{name}"
                        @character.getAction game_state, cb
                |   Types.Control.Drop
                    Util.printDrawer "Select item to drop:"
                    @chooseInventoryItem (item) ~>
                        if item?
                            action = new Action.Drop(@character, game_state, item)
                            cb(action)
                        else
                            Util.printDrawer "You aren't carrying any such item."
                            @character.getAction game_state, cb
                        

        chooseInventoryItem: (cb) ->
            @inputSource.getChar (char) ~>
                item = @character.inventoryAlphabet.getByKey(char)
                if item?
                    cb(item[0])
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
                    ((c) -> c.known and c.fixture.type != Types.Fixture.Wall), \
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
