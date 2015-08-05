define [
    \vec2
], (Vec2) ->

    class Section
        (@min_slope, @max_slope, @depth) ->

    observeOctant = (
        eye_cell,
        min_slope_initial,
        max_slope_initial,
        inner_direction,    /* 0..3 */
        outer_direction,    /* 0..3 */
        depth_direction,    /* 1 or -1 */
        lateral_index,      /* 0 or 1 */
        lateral_max,        /* grid width or height */
        knowledge_grid
    ) ->
        depth_index = Vec.otherIndex lateral_index
        section_stack = [
            new Section(min_slope_initial, max_slope_initial, 1)
        ]

        depth = 0

        while section_stack.length != 0
            section = section_stack.pop!
            depth_absolute_index = (eye_cell.position.arrayGet depth_index) +
                section.depth * depth_direction

    observe = (character, game_state) ->
        character.knowledge.grid.forEach (c) ->
            if (character.position.distance c.game_cell.position) < 10
                c.see game_state

    {
        observe
    }
