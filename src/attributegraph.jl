"""
$(TYPEDEF)

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

addedge!(ag::AttributeGraph, args...) = add_edge!(ag, args...)

function addvertex!(ag::AttributeGraph{T,G,V,E,R}) where {T<:Integer,G<:AbstractGraph{T},V<:AbstractVector,E,R}
    res = add_vertex!(graph(ag))
    res && push!(vertex_attr(ag), missing)
    res
end

function remvertex!(ag::AttributeGraph{T,G,V,E,R}, u::T) where {T<:Integer,G<:AbstractGraph{T},V<:AbstractVector,E<:AbstractDict{<:Tuple{T,T,T}},R}
    # find influenced edges
    dictedgekeys = [key for key in keys(edge_attr(ag)) if key[1]==u || key[2]==u]
    map(dictedgekeys) do dk; delete!(edge_attr(ag), dk) end
    res = rem_vertex!(graph(ag), u)
    res && deleteat!(vertex_attr(ag), u)
    updateedgeattr_after_vertex_removal!(ag, u)
    res
end

function remedge!(ag::AttributeGraph{T,G,V,E,R}, s::T, d::T, m::T=1) where {T<:Integer,G<:AbstractGraph{T},V<:AbstractVector,E<:AbstractDict{<:Tuple{T,T,T}},R}
    # find influenced edges
    cedg = count(edges(ag)) do ed; s==src(ed) || d==src(ed) end 
    if m <= cedg
        rem_edge!(graph(ag), s, d)
        remedgeattr!(ag, s, d, m)
        updateedgeattr_after_edge_removal!(ag, s, d, m)
    end
    nothing
end

addgraphattr!(ag::AttributeGraph{T,G,V,E,R}, k::Kr, v::Vr) where {T<:Integer,G<:AbstractGraph{T},V,E, Kr, Vr, R<:AbstractDict{Kr, Vr}} = (graph_attr(ag)[k] = v)
remgraphattr!(ag::AttributeGraph{T,G,V,E,R}, k::Kr) where {T<:Integer,G<:AbstractGraph{T},V,E, Kr, R<:AbstractDict{Kr}} = delete!(graph_attr(ag),k)

addvertexattr!(ag::AttributeGraph{T,G,V,E}, k::T, v::Vr) where {T<:Integer,G<:AbstractGraph{T},V,E, Vr} = has_vertex(ag, k) ? (vertex_attr(ag)[k] = v) : nothing
remvertexattr!(ag::AttributeGraph{T,G,V,E}, k::T) where {T<:Integer,G<:AbstractGraph{T},V,E} = has_vertex(ag, k) ? (vertex_attr(ag)[k] = missing) : nothing

_addedgeattr!(ag::AttributeGraph{T,G,V,E}, k::Kr, v::Vr) where {T<:Integer,G<:AbstractGraph{T},V,Kr,Vr,E<:AbstractDict{Kr, Vr}} = edge_attr(ag)[k] = v
_remedgeattr!(ag::AttributeGraph{T,G,V,E}, k::Kr) where {T<:Integer,G<:AbstractGraph{T},V,Kr,E<:AbstractDict{Kr}} = delete!(edge_attr(ag),k)
addedgeattr!(ag::AttributeGraph{T,G,V,E}, s::T, d::T, v::Vr) where {T<:Integer,G<:AbstractGraph{T},V,Kr,Vr,E<:AbstractDict{Kr, Vr}} = has_edge(ag, s, d) ? _addedgeattr!(ag, (s,d,1), v) : nothing
addedgeattr!(ag::AttributeGraph{T,G,V,E}, s::T, d::T, m::T, v::Vr) where {T<:Integer,G<:AbstractGraph{T},V,Kr,Vr,E<:AbstractDict{Kr, Vr}} = has_edge(ag,s,d,m) ? _addedgeattr!(ag, (s,d,m), v) : nothing
addedgeattr!(ag::AttributeGraph{T,G,V,E}, e::AbstractEdge, v::Vr) where {T<:Integer,G<:AbstractGraph{T},V,Kr,Vr,E<:AbstractDict{Kr, Vr}} = addedgeattr!(ag, src(e), dst(e), v)
addedgeattr!(ag::AttributeGraph{T,G,V,E}, e::AbstractEdge, m::T, v::Vr) where {T<:Integer,G<:AbstractGraph{T},V,Kr,Vr,E<:AbstractDict{Kr, Vr}} = addedgeattr!(ag, src(e), dst(e), m, v)
remedgeattr!(ag::AttributeGraph{T,G,V,E}, s::T, d::T) where {T<:Integer,G<:AbstractGraph{T},V,Kr,E<:AbstractDict{Kr}} = _remedgeattr!(ag, (s,d,1))
remedgeattr!(ag::AttributeGraph{T,G,V,E}, s::T, d::T, m::T) where {T<:Integer,G<:AbstractGraph{T},V,Kr,E<:AbstractDict{Kr}} = _remedgeattr!(ag, (s,d,m))
remedgeattr!(ag::AttributeGraph{T,G,V,E}, e::AbstractEdge) where {T<:Integer,G<:AbstractGraph{T},V,Kr,E<:AbstractDict{Kr}} = _remedgeattr!(ag, (src(e),dst(e),1))


function updateedgeattr_after_vertex_removal!(ag::AttributeGraph{T,G,V,E}, u::T) where {T<:Integer, G<:AbstractGraph{T}, V, E<:AbstractDict{<:Tuple{T,T,T}}}
    movedownone(x, u) = x > u ? x-1 : x
    movedownonemany(v, u) = (movedownone.(v[1:2], u)..., v[3])

    keystochange = [(s,t,m) for (s,t,m) in keys(edge_attr(ag)) if s > u || t > u]
    holdvalues = getindex.([edge_attr(ag)], keystochange)
    newkeys = movedownonemany.(keystochange, u)

    foreach(keystochange) do k; delete!(edge_attr(ag), k); end
    foreach(zip(newkeys, holdvalues)) do (k,v); edge_attr(ag)[k]= v; end
end
function updateedgeattr_after_edge_removal!(ag::AttributeGraph{T,G,V,E}, s::T, d::T, m::T) where {T<:Integer, G<:AbstractGraph{T}, V, E<:AbstractDict{<:Tuple{T,T,T}}}
    movedownonemany(v) = (v[1:2]..., v[3]-1)

    keystochange = [(v1,v2,mu) for (v1,v2,mu) in keys(edge_attr(ag)) if s == v1 && d == v2 && mu>m]
    holdvalues = getindex.([edge_attr(ag)], keystochange)
    newkeys = movedownonemany.(keystochange)

    keystochange, holdvalues, newkeys

    foreach(keystochange) do k; delete!(edge_attr(ag), k); end
    foreach(zip(newkeys, holdvalues)) do (k,v); edge_attr(ag)[k]= v; end
end
