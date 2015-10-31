define [
    'system/description'
    'front_ends/console/colours'
    'front_ends/console/text'
    'util'
], (Description, Colours, Text, Util) ->
    make_colour_span = (colour) -> "<span style='color:#{colour}'>"

    white_text = Text.setForegroundColour(Colours.White)

    DescriptionStyleTable = Util.table Description.Styles, {
        'Red': [Text.setForegroundColour(Colours.Red), white_text]
        'Green': [Text.setForegroundColour(Colours.Green), white_text]
        'Bold': [Text.setBoldWeight(), Text.setNormalWeight()]
    }

    descriptionToConsoleString = (description) ->
        return Description.descriptionToString(description, DescriptionStyleTable)

    {
        descriptionToConsoleString
    }
