using BenchmarkTools
using Profile
using ProfileVega

"""
Uses the sieve of Erastothenes to determine the list of primes up to n.
"""
function primes(n)
    # The methodology is to have an array of indices where if an index m is 0, the number m it represents is not prime.
    indices = ones(n)
    indices[1] = 0 #since 1 isn't prime, we set its index to 0
    # Here we set the composite indices to 0.
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
    # After the indices array is complete, we construct a new array that reads off the indices array
    primes_list = []
    for (i,d) in enumerate(indices)
        if d == 0
            continue
        else
            push!(primes_list, i)
        end
    end
    return primes_list
end

"""
First attempt at improving the primes code. Runs much slower.
"""
function primes2(n)
    # Earlier, we would take every single prime index in this array and use it to set composite numbers to 0. We only need to do this with
    # the primes smaller than √n. So we do the original primes algorithm to get the primes up to √n, then use that on our larger list.
    root_n = Int(ceil(sqrt(n)))
    small_indices = ones(root_n)
    small_indices[1] = 0
    for (i,d) in enumerate(small_indices)
        if d == 0
            continue
        else
            k = 2
            while i*k <= root_n
                small_indices[i*k] = 0
                k += 1
            end
        end
    end
    small_primes_list = []
    for (i,d) in enumerate(small_indices)
        if d == 0
            continue
        else
            push!(small_primes_list, i)
        end
    end
    # Now small_primes_list is the list of primes we need to iterate over to find the rest of the primes.

    indices = ones(n)
    indices[1] = 0
    for d in small_primes_list
        k = 2
        while k*d <= n
            indices[k*d] = 0
            k += 1
        end
    end
    primes_list = []
    for (i,d) in enumerate(indices)
        if d == 0
            continue
        else
            push!(primes_list, i)
        end
    end
    return primes_list
end

"""
Second attempt at improving primes. Actually successful! around 2/3 the runtime of primes()
"""
function primes3(n)
    # Same inprovement as primes2 but implemented differently
    root_n = sqrt(n)
    indices = ones(n)
    indices[1] = 0
    m = 2
    while m <= root_n
        if indices[m] == 0
            m += 1
            continue
        else
            k = 2
            while m*k <= n
                indices[m*k] = 0
                k += 1
            end
            m += 1
        end
    end
    # After the indices array is complete, we construct a new array that reads off the indices array
    primes_list = []
    for (i,d) in enumerate(indices)
        if d == 0
            continue
        else
            push!(primes_list, i)
        end
    end
    return primes_list
end

"""
Returns a list of pairs of twin primes.
"""
function twin_primes(n)
    prime_list = primes3(n)
    twin_prime_list = []
    for (i,d) in enumerate(prime_list)
        if i == length(prime_list)
            break
        elseif d == prime_list[i+1] - 2
            push!(twin_prime_list, (d, prime_list[i+1]))
        end
    end
    return twin_prime_list
end

"""
Returns a list of tuples of length l that are prime numbers (all less than n) that are all spaced dist apart.
If l = 0, then the tuples can be any length.
"""
function prime_sequence(n, dist; l = 0)
    prime_list = primes3(n)
    prime_sequence_list = []
    for (i,d) in enumerate(prime_list)
        k = 1
        group = [d]
        while (l == 0 || k <= l)
            if (d + k*dist) in prime_list[i:length(prime_list)]
                push!(group, d + k*dist)
                k += 1
            else
                break
            end
        end
        if (k == 1 && l == 0)
            continue
        elseif (k != l && l != 0)
            continue
        else
            push!(prime_sequence_list, Tuple(group))
        end
    end
    return prime_sequence_list
end

"""
Takes a list of tuples and reurns the longest one.
"""
function longest_tuple(list)
    record_length = 0
    leading_tuple = []
    for t in list
        if length(t) > record_length
            leading_tuple = []
            record_length = length(t)
            push!(leading_tuple, t)
        elseif length(t) == record_length
            push!(leading_tuple, t)
        end
    end
    return leading_tuple
end