define [
], ->
    interleave = (a, b, n_each) ->
        arr = new Array(n_each * 2)
        for i from 0 til n_each
            arr[i*2] = a
        for i from 0 til n_each
            arr[i*2+1] = b
        return arr

    spread = (a, b, n_a, n_b) ->

        # to simplify things, ensure n_a >= n_b
        if n_a < n_b
            return spread(b, a, n_b, n_a)

        # simple case - can just interleave
        if n_a == n_b
            return interleave(a, b, n_a)

        # simple case - return all a
        if n_b == 0
            arr = new Array(n_a)
            for i from 0 til n_a
                arr[i] = a
            return arr

        # groups of a are separated by b, so there are n_b + 1 groups of a
        n_groups = n_b + 1

        # determine group sizes
        small_group_size = Math.floor(n_a/n_groups)
        large_group_size = small_group_size + 1

        # determine distribution of group sizes
        n_large_groups = n_a % n_groups
        n_small_groups = n_groups - n_large_groups

        # interleave sizes of groups of a
        size_arr = spread(small_group_size, large_group_size, n_small_groups, n_large_groups)

        # use group size distribution to generate spread array
        n = n_a + n_b
        arr = new Array(n)
        k = 0
        for i from 0 til n_groups
            for j from 0 til size_arr[i]
                arr[k] = a
                ++k
            if k < n
                arr[k] = b
                ++k
        return arr

    {
        interleave
        spread
    }
