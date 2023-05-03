using AttributeGraphs, Graphs
using Test, TestSetExtensions

using WrappedMultiGraphs

@testset "AttributeGraphs.jl" begin
    @includetests ["constructors","graphs", "attributes",  "opinionatedtest"]
end
