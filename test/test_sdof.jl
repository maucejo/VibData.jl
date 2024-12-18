using Parameters, DSP, LinearAlgebra
using GLMakie

includet("../src/functions/sdof.jl")
includet("../src/functions/excitation.jl")

# SDOF system
m = 1.
ω₀ = 2π*10.
ξ = 0.01
sdof = SDOF(m, ω₀, ξ)

# Time vector
Δt = 1e-3
t = 0.:Δt:10.

# Excitation
F₀ = 10.
param = (type = :rectangle, F₀ = F₀, ts = t[1], duration = t[end])
F = excitation(param, t)

# Exact solution
Ω₀ = ω₀*√(1 - ξ^2)
xexact = @. F₀*(Ω₀ - (Ω₀*cos(Ω₀*t) + ξ*ω₀*sin(Ω₀*t))*exp(-ξ*ω₀*t))/m/Ω₀/(Ω₀^2 + ξ^2*ω₀^2)

# Duhamel's integral
x = forced_response_any(sdof, F, t)

# Plot
lines(t, xexact, color = :blue)
lines!(t, x, color = :red)