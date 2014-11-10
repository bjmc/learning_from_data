import Distributions

Uniform = Distributions.Uniform

function rand_points(n)
    rand!(Uniform(-1, 1), Array(Float64, n, 2))
end

f(x) = sign(x[1]^2 + x[2]^2 - 0.6)

function training_data(n_good, n_bad)
    X = rand_points(n_good + n_bad)
    Y = Array(Int64, n_good + n_bad)
    for i in 1:n_good
        Y[i] = f(X[i,:])
    end
    for i in n_good+1:n_good+n_bad
        Y[i] = -1 * f(X[i,:])
    end
    return X, Y
end

function transform(p)
    return [1, p[1], p[2], p[1]*p[2], p[1]^2, p[2]^2]
end

function nonlinear_regression(X, Y)
    N = size(X, 1)
    X_transform = Array(Float64, N, 6)
    for i in 1:N
        p = X[i,:]
        X_transform[i,:] = transform(p)
    end
    return pseudoinv(X_transform) * Y
end

a = [-1, -0.05, 0.08, 0.13, 1.5, 1.5]
b = [-1, -0.05, 0.08, 0.13, 1.5, 15]
c = [-1, -0.05, 0.08, 0.13, 15, 1.5]
d = [-1, -1.5, 0.08, 0.13, 0.05, 0.05]
e = [-1, -0.05, 0.08, 1.5, 0.15, 0.15]

function test_closeness()
    X, Y = training_data(900, 100)
    w = nonlinear_regression(X, Y)
    g(x) = sign(transpose(w) * transform(x))
    #return g, X
    our_values = Array(Int64, 1000)
    for i in 1:1000
        #println(X[i,:])
        our_values[i] = g(X[i,:])[1]
    end
    candidates = hcat(a, b, c, d, e)
    for w1 in 1:5
        println("checking candidate ", w1)
        println(candidates[:,w1])
        match = test_matching(candidates[:,w1], X, our_values)
    end
end

function test_matching(w, points, values)
    g(x) = sign(transpose(w) * transform(x))
    N = size(points, 1)
    match = 0
    for i in 1:N
        p = points[i,:]
        if isequal(g(p)[1], values[i])
            match += 1
        end
    end
    return match
    #println(match)
end

function test_E_out()
    X, Y = training_data(900, 100)
    w = nonlinear_regression(X, Y)
    new_data, new_values = training_data(900, 100)
    result = test_matching(w, new_data, new_values)
end
