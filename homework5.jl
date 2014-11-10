import Distributions

Uniform = Distributions.Uniform


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

function get_points(N, f=nothing)
    if f === nothing
        f = get_f()
    end
    points = rand_points(N)
    values = Array(Int64, N)
    for i = 1:N
        values[i] = f(points[:,i])
    end
    return points, values, f
end

function setup(N)
    points, values, f = get_points(N)
    w = zeros(1, 3)
    return f, w, points, values
end

n = 0.01

function grad(w, x, y)
    return -(x * y) / (1+e^(y * (w*x)[1]))
end

function logistic_regression(epochs, N, stop)
    target_f, w, training, values = setup(N)
    training = vcat(ones(1, N), training)
    for i in 1:epochs
        #println("epoch is ", i)
        order = sort([1:N], by=x->rand())
        new_w = w
        for j in order
            point = training[:, j]
            value = values[j]
            g = grad(w, point, value)
            new_w = new_w - (n * transpose(g))
        end
        #println("w is ", w)
        #println("new_w is ", new_w)
        step = norm(w - new_w)
        #println("step is ", step)
        if step < stop
            return new_w, i, target_f
        end
        w = new_w
    end
end

function err(x, y, w)
    log(1+e^(-y * (w*x)[1]))
end

function problem8(runs=100, N=100)
    average_err = Array(Float64, runs)
    for run in 1:runs
        w, epoch, f = logistic_regression(500, N, 0.01)
        out_points, out_values, f = get_points(N, f)
        out_points = vcat(ones(1, N), out_points)
        summation = 0.0
        for i in 1:N
            summation += err(out_points[:, i], out_values[i], w)
        end
        total_err = summation / N
        average_err[run] = total_err
    end
    return mean(average_err)
end
