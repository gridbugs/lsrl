define [
    'structures/vec2'
    'types'
    'util'
], (Vec2, Types, Util) ->

    class Section
        (@min_slope, @max_slope, @depth) ->

    computeSlope = (from_vec, to_vec, lateral_index, depth_index) ->
        (to_vec.arrayGet(lateral_index) - from_vec.arrayGet(lateral_index)) /
            (to_vec.arrayGet(depth_index) - from_vec.arrayGet(depth_index))

    observeOctant = (
        character,
        game_state,
        eye_cell,
        min_slope_initial,
        max_slope_initial,
        inner_direction,    /* 0..3 */
        outer_direction,    /* 0..3 */
        depth_direction,    /* 1 or -1 */
        lateral_index,      /* 0 or 1 */
        lateral_max,        /* grid width or height */
        depth_max
    ) ->
        knowledge_grid = character.knowledge.grid
        depth_index = Vec2.otherIndex(lateral_index)
        section_stack = [
            new Section(min_slope_initial, max_slope_initial, 1)
        ]

        while section_stack.length != 0
            section = section_stack.pop!
            depth_absolute_index = (eye_cell.position.arrayGet depth_index) +
                section.depth * depth_direction

            if depth_absolute_index < 0 || depth_absolute_index > depth_max
                continue

            inner_depth_offset = section.depth - 0.5
            outer_depth_offset = inner_depth_offset + 1

            min_inner_lateral_offset = section.min_slope * inner_depth_offset
            min_outer_lateral_offset = section.min_slope * outer_depth_offset

            min_inner_lateral_position = min_inner_lateral_offset +
                eye_cell.centre.arrayGet(lateral_index)
            min_outer_lateral_position = min_outer_lateral_offset +
                eye_cell.centre.arrayGet(lateral_index)

            partial_start_index = Math.floor(Math.min(
                min_inner_lateral_position, min_outer_lateral_position))
            complete_start_index = Math.ceil(Math.max(
                min_inner_lateral_position, min_outer_lateral_position))

            max_inner_lateral_offset = section.max_slope * inner_depth_offset
            max_outer_lateral_offset = section.max_slope * outer_depth_offset

            max_inner_lateral_position = max_inner_lateral_offset +
                eye_cell.centre.arrayGet(lateral_index) - 1
            max_outer_lateral_position = max_outer_lateral_offset +
                eye_cell.centre.arrayGet(lateral_index) - 1

            partial_stop_index = Math.ceil(Math.max(
                max_inner_lateral_position, max_outer_lateral_position))
            complete_stop_index = Math.floor(Math.min(
                max_inner_lateral_position, max_outer_lateral_position))

            start_index = Util.constrain(0, partial_start_index, lateral_max)
            stop_index = Util.constrain(0, partial_stop_index, lateral_max)

            first_iteration = true
            previous_opaque = false
            coord_idx = new Vec2()
            coord_idx.arraySet(depth_index, depth_absolute_index)
            for i from start_index to stop_index
                last_iteration = i == partial_stop_index

                coord_idx.arraySet(lateral_index, i)
                cell = knowledge_grid.array[coord_idx.y][coord_idx.x]

                if (cell.game_cell.position.distanceSquared(eye_cell.position)) < (character.viewDistanceSquared) and \
                    cell.timestamp != game_state.getTurnCount()

                    cell.see(game_state)

                current_opaque = not character.canSeeThrough(cell)
                if previous_opaque and not current_opaque
                    section.min_slope = computeSlope(
                        eye_cell.centre, cell.game_cell.corners[inner_direction],
                        lateral_index, depth_index
                    ) * depth_direction

                if current_opaque and (not previous_opaque) and (not first_iteration)
                    new_max_slope = computeSlope(
                        eye_cell.centre, cell.game_cell.corners[outer_direction],
                        lateral_index, depth_index
                    ) * depth_direction
                    section_stack.push(new Section(
                        section.min_slope, new_max_slope, section.depth + 1))

                if not current_opaque and last_iteration
                    section_stack.push(new Section(
                        section.min_slope, section.max_slope, section.depth + 1))

                previous_opaque = current_opaque
                first_iteration = false


    observe = (character, game_state) ->
        width = character.knowledge.grid.width - 1
        height = character.knowledge.grid.height - 1
        cell = character.getCell()

        character.getKnowledgeCell!see game_state

        # \|
        observeOctant(character, game_state, cell,
            -1, 0,
            Types.OrdinalDirection.NorthWest,
            Types.OrdinalDirection.SouthWest,
            -1, Vec2.X_IDX, width, height
        )

        # |/
        observeOctant(character, game_state, cell,
            0, 1,
            Types.OrdinalDirection.SouthWest,
            Types.OrdinalDirection.NorthWest,
            -1, Vec2.X_IDX, width, height
        )

        # /|
        observeOctant(character, game_state, cell,
            -1, 0,
            Types.OrdinalDirection.SouthWest,
            Types.OrdinalDirection.NorthWest,
            1, Vec2.X_IDX, width, height
        )

        # |\
        observeOctant(character, game_state, cell,
            0, 1,
            Types.OrdinalDirection.NorthWest,
            Types.OrdinalDirection.SouthWest,
            1, Vec2.X_IDX, width, height
        )

        # _\
        observeOctant(character, game_state, cell,
            -1, 0,
            Types.OrdinalDirection.NorthWest,
            Types.OrdinalDirection.NorthEast,
            -1, Vec2.Y_IDX, height, width
        )

        # "/
        observeOctant(character, game_state, cell,
            0, 1,
            Types.OrdinalDirection.NorthEast,
            Types.OrdinalDirection.NorthWest,
            -1, Vec2.Y_IDX, height, width
        )

        # /_
        observeOctant(character, game_state, cell,
            -1, 0,
            Types.OrdinalDirection.NorthEast,
            Types.OrdinalDirection.NorthWest,
            1, Vec2.Y_IDX, height, width
        )

        # \"
        observeOctant(character, game_state, cell,
            0, 1,
            Types.OrdinalDirection.NorthWest,
            Types.OrdinalDirection.NorthEast,
            1, Vec2.Y_IDX, height, width
        )

    {
        observe
    }
