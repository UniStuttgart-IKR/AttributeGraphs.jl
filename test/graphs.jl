@testset "graphs" begin
    ag = OAttributeGraph()
    @test all([addvertex!(ag) for _ in 1:5])
    @test addedge!(ag, 1, 2)
    @test !addedge!(ag, Edge(1, 2))
    @test addedge!(ag, 5, 1)
    @test !addedge!(ag, 1, 5)
    @test !is_directed(ag)
    @test nv(ag) == 5
    @test ne(ag) == 2

    # Bidirectional
    adg = OAttributeGraph(SimpleDiGraph())
    all([addvertex!(adg) for _ in 1:5])
    @test addedge!(adg, 1, 2)
    @test !addedge!(adg, Edge(1, 2))
    @test addedge!(adg, 5, 1)
    @test addedge!(adg, 1, 5)
    @test is_directed(adg)
    @test nv(adg) == 5
    @test ne(adg) == 3

    # MutliGraph
    amg = OAttributeGraph(MultiGraph())
    @test all([addvertex!(amg) for _ in 1:5])
    @test addedge!(amg, 1, 2)
    @test addedge!(amg, Edge(1, 2))
    @test addedge!(amg, 5, 1)
    @test addedge!(amg, 1, 5)
    @test !is_directed(amg)
    @test nv(amg) == 5
    @test ne(amg) == 4
end
