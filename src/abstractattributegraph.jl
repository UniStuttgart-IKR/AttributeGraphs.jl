abstract type AbstractAttibuteGraph{T<:Integer, G<:AbstractGraph} <: AbstractGraph{T} end

function show(io::IO, ::MIME"text/plain", g::AbstractAttibuteGraph{T,G}) where {T<:Integer, G<:AbstractGraph}
    dir = is_directed(g) ? "directed" : "undirected"
    print(io, "{$(nv(g)), $(ne(g))} $dir attribute $T graph")
end

graph(mg::AbstractAttibuteGraph{T,G}) where {T<:Integer, G<:AbstractGraph} = getfield(mg, :graph)
vertex_attr(mg::AbstractAttibuteGraph{T,G}) where {T<:Integer, G<:AbstractGraph} = getfield(mg, :vertex_attr)
edge_attr(mg::AbstractAttibuteGraph{T,G}) where {T<:Integer, G<:AbstractGraph} = getfield(mg, :edge_attr)
graph_attr(mg::AbstractAttibuteGraph{T,G}) where {T<:Integer, G<:AbstractGraph} = getfield(mg, :graph_attr)
Base.getproperty(mg::AbstractAttibuteGraph{T,G}, f::Symbol) where {T<:Integer, G<:AbstractGraph} = Base.getproperty(graph(mg), f)

eltype(::AbstractAttibuteGraph{T,G}) where {T<:Integer, G<:AbstractGraph} = T
# forward all functions
edgetype(mg::AbstractAttibuteGraph{T,G}) where {T<:Integer, G<:AbstractGraph} = edgetype(graph(mg))

has_edge(mg::AbstractAttibuteGraph{T,G}, e::AbstractEdge) where {T<:Integer, G<:AbstractGraph} = has_edge(mg, src(e), dst(e))
has_edge(mg::AbstractAttibuteGraph, s::Integer, d::Integer) = has_edge(graph(mg), s,d)
has_edge(mg::AbstractAttibuteGraph, s::Integer, d::Integer, m::Integer) = has_edge(graph(mg), s,d, m)
add_edge!(mg::AbstractAttibuteGraph{T,G}, e::AbstractEdge) where {T<:Integer, G<:AbstractGraph} = add_edge!(mg, src(e), dst(e))
add_edge!(mg::AbstractAttibuteGraph{T,G}, s::T, d::T) where {T<:Integer, G<:AbstractGraph} = add_edge!(graph(mg), s, d)
rem_edge!(mg::AbstractAttibuteGraph{T,G}, e::AbstractEdge) where {T<:Integer, G<:AbstractGraph} = rem_edge!(graph(mg), src(e), dst(e))
rem_edge!(mg::AbstractAttibuteGraph{T,G}, s::T, d::T) where {T<:Integer, G<:AbstractGraph} = rem_edge!(graph(mg), s, d)
add_vertex!(mg::AbstractAttibuteGraph{T,G}) where {T<:Integer, G<:AbstractGraph} = add_vertex!(graph(mg))
rem_vertex!(mg::AbstractAttibuteGraph{T,G}, u::Integer) where {T<:Integer, G<:AbstractGraph} = rem_vertex!(graph(mg), u)
rem_vertices!(mg::AbstractAttibuteGraph{T,G}, args...) where {T<:Integer, G<:AbstractGraph} = rem_vertices!(graph(mg), args...)

inneighbors(mg::AbstractAttibuteGraph{T,G}, u::Integer) where {T<:Integer, G<:AbstractGraph} = unique(inneighbors(graph(mg), u))
outneighbors(mg::AbstractAttibuteGraph{T,G}, u::Integer) where {T<:Integer, G<:AbstractGraph} = unique(outneighbors(graph(mg), u))
neighbors(mg::AbstractAttibuteGraph{T,G}, u::Integer) where {T<:Integer, G<:AbstractGraph} = unique(neighbors(graph(mg), u))
all_neighbors(mg::AbstractAttibuteGraph{T,G}, u::Integer) where {T<:Integer, G<:AbstractGraph} = unique(all_neighbors(graph(mg), u))

is_directed(mg::AbstractAttibuteGraph{T,G}) where{T<:Integer, G<:AbstractGraph} = is_directed(graph(mg))
is_directed(::Type{<:AbstractAttibuteGraph{T,G}}) where{T<:Integer, G<:AbstractGraph} = is_directed(G)

nv(mg::AbstractAttibuteGraph) = nv(graph(mg))
ne(mg::AbstractAttibuteGraph) = ne(graph(mg))
edges(mg::AbstractAttibuteGraph) = edges(graph(mg))
vertices(mg::AbstractAttibuteGraph) = vertices(graph(mg))
has_vertex(mg::AbstractAttibuteGraph, u::Integer) = has_vertex(graph(mg), u)
weights(mg::AbstractAttibuteGraph) = weights(graph(mg))

