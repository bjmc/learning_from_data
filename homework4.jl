import Distributions

Uniform = Distributions.Uniform

f(x) = sin(pi*x)

#g_hat(x) = 0.002*(x^2)
g_hat(x) = 0.784*x + 0.00077

bias(x) = (g_hat(x) - f(x))^2

var(g, x) = (g(x) - g_hat(x))^2

function get_points(n=2)
    points = rand!(Uniform(-1, 1), Array(Float64, n, 1))
    values = [f(points[1]), f(points[2])]
    return points, values
end

function pseudoinv(X)
    X_t = transpose(X)
    return inv(X_t * X) * X_t
end

function linear_regression(points, values)
    points = hcat(ones(size(points, 1), 1), points)
    return pseudoinv(points) * values
end

function multiple_runs(N, transform=x->x)
    a = Array(Float64, N)
    b = Array(Float64, N)
    for i in 1:N
        points, values = get_points()
        points = map(transform, points)
        result = linear_regression(points, values)
        a[i] = result[2]
        b[i] = result[1]
    end
    return mean(a), mean(b)
end

function multiple_bias(N)
    results = Array(Float64, N)
    for i in 1:N
        results[i] = bias(rand(Uniform(-1, 1)))
    end
    return mean(results)
end

function multiple_var(N)
    final_results = Array(Float64, N)
    for i in 1:N
        points, values = get_points()
        m, b = linear_regression(points, values)
        g(x) = m*x + b
        temp_results = Array(Float64, N)
        for j in 1:N
            temp_results[j] = var(g, rand(Uniform(-1, 1)))
        end
        final_results[i] = mean(temp_results)
    end
    return mean(final_results)
end


function from_minima(points)
    x1 = points[1]
    x2 = points[2]
    return 2(sin(pi*x1)*x1 + sin(pi*x2)*x2) / (x1^2 + x2^2)
end



