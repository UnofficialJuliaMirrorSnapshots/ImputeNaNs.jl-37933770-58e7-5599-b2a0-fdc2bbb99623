# from Tim Holy (Compose/color.jl)
# linear interpolation in [a, b] where x is in [0,1],
# or coerced to be if not.
# !@_{}_@! UncheckedPrecondition: a <= b
function lerp01(x::T, a::T, b::T) where {T<:Number}
    a + (b - a) * max(min(x, 1.0), 0.0)
end

# linear interpolation in [a, b]
# !@_{}_@! UncheckedPrecondition: a <= b
function lerp(x::T, a::T, b::T) where {T<:Number}
    a + (b - a) * x
end

# Clamping limits the values allowable
# !@_{}_@! UncheckedPrecondition: a <= b
function clamp(x::T, a::T, b::T) where {T<:Number}
   a <= x <= b && return x
   x < a ? a : b
end



function locf(vec::NullableNumVec, fillback::Bool)
   idx = index_first_nonnull(vec)
   v = locf(vec)
   if !fillback && idx > 1
      v[1:idx-1] = vec[1:idx-1]
   end
   return v
end

function locf(vec::NullableNumVec)
   v = copy(vec)
   locf!(v)
   return v
end

function locf!(vec::NullableNumVec, fillback::Bool)
   idx = index_first_nonnull(vec)
   if !fillback && idx > 1
      vecstart = vec[1:idx-1]
   end
   locf!(vec)
   if !fillback && idx > 1
       vec[1:idx-1] = vecstart
   end
   return nothing
end

function locf!(vec::NullableNumVec)
    n = length(vec)
    vecidxs = 1:n

    if isnull(vec[1])
       idx = index_first_nonnull(view(vec, vecidxs))
       if idx != 0
           vec[1:idx-1] = vec[idx]
       end
    end
    if isnull(vec[end])
       idx = index_final_nonnull(view(vec, vecidxs))
       if idx != 0
           vec[idx+1:end] = vec[idx]
       end
    end

   if any(isnull.(vec))
       n = length(vec)
       nulls_at = index_nulls(vec)
       if n > length(nulls_at)
           vec[nulls_at] = locf_values(view(vec, vecidxs), view(nulls_at,1:length(nulls_at)))
       end
    end

    return nothing
end

function locf_values(vec::NullableNumVec, nulls_at::AbstractIntVec)
    augment = 0
    deltas = [nulls_at[1]-1, diff(nulls_at)...]

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

function index_nulls(vec::NullableNumVec)
    idxs = 1:length(vec)
    nulls = map(isnull, view(vec,idxs))
    return idxs[nulls]
end

"""
    index_first_nonnull(vec)

returns 0 iff all elements of vec are Null
"""
function index_first_nonnull(vec::NullableNumVec)
   result = 0
   for i in 1:length(vec)
      if !isnull(vec[i])
         result = i
         break
      end
   end
   return result
end

"""
    index_final_nonnull(vec)

returns 0 iff all elements of vec are Null
"""
function index_final_nonnull(vec::NullableNumVec)
   result = 0
   for i in length(vec):-1:1
      if !isnull(vec[i])
         result = i
         break
      end
   end
   return result
end
