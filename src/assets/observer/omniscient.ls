define [
], ->

    class Omniscient
        observe: (character, game_state) !->
            character.knowledge.getGrid().forEach (c) !->
                c.see(game_state)
