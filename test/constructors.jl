@testset "constructors" begin
    @test try; AttributeGraph(); true; catch e; false; end;
    @test try; typeof(AttributeGraph())(); true; catch e; false; end;
    @test try; AttributeGraph(0); true; catch e; false; end;
    @test try; AttributeGraph(SimpleGraph()); true; catch e; false; end;
    @test try; AttributeGraph(SimpleGraph(10)); true; catch e; false; end;
    @test try; AttributeGraph(;vvertex_type=String); true; catch e; false; end;
end
