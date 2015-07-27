export class CursesInputSource
    (window) ->
        @currentCallback = (->)
        @window = window
        window.on 'inputChar' (c) ~>
            process.stderr.write "inputChar #{c}\n"
            tmp = @currentCallback
            @currentCallback = (->)
            tmp c

    getChar: (cb) ->
        process.stderr.write "getChar\n"
        @window.top!
        @currentCallback = cb
