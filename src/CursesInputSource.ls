export class CursesInputSource
    (window) ->
        @currentCallback = (->)
        @window = window
        window.on 'inputChar' (c) ~>
            tmp = @currentCallback
            @currentCallback = (->)
            tmp c

    getChar: (cb) ->
        @currentCallback = cb
