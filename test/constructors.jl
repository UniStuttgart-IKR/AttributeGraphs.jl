@testset "constructors" begin
    @test try; AttributeGraph(); true; catch e; false; end;
    @test try; typeof(AttributeGraph())(); true; catch e; false; end;
    @test try; AttributeGraph(SimpleGraph()); true; catch e; false; end;
    @test try; AttributeGraph(SimpleGraph(10)); true; catch e; false; end;

    @test try; OAttributeGraph(); true; catch e; false; end;
    @test try; typeof(OAttributeGraph())(); true; catch e; false; end;
    @test try; OAttributeGraph(SimpleGraph()); true; catch e; false; end;
    @test try; OAttributeGraph(SimpleGraph(10)); true; catch e; false; end;
    @test try; OAttributeGraph(;vertex_type=String); true; catch e; false; end;
end
