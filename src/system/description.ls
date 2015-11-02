define [
    'util'
], (Util) ->

    class Description
        (@parts, @style = void) ->

        toString: ->
            return @parts.map ((p) -> p.toString()) .join('')

    Description.Styles = Util.enum [
        'Red'
        'Green'
        'Purple'
        'Bold'
    ]

    Description.StyleFunctions = {
        colour: (text, colour) -> new Description(text, colour)
        red: (text) -> @colour(text, Description.Styles.Red)
        green: (text) -> @colour(text, Description.Styles.Green)
        bold: (text) -> @colour(text, Description.Styles.Bold)
        purple: (text) -> @colour(text, Description.Styles.Purple)
    }

    descriptionToString = (description, table) ->
        ret = ""
        if description.style?
            ret += table[description.style][0]

        for p in description.parts
            if typeof p == 'string'
                ret += p
            else
                ret += descriptionToString(p, table)
        
        if description.style?
            ret += table[description.style][1]

        return ret

    Description.descriptionToString = descriptionToString

    return Description
