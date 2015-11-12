define [
    'interface/input'
    'interface/key'
], (InputSource, Key) ->

    class BrowserInputSource extends InputSource
        ->
            super()

            $(window).keydown (e) ~>
                if @currentCallback?
                    callback = @currentCallback
                    @currentCallback = null

                    key = new Key(
                        String.fromCharCode(e.keyCode),
                        e.keyCode,
                        e.shiftKey,
                        e.ctrlKey,
                        e.metaKey
                    )

                    callback(key)
                else
                    @dirty = true
