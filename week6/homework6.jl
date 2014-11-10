trans(x) = transpose(Float64[1.0, x[1], x[2], x[1]^2, x[2]^2, x[1]*x[2], abs(x[1] - x[2]), abs(x[1] + x[2])])


function load_files()
    in_sample = readdlm("in.dta")
    x_in, y_in = in_sample[:,1:2], in_sample[:,3]
    out_sample = readdlm("out.dta")
    x_out, y_out = out_sample[:,1:2], out_sample[:,3]
    return x_in, y_in, x_out, y_out
end

x_in, y_in, x_out, y_out = load_files()

function do_transform(X)
    Xt = reduce(vcat, [trans(X[i,:]) for i in 1:size(X,1)])
end

function pseudoinv(X)
    X_t = transpose(X)
    return inv(X_t * X) * X_t
end

function linear_regression(points, values)
    return pseudoinv(points) * values
end

function check_err(w, points, values)
    results = Array(Bool, size(points,1))
    for i in 1:size(points,1)
        expected = values[i]
        val = sign(trans(points[i, :]) * w)[1]
        results[i] = !isequal(expected, val)
    end
    return results
end
