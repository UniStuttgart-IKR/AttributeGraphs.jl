@testset "attributes" begin
    ag = OAttributeGraph(;vertex_type=String, edge_type=String, graph_type=Dict{Symbol, String})
    all([addvertex!(ag) for _ in 1:5])
    addedge!(ag, 1, 2)
    addedge!(ag, 2, 1)
    addedge!(ag, 1, 3)
    addedge!(ag, 5, 1)
    addedge!(ag, 1, 4)
    addedge!(ag, 3, 4)
    addedge!(ag, 3, 5)
    @test ne(ag) == 6

    addgraphattr!(ag, :ena, "ena")
    addgraphattr!(ag, :dio, "dio")
    @test_throws MethodError addgraphattr!(ag, "tria", "tria")
    @test graph_attr(ag) == Dict{Symbol,String}(:ena => "ena", :dio => "dio")

    @test all(ismissing.(vertex_attr(ag)))
    addvertexattr!(ag, 3, "tria-stays")
    addvertexattr!(ag, 4, "tessera-is-deleted")
    addvertexattr!(ag, 5, "pente-becomes-tessera")
    @test ismissing.(vertex_attr(ag)) == [true, true, false, false, false]
    @test collect(skipmissing(vertex_attr(ag))) == ["tria-stays","tessera-is-deleted","pente-becomes-tessera"]

    addedgeattr!(ag, 1, 2, "1.2-deleted")
    addedgeattr!(ag, 1, 3, "1.3-stays")
    addedgeattr!(ag, 1, 4, "1.4-deleted")
    addedgeattr!(ag, 3, 4, "3.4-deleted")
    addedgeattr!(ag, 3, 5, "3.5-tobecome-3.4")
    addedgeattr!(ag, 2, 5, "nolinkshouldnotappear")

    @test edge_attr(ag) == Dict{Tuple{Int,Int,Int}, String}((1,2,1)=>"1.2-deleted", (1,3,1) =>"1.3-stays", (1,4,1)=>"1.4-deleted", (3,4,1)=>"3.4-deleted", (3,5,1)=>"3.5-tobecome-3.4")

    remedge!(ag, 1, 2)
    @test edge_attr(ag) == Dict{Tuple{Int,Int,Int}, String}((1,3,1) =>"1.3-stays", (1,4,1)=>"1.4-deleted", (3,4,1)=>"3.4-deleted", (3,5,1)=>"3.5-tobecome-3.4")

    remvertex!(ag, 4)
    @test ismissing.(vertex_attr(ag)) == [true, true, false, false]
    @test collect(skipmissing(vertex_attr(ag))) == ["tria-stays","pente-becomes-tessera"]
    @test nv(ag) == length(vertex_attr(ag)) == 4
    @test edge_attr(ag) == Dict{Tuple{Int,Int,Int}, String}((1,3,1) =>"1.3-stays", (3,4,1)=>"3.5-tobecome-3.4")


    # MultiDiGraph
    amdg = OAttributeGraph(MultiDiGraph();vertex_type=String, edge_type=String, graph_type=Dict{Symbol, String})
    all([addvertex!(amdg) for _ in 1:5])
    addedge!(amdg, 1, 2)
    addedge!(amdg, 1, 2)
    addedge!(amdg, 1, 2)
    addedge!(amdg, 2, 1)
    addedge!(amdg, 1, 3)
    addedge!(amdg, 5, 1)
    addedge!(amdg, 1, 4)
    addedge!(amdg, 3, 4)
    addedge!(amdg, 3, 5)
    addedge!(amdg, 3, 5)
    @test ne(amdg) == 10

    addgraphattr!(amdg, :ena, "ena")
    addgraphattr!(amdg, :dio, "dio")
    @test_throws MethodError addgraphattr!(amdg, "tria", "tria")
    @test graph_attr(amdg) == Dict{Symbol,String}(:ena => "ena", :dio => "dio")

    @test all(ismissing.(vertex_attr(amdg)))
    addvertexattr!(amdg, 3, "tria-stays")
    addvertexattr!(amdg, 4, "tessera-is-deleted")
    addvertexattr!(amdg, 5, "pente-becomes-tessera")
    @test ismissing.(vertex_attr(amdg)) == [true, true, false, false, false]
    @test collect(skipmissing(vertex_attr(amdg))) == ["tria-stays","tessera-is-deleted","pente-becomes-tessera"]

    addedgeattr!(amdg, 1, 2, 1, "1.2-deleted_first")
    addedgeattr!(amdg, 1, 2, 2, "1.2.2-deleted_last")
    addedgeattr!(amdg, 1, 2, 3, "1.2.3-deleted_second")
    addedgeattr!(amdg, 1, 3, "1.3-stays")
    addedgeattr!(amdg, 1, 4, "1.4-deleted")
    addedgeattr!(amdg, 3, 4, "3.4-deleted")
    addedgeattr!(amdg, 3, 5, "3.5-tobecome-3.4")
    addedgeattr!(amdg, 2, 5, "nolinkshouldnotappear")

    @test edge_attr(amdg) == Dict{Tuple{Int,Int,Int}, String}((1,2,1)=>"1.2-deleted_first", (1,2,2)=>"1.2.2-deleted_last", (1,2,3)=>"1.2.3-deleted_second", (1,3,1) =>"1.3-stays", (1,4,1)=>"1.4-deleted", (3,4,1)=>"3.4-deleted", (3,5,1)=>"3.5-tobecome-3.4")

    remedge!(amdg, 1, 2)
    @test edge_attr(amdg) == Dict{Tuple{Int,Int,Int}, String}((1,2,1)=>"1.2.2-deleted_last", (1,2,2)=>"1.2.3-deleted_second", (1,3,1) =>"1.3-stays", (1,4,1)=>"1.4-deleted", (3,4,1)=>"3.4-deleted", (3,5,1)=>"3.5-tobecome-3.4")

    remedge!(amdg, 1, 2, 2)
    @test edge_attr(amdg) == Dict{Tuple{Int,Int,Int}, String}((1,2,1)=>"1.2.2-deleted_last", (1,3,1) =>"1.3-stays", (1,4,1)=>"1.4-deleted", (3,4,1)=>"3.4-deleted", (3,5,1)=>"3.5-tobecome-3.4")

    remedge!(amdg, 1, 2, 1)
    @test edge_attr(amdg) == Dict{Tuple{Int,Int,Int}, String}((1,3,1) =>"1.3-stays", (1,4,1)=>"1.4-deleted", (3,4,1)=>"3.4-deleted", (3,5,1)=>"3.5-tobecome-3.4")

    remvertex!(amdg, 4)
    @test ismissing.(vertex_attr(amdg)) == [true, true, false, false]
    @test collect(skipmissing(vertex_attr(amdg))) == ["tria-stays","pente-becomes-tessera"]
    @test nv(amdg) == length(vertex_attr(amdg)) == 4
    @test edge_attr(amdg) == Dict{Tuple{Int,Int,Int}, String}((1,3,1) =>"1.3-stays", (3,4,1)=>"3.5-tobecome-3.4")
end
