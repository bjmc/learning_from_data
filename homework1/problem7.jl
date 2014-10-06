import Distributions

Uniform = Distributions.Uniform

function rand_points(n)
    rand!(Uniform(-1, 1), Array(Float64, 2, n))
end

function get_f()
    points = rand_points(2)
    i, j = points[:,1], points[:,2]
    m = (j[2] - i[2]) / (j[1] - i[1])
    b = i[2] - (m * i[1])
    line(x) = m*x + b
    function f(point)
        y = line(point[1])
        if point[2] > y
            return 1
        elseif point[2] < y
            return -1
        end
    end
    return f
end

function get_points(N)
    f = get_f()
    points = rand_points(N)
    values = Array(Int64, N)
    for i = 1:N
        values[i] = f(points[:,i])
    end
    return points, values, f
end

function setup(N)
    points, values, f = get_points(N)
    w = zeros(3)
    return f, w, points, values
end

function pla(w, points, values)
    bad = Int64[]
    for i in 1:size(points, 2)
        p = points[:,i]
        g = sign(transpose(w) * [1, p[1], p[2]])[1]
        y = values[i]
        if !isequal(g, y)
            push!(bad, i)
        end
    end
    one_bad = nothing
    if length(bad) > 0
        one_bad = bad[rand(1:size(bad, 1))]
        y = values[one_bad]
        bad_point = points[:, one_bad]
        w = w + (y * [1, bad_point[1], bad_point[2]])
    end
    return w, bad, one_bad
end

function multiple_pla(max_runs, w, points, values)
    i = 0
    for i = 1:max_runs
        w, bad, one = pla(w, points, values)
        if length(bad) == 0
            break
        end
    end
    return w, i
end

function converges_after(N, n_runs)
    runs = Array(Int64, n_runs)
    for i in 1:n_runs
        f, w, points, values = setup(N)
        runs[i] = multiple_pla(10000, w, points, values)[2]
    end
    mean(runs)
end

function mismatch_chance(N, n_test, n_points)
    results = Array(Float64, n_test)
    for i = 1:n_test
        temp_results = Array(Bool, n_points)
        f, w, in_points, values = setup(N)
        w = multiple_pla(10000, w, in_points, values)[1]
        g(p) = sign(transpose(w) * [1, p[1], p[2]])[1]
        out_points = rand_points(n_points)
        for j = 1:n_points
            t = out_points[:, j]
            mismatch = !isequal(f(t), g(t))
            temp_results[j] = mismatch
        end
        results[i] = mean(temp_results)
    end
    return mean(results)
end
