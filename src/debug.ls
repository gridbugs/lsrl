define [
], ->

    assert = (condition, message) ->
        if not condition
            throw message || "Assertion failed!"

    {
        assert
    }
