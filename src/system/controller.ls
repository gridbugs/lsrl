define [
    'system/knowledge'
], (Knowledge) ->

    class Controller
        (@grid) ->
            @active = true
            @knowledge = new Knowledge(@grid, this)

        deactivate: ->
            @active = false

        isActive: ->
            return @active
        
        getCell: -> @character.getCell()
        getKnowledgeCell: -> @knowledge.grid.getCart(@character.getPosition())
        getOpacity: (cell) ->
            return cell.feature.getOpacity()
