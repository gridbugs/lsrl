define [
], ->
    class ActionStatus
        (@action, @gameState) ->
            @message = void
            @time = 0
            @success = true
            @rescheduleRequired = true

        addTime: (time) ->
            @time += time

        notify: (subject, message, callback) ->
            subject.forEachMatchingEffect message, (effect) ~>
                effect.apply(this)

            if @isSuccessful()
                callback()

        check: (subject, skill, callback) ->

        tryNotNull: (object, failure, callback) ->
            if object?
                callback(object)
            else
                @fail(failure)

        fail: (failure) ->
            @message = failure
            @success = false

        isSuccessful: ->
            return @success

        getTime: ->
            return @time

        getMessage: ->
            return @message

        isRescheduleRequired: ->
            return @rescheduleRequired

    {
        ActionStatus
    }
