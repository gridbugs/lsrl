define [
    'interface/console'
    'front_ends/console/box'
    'front_ends/console/blessed/util'
    'util'
], (BaseConsole, Box, BlessedUtil, Util) ->

    class Console extends BaseConsole implements BlessedUtil.Boxable
        (@program, @left, @top, @width, @height) ->
            @border = Box.BorderSingleLineUnicodeBold

        refresh: ->
            @drawBox()
            @program.flushBuffer()

        print: ->
            @refresh()
        newLine: ->
        clearLine: ->
        readString: ->
        readInteger: ->
