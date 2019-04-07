








#=


"""
   locf(vec [, fillback]) is "last observation carry forward"

Overwrite NaNs [Nulls] with the prior non-NaN [non-Null] values.

If fillback=true (default) and vec starts with NaNs [Nulls],
vec starts with NaNs [Nulls], those values will be overwritten
with the first non-NaN [non-Null] value.
"""
function locf(vec::AbstractFloatVec, fillback::Bool)
   idx = index_first_nonnan(vec)
   v = locf(vec)
   if fillback==false && idxhttps://github.com/JuliaArrays/EndpointRanges.jl > 1
      v[1:idx-1] = NaN
   end
   return v
end

function locf(vec::AbstractFloatVec)
   v = copy(vec)
   locf!(v)
   return v
end


"""
   locf!(vec [, fillback]) is "last observation carry forward" in place

Overwrite NaNs [Nulls] with the prior non-NaN [non-Null] values

If fillback=true (default) and vec starts with NaNs [Nulls],
those values will be overwritten with the first non-NaN [non-Null] value.
"""
function locf!(vec::AbstractFloatVec, fillback::Bool)
   idx = index_first_nonnan(vec)
   locf!(vec)
   if fillback==false && dx > 1
      vec[1:idx-1] = NaN
   end
   return nothing
end

function locf!(vec::AbstractFloatVec)
    n = length(vec)
    vecidxs = 1:n

    if isnan(vec[1])
       idx = index_first_nonnan(view(vec, vecidxs))
       if idx != 0
           vec[1:idx-1] = vec[idx]
       end
    end
    if isnan(vec[end])
       idx = index_final_nonnan(view(vec, vecidxs))
       if idx != 0
          vec[idx+1:end] = vec[idx]
       end
    end

    if any(isnan.(vec))
       n = length(vec)
       nans_at = index_nans(vec)
       if n > length(nans_at)
           vec[nans_at] = locf_values(view(vec, vecidxs), view(nans_at,1:length(nans_at)))
      end
    end

    return nothing
end

function locf_values(vec::AbstractFloatVec, nans_at::AbstractIntVec)
    augment = 0
    deltas = [nans_at[1]-1, diff(nans_at)...]

    for i in 2:length(deltas)
        if deltas[i] == 1
            augment += 1
            deltas[i] = 0
        else
            deltas[i] += augment
            augment = 0
        end
    end

    return cumsum(deltas)
end

function index_nans(vec::AbstractFloatVec)
    idxs = 1:length(vec)
    nans = map(isnan, view(vec,idxs))
    return idxs[nans]
end

"""
    index_first_nonnan(vec)

returns 0 iff all elements of vec are NaN
"""
function index_first_nonnan(vec::AbstractFloatVec)
   result = 0
   for i in 1:length(vec)
      if !isnan(vec[i])
         result = i
         break
      end
   end
   return result
end

"""
    index_final_nonnan(vec)

returns 0 iff all elements of vec are NaN
"""
function index_final_nonnan(vec::AbstractFloatVec)
   result = 0
   for i in length(vec):-1:1
      if !isnan(vec[i])
         result = i
         break
      end
   end
   return result
end

=#
