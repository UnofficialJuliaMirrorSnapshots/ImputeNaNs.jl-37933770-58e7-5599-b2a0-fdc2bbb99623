# ImputationAlgamest.jl

## overwrites `missing` or `nothing` or `NaN` values
- last observation carry forward (locf)

### supports 1D, 2D, 3D, 4D, 5D, 6D AbstractArrays

#### Copyright © 2017-2018 by Jeffrey Sarnoff.  Released under the MIT License.

-----

[![Build Status](https://travis-ci.org/JeffreySarnoff/FillValues.jl.svg?branch=master)](https://travis-ci.org/JeffreySarnoff/FillValues.jl)
-----

# exports

locf

# use

```julia
using ImputationAlgamest

locf([1.0, missing, 2.0, missing, missing, 3.0])
# [1.0, 1.0, 2.0, 2.0, 2.0, 3.0]

locf([1.0, missing, 2.0, missing, missing])
# [1.0, 1.0, 2.0, 2.0, 2.0]

locf([missing, 2.0, missing, missing, 3.0])
# [missing, 1.0, 2.0, 2.0, 2.0, 3.0]

# locf(vec, false)
# [NaN, 1.0, 1.0, 2.0, 2.0, 2.0]
```

