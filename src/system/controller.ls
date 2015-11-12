define [
    'system/knowledge'
], (Knowledge) ->

    class Controller
        (@grid) ->
            @active = true
            @knowledge = new Knowledge(@character)

        deactivate: ->
            @active = false

        isActive: ->
            return @active
        
        getCell: ->
            return @character.getCell()
        getKnowledgeCell: ->
            return @knowledge.getGrid().getCart(@character.getPosition())
        getOpacity: (cell) ->
            return cell.feature.getOpacity()
