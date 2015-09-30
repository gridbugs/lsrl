define ->

    swap = (arr, i, j) ->
        tmp = arr[i]
        arr[i] = arr[j]
        arr[j] = tmp

    class Heap
        (@le = (<=)) ->
            @array = []
            @next_idx = 1

        insert: (x) ->
            idx = @next_idx
            ++@next_idx
            @array[idx] = x

            while idx != 1
                parent_idx = idx .>>. 1
                if @array[parent_idx] `@le` @array[idx]
                    break
                else
                    swap @array, idx, parent_idx
                    idx = parent_idx

        peak: -> if @size! > 0 then @array[1] else void
        size: -> @next_idx - 1
        empty: -> @size! == 0
        pop: ->
            return void if @empty!

            ret = @array[1]
            @next_idx--
            @array[1] = @array[@next_idx]
            idx = 1
            max_idx = @next_idx - 1
            while true
                left_child_idx = idx .<<. 1
                right_child_idx = left_child_idx + 1

                next_idx = void

                if left_child_idx < max_idx
                    if @array[left_child_idx] `@le` @array[right_child_idx]
                        next_idx = left_child_idx
                    else
                        next_idx = right_child_idx

                    if @array[next_idx] `@le` @array[idx]
                        swap @array, idx, next_idx
                        idx = next_idx
                        continue

                if left_child_idx == max_idx and @array[left_child_idx] `@le` @array[idx]
                    swap @array, idx, left_child_idx

                break

            return ret
