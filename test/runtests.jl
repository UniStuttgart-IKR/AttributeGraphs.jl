using AttributeGraphs, Graphs
using Test, TestSetExtensions

using MultiGraphs

@testset "AttributeGraphs.jl" begin
    @includetests ["constructors","graphs", "attributes"]
end
