using DataFrames
using Gadfly

flip_coins() = rand!(0:1, Array(Bool, 10, 1000))

function get_proportions(all_flips)
    v_1 = mean(all_flips[:, 1])
    v_rand = mean(all_flips[:, rand(1:1000)])
    v_min = 1
    for i in 1:1000
        proportion = mean(all_flips[:, i])
        if proportion < v_min
            v_min = proportion
        end
    end
    return v_1, v_rand, v_min
end

function multiple_runs(N)
    results = DataFrame(Float64, 3, N)
    names!(results, map(symbol, ["v1", "vrand", "vmin"]))
    for r in 1:N
        results[:, r] = [get_proportions(flip_coins())...]
    end
    return results
end

