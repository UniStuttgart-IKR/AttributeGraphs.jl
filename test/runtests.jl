using AttributeGraphs, Graphs
using Test, TestSetExtensions

using WMultiGraphs

@testset "AttributeGraphs.jl" begin
    @includetests ["constructors","graphs", "attributes"]
end
