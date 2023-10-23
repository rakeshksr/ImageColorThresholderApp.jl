using ImageColorThresholderApp
using Makie
using ColorTypes
using Aqua
using Test

@testset "ImageColorThresholderApp.jl" begin
    include("test_aqua.jl")
    include("test_imagechannels.jl")
end
