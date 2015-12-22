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

        printCharacterInventory: (predicate = -> true) ->
            count = 0
            @character.getInventory().forEachMapping (ch, item) ->
                if predicate(item)
                    name = item.describe().toTitleString()
                    equippedStr = ""
                    if item.isEquipped()
                        equippedStr = " [#{item.equippedInSlot.type.getEquippedVerb()}]"
                    UserInterface.printLine "(#{ch}) #{name}#{equippedStr}"
                    count := count + 1
            return count

        printCharacterEquipmentSlots: ->
            @character.equipmentSlots.forEachMapping (letter, slot) ->
                if slot.containsItem()
                    UserInterface.printLine "(#{letter}) #{slot.describe().toTitleString()}: #{slot.item.describe().toTitleString()}"
                else
                    UserInterface.printLine "(#{letter}) #{slot.describe().toTitleString()}"

        getAction: (game_state, cb) ->
            [control, extra] <~ Util.repeatWhileUndefined(UserInterface.getControl)
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
                    if extra?
                        coord = extra
                        dest_cell = @character.grid.getCart coord
                        kcell = @character.getKnowledgeCell()

                        result = Search.findPath kcell, \
                            ((c, d) -> c.gameCell.getMoveOutCost(d)), \
                            ((c) ~>
                                return c.known and (c.gameCell.character == @character or (not c.gameCell.feature.isSolid()))), \
                            dest_cell

                        if result?
                            @character.setAutoMove(new AutoMove.FollowPath(@character, result.directions))
                            @character.getAction game_state, cb
                        else
                            UserInterface.printLine "Can't reach selected cell."
                            @character.getAction game_state, cb
                        return
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
                        kcell = @character.getKnowledge().getGrid().getCart(coord)
                        UserInterface.printDescriptionLine(kcell.describe())
                        @character.getAction game_state, cb

                    , (coord) ~>
                        UserInterface.clearLine()
                        kcell = @character.getKnowledge().getGrid().getCart(coord)
                        UserInterface.printDescription(kcell.describe())

            |   Types.Control.Get
                    cell = @character.getCell()

                    if cell.items.isEmpty()
                        UserInterface.printLine "There's nothing here to pick up."
                        @character.getAction game_state, cb
                    else if cell.items.getItemCount() == 1
                        action = new Action.Take(@character, cell.items.getAnySlot())
                        cb(action)
                    else
                        UserInterface.printLine "Select item to pick up:"
                        cell.items.forEachMapping (ch, item) ->
                            name = item.describe().toTitleString()
                            UserInterface.printLine "#{ch}: #{name}"

                        slot <~ @chooseItemSlot(cell)
                        if slot?
                            action = new Action.Take(@character, slot)
                            cb(action)
                        else
                            UserInterface.printLine "No such item!"
                            @character.getAction game_state, cb

            |   Types.Control.Inventory
                    UserInterface.printLine "Inventory:"
                    if @character.getInventory().isEmpty()
                        UserInterface.printLine "(empty)"
                    else
                        @printCharacterInventory()

                    @character.getAction game_state, cb
            |   Types.Control.Drop

                    if @character.getInventory().isEmpty()
                        UserInterface.printLine "You're not carrying any items."
                        @character.getAction game_state, cb
                        return

                    UserInterface.printLine "Select item to drop:"

                    @printCharacterInventory()

                    slot <~ @chooseInventorySlot()
                    if slot?
                        action = new Action.Drop(@character, slot)
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
            |   Types.Control.Equip
                    UserInterface.printLine "Equip to where?"
                    @printCharacterEquipmentSlots()
                    slot <~ @chooseEquipmentSlot()

                    if not slot?
                        UserInterface.printLine "No such item slot."
                        @character.getAction game_state, cb
                        return

                    UserInterface.printLine "#{Util.capitaliseFirstLetterOfString(slot.type.getEquipVerb())} which item? (#{slot.describe().toTitleString()})"
                    count = @printCharacterInventory( (item) ->
                        return item.isEquipable() and item.compatibleSlots.has(slot.type)
                    )

                    if count == 0
                        UserInterface.printLine "No compatible items in inventory."
                        @character.getAction game_state, cb
                        return

                    item_slot <~ @chooseInventorySlot()
                    if not item_slot?
                        UserInterface.printLine "You don't have that item."
                        @character.getAction game_state, cb
                        return
                    if not item_slot.item.isEquipable()
                        UserInterface.printLine "That item cannot be equipped."
                        @character.getAction game_state, cb
                        return
                    if not item_slot.item.compatibleSlots.has(slot.type)
                        UserInterface.printLine "That item cannot be equipped there."
                        @character.getAction game_state, cb
                        return

                    if slot.item == item_slot.item
                        action = new Action.Unequip(@character, slot)
                        cb(action)
                    else
                        action = new Action.Equip(@character, slot, item_slot)
                        cb(action)
            |   Types.Control.SwapWeapons
                    cb(new Action.SwapWeapons(@character))
            |   otherwise
                    @character.getAction game_state, cb

        chooseInventorySlot: (cb) ->
            char <~ UserInterface.getChar()
            item = @character.getInventory().getSlotByLetter(char)
            cb(item)

        chooseItemSlot: (cell, cb) ->
            char <~ UserInterface.getChar()
            slot = cell.items.getSlotByLetter(char)
            cb(slot)

        chooseEquipmentSlot: (cb) ->
            char <~ UserInterface.getChar()
            slot = @character.equipmentSlots.getSlotByLetter(char)
            cb(slot)

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
