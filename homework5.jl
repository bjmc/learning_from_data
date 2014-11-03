import Distributions

Uniform = Distributions.Uniform

n = 0.1
E(u, v) = (u*e^v - 2*v*e^(-u))^2

du(u, v) = 2*(e^v + 2*v*e^(-u))*(u*e^v - 2*v*e^(-u))

dv(u, v) = 2*(u*e^v - 2*v*e^(-u))*(u*e^v - 2*e^(-u))

function gradient_descent(min_E)
    u, v = 1, 1
    i = 0
    E_val = E(u, v)
    while E_val > min_E
        new_u = u - du(u, v) * n
        new_v = v - dv(u, v) * n
        u, v = new_u, new_v
        E_val = E(u, v)
        i += 1
    end
    return E_val, i, u, v
end

function coordinate_descent(N)
    u, v = 1, 1
    E_val = E(u, v)
    for i in 1:N
        print(i, "\n")
        u = u - du(u, v) * n
        v = v - dv(u, v) * n
        E_val = E(u, v)
    end
    return E_val
end

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
