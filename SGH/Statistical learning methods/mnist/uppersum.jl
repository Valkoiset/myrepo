function uppersum(M)
    n = size(M, 1)
    s = zero(eltype(M)) #whatever type of matrix is m - initialize
    for i in 2:n
        @simd for j in 1:(i-1) # tells processor that this step may be paralellized
            @inbounds s += M[j, i] # inbounds disables bounds checking operation in Julia
        end
    end
    s
end

@time m = randn(10_000, 10_000);
@time m = randn(10_000, 10_000);

m

@time sum(m)
@time sum(m)

@time uppersum(m)
@time uppersum(m)
