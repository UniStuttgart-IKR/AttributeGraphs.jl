@testset "opinionated" begin

    oag = OAttributeGraph(SimpleGraph(10))
    @test nv(oag) == length(vertex_attr(oag))
    
end

  






