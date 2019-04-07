using ImputeNaNs
using Base.Test

novalue = NaN
a = [novalue]
b = [novalue, novalue]
c = [1.0, 2.0, 3.0]
d = [1.0, novalue, 3.0]
e = [1.0, 2.0, novalue]
f = [novalue, 2.0, 3.0]

@test isnan(locf(a)[1])
@test isnan(locf(b)[1])
@test isnan(locf(b)[2])
@test locf(c) == c
@test locf(d) == [1.0, 1.0, 3.0]
@test locf(e) == [1.0, 2.0, 2.0]
@test locf(f) == [2.0, 2.0, 3.0]
@test locf(f, true) == [2.0, 2.0, 3.0]
@test isnan(locf(f, false)[1])

novalue = Nullable{Float64}()
a = [Nullable{Float64}(1.0), Nullable{Float64}(2.0), Nullable{Float64}(3.0)]
b = [Nullable{Float64}(1.0), novalue, Nullable{Float64}(3.0)]
c = [Nullable{Float64}(1.0), Nullable{Float64}(2.0), novalue]
d = [novalue, Nullable{Float64}(2.0), Nullable{Float64}(3.0)]

@test all(locf(a) .=== a)
@test all(locf(b) .=== [Nullable{Float64}(1.0), Nullable{Float64}(1.0), Nullable{Float64}(3.0)])
@test all(locf(c) .=== [Nullable{Float64}(1.0), Nullable{Float64}(2.0), Nullable{Float64}(2.0)])
@test all(locf(d) .=== [Nullable{Float64}(2.0), Nullable{Float64}(2.0), Nullable{Float64}(3.0)])
@test isnull(locf(d, false)[1])
@test !isnull(locf(d, true)[1])
