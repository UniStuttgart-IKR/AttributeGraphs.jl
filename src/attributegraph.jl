"""
$(TYPEDEF)
$(TYPEDFIELDS)

If the type for the vertices attributes and the edges attributes is a `AbstractVector` then there is a default behavior.
"""
struct AttributeGraph{T<:Integer,G<:AbstractGraph{T},V,E,R} <: AbstractAttributeGraph{T,G}
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

function Base.copy(ag::AttributeGraph)
    return AttributeGraph(
        Base.copy(getfield(ag, :graph)),
        isimmutable(getfield(ag, :vertex_attr)) ? getfield(ag, :vertex_attr) : Base.copy(getfield(ag, :vertex_attr)),
        isimmutable(getfield(ag, :edge_attr)) ? getfield(ag, :edge_attr) : Base.copy(getfield(ag, :edge_attr)),
        isimmutable(getfield(ag, :graph_attr)) ? getfield(ag, :graph_attr) : Base.copy(getfield(ag, :graph_attr)),
    )
end

function Base.deepcopy(ag::AttributeGraph)
    return AttributeGraph(
        Base.deepcopy(getfield(ag, :graph)),
        Base.deepcopy(getfield(ag, :vertex_attr)),
        Base.deepcopy(getfield(ag, :edge_attr)),
        Base.deepcopy(getfield(ag, :graph_attr)),
    )
end

"""
$(TYPEDSIGNATURES)

Construct a `AttributeGraph`.

### Keywords
- `vertex_attr_type`: The element type for the vertex attributes
- `edge_attr_type`: The element type for the edge attributes
- `graph_attr_type`: The element type for the graph attributes

All types need to be able to call an empty constructor.
"""
function AttributeGraph(gr::AbstractGraph{T}; vertex_type::Type=Missing, edge_type::Type=Missing, graph_type::Type=Missing) where T<:Integer
    vertattrs = vertex_type()
    edgeattrs = edge_type()
    graphattr = graph_type()
    AttributeGraph(gr, vertattrs, edgeattrs, graphattr)
end

AttributeGraph(; vertex_type::Type=Missing, edge_type::Type=Missing, graph_type::Type=Missing) = AttributeGraph(SimpleGraph(); vertex_type, edge_type, graph_type)

AttributeGraph{T}(g::G, va::V, ea::E, ga::R) where {T,V,E,R,G} = AttributeGraph{T,G,V,E,R}(g,va,ea,ga)
