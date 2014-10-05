import Distributions

Uniform = Distributions.Uniform

function rand_points(n)
    r(i) = rand(Uniform(-1, 1))
    [ntuple(2, r) for x=1:n]
end

function get_f()
    i, j = rand_points(2)
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
    values = [f(p) for p in points]
    return points, values, f
end

function setup(N):
    points, values, f = get_points()
    w = zeros(3)
    return f, w, points, values
end

function pla(w, points, values, f)

    miscategorized = sign(transpose(w) * [p[1], p[2], 1]
end

