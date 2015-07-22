require! './Vec2.ls': {vec2}

export isInt = (x) -> x % 1 == 0

export createRandomUnitVector = ->
    angle = Math.random() * Math.PI * 2
    return vec2 Math.cos(angle), Math.sin(angle)

export class SignedArray
    ->  
        @positive = []
        @negative = []
        @zero = void

    set: (idx, value) ->
        if idx > 0
            @positive[idx - 1] = value
        else if idx < 0
            @negative[-idx - 1] = value
        else
            @zero = value

    get: (idx) ->
        if idx > 0
            return @positive[idx - 1]
        else if idx < 0
            return @negative[-idx - 1]
        else
            return @zero

