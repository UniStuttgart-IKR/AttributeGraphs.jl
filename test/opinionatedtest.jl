@testset "opinionatedtest" begin

    # unit testing 
    #simple test case
    @test true
    #@test false


    #OAttributeGraph test cases

    oag = OAttributeGraph(;vertex_type=String, edge_type=String, graph_type=Dict{Symbol, String})
    
    @test all([addvertex!(oag) for _ in 1:4 ])
    @test nv(oag) == 4

    remvertex!(oag, 4)

    #check if object has vertex and verify the size
    @test has_vertex(oag, 2)
    @test length(vertex_attr(oag)) == 3
    

    #adding edges, vertex_attributes and edge_attributes

    addedge!(oag, 1, 3)
    addedge!(oag, 2, 1)
    addedge!(oag, 2, 3)

    #add vertex attribute
    addvertexattr!(oag, 2, "second node")
    addvertexattr!(oag, 3, "third node")
    @test ismissing.(vertex_attr(oag)) == [true, false, false]

    #check if there is edge between source and destination
    @test has_edge(oag, 2, 1)
    
    #add edge attribute
    addedgeattr!(oag, 1, 3, "1-3 edge" )
    addedgeattr!(oag, 2, 1 , "2-1 edge" )

   

    #tests on core assignment

    @test getvertexattr(oag, 1) ===  missing
    @test getvertexattr(oag, 2) === "second node"
    @test length(vertex_attr(oag)) == 3
    
    
end

  






