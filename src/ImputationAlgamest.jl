module ImputationAlgamest

export locf, locf!, lerp, qlerp,
       findmissings, findpresents, removemissings,
       findnothings, findsomethings, removenothings,
       findNaNs, findnonNaNs, removeNaNs,
       isnothing, issomething

const IntFloat = Union{Signed, AbstractFloat}

const Ints   = Union{Int32, Int64}
const Floats = Union{Float32, Float64}

const MaybeInts    = Union{Missing, Ints}
const MaybeFloats  = Union{Missing, Floats}

const MaybeNothing = Union{Missing, Nothing}

include("EndpointRanges.jl")
using .EndpointRanges

include("indicies.jl")  #  index non-values
include("locf.jl")      #  last observation carrys forward 
include("lerp.jl")      #  simple and weighted interpolations
include("getset.jl")    #  datavector's access and restorage smoothified

end # ImputationAlgamest
