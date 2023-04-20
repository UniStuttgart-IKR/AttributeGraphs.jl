# Usage

Following a walkthrough of the package and the features.
An [`AttributeGraph`](@ref) is quite straightforwardingly defined by 4 fields:
- the underlying wrapped graph
- the vertex attribute data structure
- the edge attribute data structure
- the graph attribute data structure

That is because we tried to manufacture the least speculative way to define a such.
As this might not be able to do some easy out-of-the-box operations we also proposed a more [Opinionated approach](@ref)

## Opinionated approach

The default operation of `OAttributeGraphs` is an opinionated one.
By calling `OAttributeGraph()`, you are already within the realm of our preferences.

```jldoctest walkthrough
julia> using AttributeGraphs, Graphs

julia> OAttributeGraph() |> typeof
AttributeGraph{Int64, SimpleGraph{Int64}, Vector{Missing}, Dict{Tuple{Int64, Int64, Int64}, Missing}, Missing}
```

This approach treats graph data as following:
- The vertex attributes data structure is a vector. 
The index of the vector corresponds to the index of the vertex.
This way we want to be closer to the Graphs.jl implementation.
- The edge attributes data structure is a `Dict{Tuple{Int, Int, Int}}`.
Non surpisingly, each edge attribute is indexed by the source and destination node.
The third integer is the multiplicity for MultiGraphs and if non given, `1` is assumed.
- The graph attributes data structure is non existent. The user type is directly what it is.
However some functionality is provided from {add,rem,has,get}graphattr[!] for `AbstractDict`.
For trivial situation you should directly use [`graph_attr`](@ref).

Following we define a `AttributeGraph` with vertex and edge attributes of `String` and graph attributes of `Dict{Symbol, String}`
```jldoctest walkthrough
julia> oag = OAttributeGraph(;vertex_type=String, edge_type=String, graph_type=Dict{Symbol, String})
{0, 0} undirected attribute Int64 graph

```

You will not be surpised to see that probably all of the obvious operations are supported.

For example starting with the graph attributes
```jldoctest walkthrough
julia> addgraphattr!(oag, :ena, "ena")
"ena"

julia> addgraphattr!(oag, :dio, "dio")
"dio"

julia> graph_attr(oag)
Dict{Symbol, String} with 2 entries:
  :ena => "ena"
  :dio => "dio"
```

Now let's add some vertices and edges.
Note we use the [`addvertex!`](@ref), [`addedge!`](@ref) and friends instead of `add_vertex!`, `add_edge!` and friends to be 100% consistent.
The second ones will also work, but you sooner or later you will reach a corrupted state.
```jldoctest walkthrough
julia> foreach(_ -> addvertex!(oag), 1:10) # add 10 nodes

julia> foreach(x -> addedge!(oag,x[1],x[2]), [(1,2), (1,3), (3,4), (1,5), (7,8)]) # add some edges
```

`addvertex!` immeadiately adds `missing` to the vertex attribute:
```jldoctest walkthrough
julia> vertex_attr(oag)
10-element Vector{Union{Missing, String}}:
 missing
 missing
 missing
 missing
 missing
 missing
 missing
 missing
 missing
 missing
```

```jldoctest walkthrough
julia> addvertexattr!(oag, 4, "customattr4")
"customattr4"

julia> vertex_attr(oag)
10-element Vector{Union{Missing, String}}:
 missing
 missing
 missing
 "customattr4"
 missing
 missing
 missing
 missing
 missing
 missing
```

Similar for edge attributes:
```jldoctest walkthrough
julia> addedgeattr!(oag, 1, 2, "data_for_1-2")
"data_for_1-2"

julia> addedgeattr!(oag, 3, 4, "data_for_3-4")
"data_for_3-4"

julia> edge_attr(oag)
Dict{Tuple{Int64, Int64, Int64}, String} with 2 entries:
  (1, 2, 1) => "data_for_1-2"
  (3, 4, 1) => "data_for_3-4"
```

Deleting a node will automatically update the indices and attributes
```jldoctest walkthrough
julia> remvertex!(oag, 2)
true

julia> edge_attr(oag)
Dict{Tuple{Int64, Int64, Int64}, String} with 1 entry:
  (2, 3, 1) => "data_for_3-4"
```

## General approach

Basically, `AttributeGraph` is a parametric type that can be anything.
So you can customize it to do whatever you want.
You might say that the lack of features is the basic feature here.

The basic use case for this is that you might often have some data `data` accompanying your graph `graph`.
You don't want to always pass around a tuple of `(graph, data)`.
Instead, you can simply use this package to load `data` in a `AttributeGraph` and pass it around more compactly.

An outrageous example follows

```jldoctest walkthrough 
julia> using DataStructures, Random, Test

julia> Random.seed!(0); # for reproducibility

julia> gag = AttributeGraph(SimpleGraph(), (v) -> v+randn(), DefaultDict{Tuple{Int, Int, String},Float64}(10.0), missing)
{0, 0} undirected attribute Int64 graph
```

Here the vertex attributes are given by a normally distributed random function with mean the vertex index.
The edge attributes are a default dictionary indexed by a tuple `{Int, Int, String}`
The graph attributes are non-existant so we pass in `missing`.

The following function will return our initializations
```jldoctest walkthrough 
julia> vertex_attr(gag); # returns a function

julia> edge_attr(gag)
DataStructures.DefaultDict{Tuple{Int64, Int64, String}, Float64, Float64}()

julia> graph_attr(gag)
missing
```

We can continue on constructing our graph
```jldoctest walkthrough 
julia> add_vertices!(gag, 10)
10

julia> foreach(v -> add_edge!(gag, v, v+1), 1:nv(gag))

julia> gag 
{10, 9} undirected attribute Int64 graph
```

You can query right away the vertex stochastic attributes
```jldoctest walkthrough 
julia> [vertex_attr(gag)(v) for v in vertices(gag)]
10-element Vector{Float64}:
 1.9429705334461191
 2.1339227576531843
 4.5250689085124804
 4.123901231205597
 3.794227715740064
 6.311817175360248
 6.76535873503874
 6.912647706289468
 9.462310680431376
 9.919406913366794
```

I hear you saying: "But I can even do `vertex_attr(gag)(1235)`" and it will still return a value even though the vertex doesn't exist.
True.
You can move on to customize your approach if you want that to fail.
Eg:
```jldoctest walkthrough 
julia> myvertexattr(ag::AttributeGraph, x) = has_vertex(ag, x) ? vertex_attr(gag)(x) : error("no attribute")
myvertexattr (generic function with 1 method)
julia> myvertexattr(gag, 4)
3.187569312095576

julia> @test_throws Exception myvertexattr(gag, 123) # now it throws an error
Test Passed
      Thrown: ErrorException
```

Similarly you will need to manually fill up the attributes for the graph edge, e.g.:
```jldoctest walkthrough 
julia> let e = first(edges(gag))
           edge_attr(gag)[src(e), dst(e), "class1"] = 100
           edge_attr(gag)[src(e), dst(e), "class2"] = 200
       end;

julia> edge_attr(gag)
DefaultDict{Tuple{Int64, Int64, String}, Float64, Float64} with 2 entries:
  (1, 2, "class1") => 100.0
  (1, 2, "class2") => 200.0
```

Since we decided to use a `DefaultDict` though you can still query other edges

```jldoctest walkthrough 
julia> edge_attr(gag)[1, 4, ""]
10.0
```

The general approach is mostly useful for customizable or quick and dirty situations.
