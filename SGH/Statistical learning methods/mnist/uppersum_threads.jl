# before starting Julia set JULIA_NUM_THREADS environment variable
# to the number of threads you want to use

using Base.Threads

function upsum_threads(M)
    n = size(M, 1)
    @assert size(M,1) == size(M, 2)
    chunks = nthreads()
    sums = zeros(eltype(M), chunks) # sum holds the sum of chunks
    chunkend = @. round(Int, n * sqrt((1:chunks) / chunks))
    @assert minimum(diff(chunkend)) > 0
    chunkstart = [2; chunkend[1:end-1] .+ 1]
    @threads for job in 1:chunks
        s = zero(eltype(M))
        for i in chunkstart[job]:chunkend[job]
            @simd for j in 1:(i-1)
                @inbounds s += M[j, i]
            end
        end
        sums[job] = s
    end
    return sum(sums)
end

m = randn(10000, 10000);

@time upsum_threads(m)
@time upsum_threads(m)
