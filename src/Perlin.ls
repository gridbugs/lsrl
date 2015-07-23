require! 'prelude-ls': {map, each, zip}
require! './Util.ls': {SignedArray, createRandomUnitVector}
require! './Vec2.ls': {vec2}

export class PerlinGenerator
    ->
        @rows = new SignedArray!

    __generateGradient: (v) ~>
        if not @rows.get(v.y)?
            @rows.set(v.y, new SignedArray!)
        if not @rows.get(v.y).get(v.x)?
            @rows.get(v.y).set(v.x, createRandomUnitVector!)

    __easeCurve: (x) ->
        6*Math.pow(x, 5) - 15*Math.pow(x, 4) + 10*Math.pow(x, 3)

    __getGradient: (v) ~> @rows.get(v.y).get(v.x)

    getNoise: (v) ->
        top_left = vec2 (Math.floor v.x), (Math.floor v.y)
        corners =
            top_left
            top_left.add (vec2 1 0)
            top_left.add (vec2 0 1)
            top_left.add (vec2 1 1)

        each @__generateGradient, corners
        gradients = map @__getGradient, corners

        dots = for i from 0 til 4
            gradients[i].dot (v.subtract corners[i])

        weight_x = @__easeCurve (v.x - top_left.x)
        weight_y = @__easeCurve (v.y - top_left.y)
        avg0 = dots[0] + weight_x * (dots[1] - dots[0])
        avg1 = dots[2] + weight_x * (dots[3] - dots[2])
        avg = avg0 + weight_y * (avg1 - avg0)

        return avg;
