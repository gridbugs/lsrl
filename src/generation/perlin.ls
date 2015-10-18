define [
    'structures/signed_array'
    'structures/vec2'
    'prelude-ls'
], (SignedArray, Vec2, Prelude) ->

    const map = Prelude.map
    const each = Prelude.each

    class PerlinGenerator
        ->
            @rows = new SignedArray()

        __generateGradient: (v) ->
            if not @rows.get(v.y)?
                @rows.set(v.y, new SignedArray())
            if not @rows.get(v.y).get(v.x)?
                @rows.get(v.y).set(v.x, Vec2.createRandomUnitVector())

        __easeCurve: (x) ->
            return 6*Math.pow(x, 5) - 15*Math.pow(x, 4) + 10*Math.pow(x, 3)

        __getGradient: (v) ->
            return @rows.get(v.y).get(v.x)

        getNoise: (v) ->

            top_left = new Vec2(Math.floor(v.x), Math.floor(v.y))
            corners = [
                top_left,
                top_left.add(new Vec2(1, 0)),
                top_left.add(new Vec2(0, 1)),
                top_left.add(new Vec2(1, 1))
            ]

            for c in corners
                @__generateGradient(c)

            gradients = corners.map(@~__getGradient)

            dots = new Array(4)
            for i from 0 til 4
                dots[i] = gradients[i].dot(v.subtract corners[i])

            weight_x = @__easeCurve(v.x - top_left.x)
            weight_y = @__easeCurve(v.y - top_left.y)
            avg0 = dots[0] + weight_x * (dots[1] - dots[0])
            avg1 = dots[2] + weight_x * (dots[3] - dots[2])
            avg = avg0 + weight_y * (avg1 - avg0)

            return avg
