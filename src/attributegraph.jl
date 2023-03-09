"""
$(TYPEDEF)
$(TYPEDFIELDS)

If the type for the vertices attributes and the edges attributes is a `AbstractVector` then there is a default behavior.
"""
struct AttributeGraph{T<:Integer,G<:AbstractGraph{T},V,E,R} <: AbstractAttibuteGraph{T,G}
    "the wrapped graph"
    graph::G
    "the attributes for the vertices"
    vertex_attr::V
    "the attributes for the edges"
    edge_attr::E
    "the attributes for the graph"
    graph_attr::R
end

Base.zero(ag::AttributeGraph{T,G,V,E,R}) where {T<:Integer, G<:AbstractGraph, V, E, R} = AttributeGraph{T,G,V,E,R}()
AttributeGraph{T,G,V,E,R}() where {T<:Integer, G<:AbstractGraph{T}, V, E, R} = AttributeGraph(G(), V(), E(), R())
AttributeGraph(i::Integer) = AttributeGraph(SimpleGraph(i))

"""
$(TYPEDSIGNATURES)

Construct an vector-based `AttributeGraph`.
This means that the attributes instances will be vectors corresponding to the `edges()` and `vertices()` iterators.

### Keywords
- `vertex_attr_type`: The element type for the vertex attributes vector
- `edge_attr_type`: The element type for the edge attributes Dict. The tuples are the edge details `src`, `dst` and `mult` for edge multiplicity.
Edge multiplicity is always `1` if not interested to this.
- `graph_attr_type`: The element type for the graph attributes. It needs to be able to call an empty constructor with this.
"""
function AttributeGraph(gr::AbstractGraph{T}; vvertex_type::Type=Missing, edge_type::Type=Missing, graph_type::Type=Missing) where T<:Integer
    vertattrs = Vector{Union{Missing, vvertex_type}}()
    edgeattrs = Dict{Tuple{T,T,T}, edge_type}()
    graphattr = graph_type()
    AttributeGraph(gr, vertattrs, edgeattrs, graphattr)
end

AttributeGraph(; vvertex_type::Type=Missing, edge_type::Type=Missing, graph_type::Type=Missing) = AttributeGraph(SimpleGraph(); vvertex_type, edge_type, graph_type)

AttributeGraph{T}(g::G, va::V, ea::E, ga::R) where {T,V,E,R,G} = AttributeGraph{T,G,V,E,R}(g,va,ea,ga)
