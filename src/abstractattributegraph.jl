abstract type AbstractAttibuteGraph{T<:Integer, G<:AbstractGraph} <: AbstractGraph{T} end

function show(io::IO, ::MIME"text/plain", g::AbstractAttibuteGraph{T,G}) where {T<:Integer, G<:AbstractGraph}
    dir = is_directed(g) ? "directed" : "undirected"
    print(io, "{$(nv(g)), $(ne(g))} $dir attribute $T graph")
end

"$(TYPEDSIGNATURES) Get the wrapped graph"
getgraph(mg::AbstractAttibuteGraph{T,G}) where {T<:Integer, G<:AbstractGraph} = getfield(mg, :graph)
"$(TYPEDSIGNATURES) Get the data structure for all vertex attributes"
vertex_attr(mg::AbstractAttibuteGraph{T,G}) where {T<:Integer, G<:AbstractGraph} = getfield(mg, :vertex_attr)
"$(TYPEDSIGNATURES) Get the data structure for all edge attributes"
edge_attr(mg::AbstractAttibuteGraph{T,G}) where {T<:Integer, G<:AbstractGraph} = getfield(mg, :edge_attr)
"$(TYPEDSIGNATURES) Get the data structure for all graph attributes"
graph_attr(mg::AbstractAttibuteGraph{T,G}) where {T<:Integer, G<:AbstractGraph} = getfield(mg, :graph_attr)
Base.getproperty(mg::AbstractAttibuteGraph{T,G}, f::Symbol) where {T<:Integer, G<:AbstractGraph} = Base.getproperty(getgraph(mg), f)

eltype(::AbstractAttibuteGraph{T,G}) where {T<:Integer, G<:AbstractGraph} = T

#
#---------------------------------- forward functions to Graphs.jl ----------------------------------#
#

edgetype(mg::AbstractAttibuteGraph{T,G}) where {T<:Integer, G<:AbstractGraph} = edgetype(getgraph(mg))

has_edge(mg::AbstractAttibuteGraph{T,G}, e::AbstractEdge) where {T<:Integer, G<:AbstractGraph} = has_edge(mg, src(e), dst(e))
has_edge(mg::AbstractAttibuteGraph, s::Integer, d::Integer) = has_edge(getgraph(mg), s,d)
has_edge(mg::AbstractAttibuteGraph, s::Integer, d::Integer, m::Integer) = has_edge(getgraph(mg), s,d, m)
add_edge!(mg::AbstractAttibuteGraph{T,G}, e::AbstractEdge) where {T<:Integer, G<:AbstractGraph} = add_edge!(mg, src(e), dst(e))
add_edge!(mg::AbstractAttibuteGraph{T,G}, s::T, d::T) where {T<:Integer, G<:AbstractGraph} = add_edge!(getgraph(mg), s, d)
rem_edge!(mg::AbstractAttibuteGraph{T,G}, e::AbstractEdge) where {T<:Integer, G<:AbstractGraph} = rem_edge!(getgraph(mg), src(e), dst(e))
rem_edge!(mg::AbstractAttibuteGraph{T,G}, s::T, d::T) where {T<:Integer, G<:AbstractGraph} = rem_edge!(getgraph(mg), s, d)
add_vertex!(mg::AbstractAttibuteGraph{T,G}) where {T<:Integer, G<:AbstractGraph} = add_vertex!(getgraph(mg))
rem_vertex!(mg::AbstractAttibuteGraph{T,G}, u::Integer) where {T<:Integer, G<:AbstractGraph} = rem_vertex!(getgraph(mg), u)
rem_vertices!(mg::AbstractAttibuteGraph{T,G}, args...) where {T<:Integer, G<:AbstractGraph} = rem_vertices!(getgraph(mg), args...)

inneighbors(mg::AbstractAttibuteGraph{T,G}, u::Integer) where {T<:Integer, G<:AbstractGraph} = unique(inneighbors(getgraph(mg), u))
outneighbors(mg::AbstractAttibuteGraph{T,G}, u::Integer) where {T<:Integer, G<:AbstractGraph} = unique(outneighbors(getgraph(mg), u))
neighbors(mg::AbstractAttibuteGraph{T,G}, u::Integer) where {T<:Integer, G<:AbstractGraph} = unique(neighbors(getgraph(mg), u))
all_neighbors(mg::AbstractAttibuteGraph{T,G}, u::Integer) where {T<:Integer, G<:AbstractGraph} = unique(all_neighbors(getgraph(mg), u))

is_directed(mg::AbstractAttibuteGraph{T,G}) where{T<:Integer, G<:AbstractGraph} = is_directed(getgraph(mg))
is_directed(::Type{<:AbstractAttibuteGraph{T,G}}) where{T<:Integer, G<:AbstractGraph} = is_directed(G)

adjacency_matrix(ag::AbstractAttibuteGraph, args...) = adjacency_matrix(getgraph(ag), args...)

nv(mg::AbstractAttibuteGraph) = nv(getgraph(mg))
ne(mg::AbstractAttibuteGraph) = ne(getgraph(mg))
edges(mg::AbstractAttibuteGraph) = edges(getgraph(mg))
vertices(mg::AbstractAttibuteGraph) = vertices(getgraph(mg))
has_vertex(mg::AbstractAttibuteGraph, u::Integer) = has_vertex(getgraph(mg), u)
weights(mg::AbstractAttibuteGraph) = weights(getgraph(mg))
