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
    one_bad = bad[rand(1:size(bad, 1))]
    y = values[one_bad]
    bad_point = points[:, one_bad]
    w = w + (y * [1, bad_point[1], bad_point[2]])
    return w, bad, one_bad
end

function multiple_pla(n_runs, w, points, values)
    for i = 1:n_runs
        w = pla(w, points, values)[1]
    end
end

