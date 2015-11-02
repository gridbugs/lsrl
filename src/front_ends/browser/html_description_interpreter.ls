define [
    'system/description'
    'util'
], (Description, Util) ->
    make_colour_span = (colour) -> "<span style='color:#{colour}'>"

    DescriptionStyleTable = Util.table Description.Styles, {
        'Red': [make_colour_span('red'), '</span>']
        'Green': [make_colour_span('green'), '</span>']
        'Purple': [make_colour_span('purple'), '</span>']
        'Yellow': [make_colour_span('yellow'), '</span>']
        'Bold': ["<span style='font-weight: bold'>", '</span>']
    }

    descriptionToHtmlString = (description) ->
        return Description.descriptionToString(description, DescriptionStyleTable)

    {
        descriptionToHtmlString
    }
