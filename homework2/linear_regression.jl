import Distributions

Uniform = Distributions.Uniform

function rand_points(n)
    rand!(Uniform(-1, 1), Array(Float64, n, 2))
end

function get_f()
    points = rand_points(2)
    i, j = points[1,:], points[2,:]
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
        values[i] = f(points[i,:])
    end
    return points, values, f
end

function pseudoinv(X)
    X_t = transpose(X)
    return inv(X_t * X) * X_t
end

function linear_regression(points, values)
    X = hcat(ones(size(points, 1), 1), points)
    return pseudoinv(X) * values
end

function test_matching(N)
    X, Y, f = get_points(N)
    w = linear_regression(X, Y)
    matching = Array(Bool, N)
    g(x) = sign(transpose(w) * [1, x[1], x[2]])
    points = transpose(X)
    for i in 1:N
        matching[i] = isequal(h(points[:,i])[1], Y[i])
    end
    return matching, g, f
end
