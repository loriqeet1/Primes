"""
Uses the sieve of Erastothenes to determine the list of primes up to n.
"""
function primes(n)
    indices = ones(n)
    indices[1] = 0
    for (i,d) in enumerate(indices)
        if d == 0
            continue
        else
            k = 2
            while i*k <= n
                indices[i*k] = 0
                k += 1
            end
        end
    end
    return indices
end