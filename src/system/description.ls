define [
    'util'
], (Util) ->

    class Description
        (@parts, @style = void) ->
            @thirdPersonSingular = true
            @parts = @parts.filter (?)

        toString: ->
            return @parts.map ((p) -> p.toString()) .join('')

        capitaliseFirstLetter: ->
            first_part = @parts[0]
            if typeof first_part == 'string'
                @parts[0] = first_part.slice(0, 1).toUpperCase().concat(first_part.slice(1))
            else
                first_part.capitaliseFirstLetter()

            return this

        append: (desc) ->
            @parts.push(desc)
            return this

    Description.PluralDescription = class extends Description
        (@parts, @style = void) ->
            super(@parts, @style)
            @thirdPersonSingular = false

    Description.Styles = Util.enum [
        'Red'
        'Green'
        'Purple'
        'Yellow'
        'Bold'
    ]

    Description.StyleFunctions = {
        colour: (text, colour) -> new Description(text, colour)
        red: (text) -> @colour(text, Description.Styles.Red)
        green: (text) -> @colour(text, Description.Styles.Green)
        purple: (text) -> @colour(text, Description.Styles.Purple)
        yellow: (text) -> @colour(text, Description.Styles.Yellow)
        bold: (text) -> @colour(text, Description.Styles.Bold)
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
