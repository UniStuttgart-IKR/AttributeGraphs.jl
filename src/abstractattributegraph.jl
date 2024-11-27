abstract type AbstractAttributeGraph{T<:Integer, G<:AbstractGraph} <: AbstractGraph{T} end

function show(io::IO, ::MIME"text/plain", g::AbstractAttributeGraph{T,G}) where {T<:Integer, G<:AbstractGraph}
    dir = is_directed(g) ? "directed" : "undirected"
    print(io, "{$(nv(g)), $(ne(g))} $dir attribute $T graph")
end

"$(TYPEDSIGNATURES) Get the wrapped graph"
getwgraph(mg::AbstractAttributeGraph{T,G}) where {T<:Integer, G<:AbstractGraph} = getfield(mg, :graph)
"$(TYPEDSIGNATURES) Get the data structure for all vertex attributes"
vertex_attr(mg::AbstractAttributeGraph{T,G}) where {T<:Integer, G<:AbstractGraph} = getfield(mg, :vertex_attr)
"$(TYPEDSIGNATURES) Get the data structure for all edge attributes"
edge_attr(mg::AbstractAttributeGraph{T,G}) where {T<:Integer, G<:AbstractGraph} = getfield(mg, :edge_attr)
"$(TYPEDSIGNATURES) Get the data structure for all graph attributes"
graph_attr(mg::AbstractAttributeGraph{T,G}) where {T<:Integer, G<:AbstractGraph} = getfield(mg, :graph_attr)
Base.getproperty(mg::AbstractAttributeGraph{T,G}, f::Symbol) where {T<:Integer, G<:AbstractGraph} = Base.getproperty(getwgraph(mg), f)

eltype(::AbstractAttributeGraph{T,G}) where {T<:Integer, G<:AbstractGraph} = T

#
#---------------------------------- forward functions to Graphs.jl ----------------------------------#
#

edgetype(mg::AbstractAttributeGraph{T,G}) where {T<:Integer, G<:AbstractGraph} = edgetype(getwgraph(mg))

has_edge(mg::AbstractAttributeGraph{T,G}, e::AbstractEdge) where {T<:Integer, G<:AbstractGraph} = has_edge(mg, src(e), dst(e))
has_edge(mg::AbstractAttributeGraph, s::Integer, d::Integer) = has_edge(getwgraph(mg), s,d)
has_edge(mg::AbstractAttributeGraph, s::Integer, d::Integer, m::Integer) = has_edge(getwgraph(mg), s,d, m)
add_edge!(mg::AbstractAttributeGraph{T,G}, e::AbstractEdge) where {T<:Integer, G<:AbstractGraph} = add_edge!(mg, src(e), dst(e))
add_edge!(mg::AbstractAttributeGraph{T,G}, s::T, d::T) where {T<:Integer, G<:AbstractGraph} = add_edge!(getwgraph(mg), s, d)
rem_edge!(mg::AbstractAttributeGraph{T,G}, e::AbstractEdge) where {T<:Integer, G<:AbstractGraph} = rem_edge!(getwgraph(mg), src(e), dst(e))
rem_edge!(mg::AbstractAttributeGraph{T,G}, s::T, d::T) where {T<:Integer, G<:AbstractGraph} = rem_edge!(getwgraph(mg), s, d)
add_vertex!(mg::AbstractAttributeGraph{T,G}) where {T<:Integer, G<:AbstractGraph} = add_vertex!(getwgraph(mg))
rem_vertex!(mg::AbstractAttributeGraph{T,G}, u::Integer) where {T<:Integer, G<:AbstractGraph} = rem_vertex!(getwgraph(mg), u)
rem_vertices!(mg::AbstractAttributeGraph{T,G}, args...) where {T<:Integer, G<:AbstractGraph} = rem_vertices!(getwgraph(mg), args...)

inneighbors(mg::AbstractAttributeGraph{T,G}, u::Integer) where {T<:Integer, G<:AbstractGraph} = unique(inneighbors(getwgraph(mg), u))
outneighbors(mg::AbstractAttributeGraph{T,G}, u::Integer) where {T<:Integer, G<:AbstractGraph} = unique(outneighbors(getwgraph(mg), u))
neighbors(mg::AbstractAttributeGraph{T,G}, u::Integer) where {T<:Integer, G<:AbstractGraph} = unique(neighbors(getwgraph(mg), u))
all_neighbors(mg::AbstractAttributeGraph{T,G}, u::Integer) where {T<:Integer, G<:AbstractGraph} = unique(all_neighbors(getwgraph(mg), u))

is_directed(mg::AbstractAttributeGraph{T,G}) where{T<:Integer, G<:AbstractGraph} = is_directed(getwgraph(mg))
is_directed(::Type{<:AbstractAttributeGraph{T,G}}) where{T<:Integer, G<:AbstractGraph} = is_directed(G)

adjacency_matrix(ag::AbstractAttributeGraph, args...) = adjacency_matrix(getwgraph(ag), args...)

nv(mg::AbstractAttributeGraph) = nv(getwgraph(mg))
ne(mg::AbstractAttributeGraph) = ne(getwgraph(mg))
edges(mg::AbstractAttributeGraph) = edges(getwgraph(mg))
vertices(mg::AbstractAttributeGraph) = vertices(getwgraph(mg))
has_vertex(mg::AbstractAttributeGraph, u::Integer) = has_vertex(getwgraph(mg), u)
weights(mg::AbstractAttributeGraph) = weights(getwgraph(mg))
