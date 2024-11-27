const OAttributeGraph{T,G,V,E,R} = AttributeGraph{T,G, Vector{Union{Missing,V}}, Dict{Tuple{T,T,T}, E}, R}

function OAttributeGraph(gr::AbstractGraph{T}; vertex_type::Type=Missing, edge_type::Type=Missing, graph_type::Type=Missing) where T<:Integer
    vertattrs = Vector{Union{Missing,vertex_type}}()
    edgeattrs = Dict{Tuple{T,T,T}, edge_type}()
    graphattr = graph_type()
    push!(vertattrs, fill(missing, nv(gr))...)
    AttributeGraph(gr, vertattrs, edgeattrs, graphattr)
end

OAttributeGraph(; vertex_type::Type=Missing, edge_type::Type=Missing, graph_type::Type=Missing) = OAttributeGraph(SimpleGraph(); vertex_type, edge_type, graph_type)

"$(TYPEDSIGNATURES) Add an edge in the graph and update attributes and keys/indices"
addedge!(ag::AttributeGraph, args...) = add_edge!(ag, args...)

"$(TYPEDSIGNATURES) Add a vertex in the graph and push a missing value to the attributes"
function addvertex!(ag::AttributeGraph{T,G,V,E,R}) where {T<:Integer,G<:AbstractGraph{T},V<:AbstractVector,E,R}
    res = add_vertex!(getwgraph(ag))
    res && push!(vertex_attr(ag), missing)
    res
end

"$(TYPEDSIGNATURES) Remove a vertex from the graph and update all attributes and keys/indices"
function remvertex!(ag::AttributeGraph{T,G,V,E,R}, u::T) where {T<:Integer,G<:AbstractGraph{T},V<:AbstractVector,E<:AbstractDict{<:Tuple{T,T,T}},R}
    # find influenced edges
    dictedgekeys = [key for key in keys(edge_attr(ag)) if key[1]==u || key[2]==u]
    map(dictedgekeys) do dk; delete!(edge_attr(ag), dk) end
    res = rem_vertex!(getwgraph(ag), u)
    res && deleteat!(vertex_attr(ag), u)
    updateedgeattr_after_vertex_removal!(ag, u)
    res
end

"$(TYPEDSIGNATURES) Remove an edge from the graph and update attributes and keys/indices"
function remedge!(ag::AttributeGraph{T,G,V,E,R}, s::T, d::T, m::T=1) where {T<:Integer,G<:AbstractGraph{T},V<:AbstractVector,E<:AbstractDict{<:Tuple{T,T,T}},R}
    # find influenced edges
    cedg = count(edges(ag)) do ed; s==src(ed) || d==src(ed) end 
    if m <= cedg
        rem_edge!(getwgraph(ag), s, d)
        remedgeattr!(ag, s, d, m)
        updateedgeattr_after_edge_removal!(ag, s, d, m)
    end
    nothing
end

#
#---------------------------------- graph attributes ----------------------------------#
#

"$(TYPEDSIGNATURES) Add a graph attribute"
function addgraphattr!(ag::AttributeGraph{T,G,V,E,R}, k::Kr, v::Vr) where {T<:Integer,G<:AbstractGraph{T},V,E, Kr, Vr, R<:AbstractDict{Kr, Vr}}
    graph_attr(ag)[k] = v
end

"$(TYPEDSIGNATURES) Remove a graph attribute"
function remgraphattr!(ag::AttributeGraph{T,G,V,E,R}, k::Kr) where {T<:Integer,G<:AbstractGraph{T},V,E, Kr, R<:AbstractDict{Kr}}
    delete!(graph_attr(ag),k)
end

"$(TYPEDSIGNATURES) Check if graph has this attribute"
function hasgraphattr(ag::AttributeGraph{T,G,V,E,R}, k::Kr) where {T<:Integer,G<:AbstractGraph{T},V,E, Kr, R<:AbstractDict{Kr}}
    haskey(graph_attr(ag), k)
end

"$(TYPEDSIGNATURES) Get graph attribute"
function getgraphattr(ag::AttributeGraph{T,G,V,E,R}, k::Kr) where {T<:Integer,G<:AbstractGraph{T},V,E, Kr, R<:AbstractDict{Kr}}
    graph_attr(ag)[k]
end

#
#---------------------------------- vertex attributes ----------------------------------#
#

"$(TYPEDSIGNATURES) Add vertex attribute"
function addvertexattr!(ag::AttributeGraph{T,G,V,E}, k::T, v::Vr) where {T<:Integer,G<:AbstractGraph{T},V,E, Vr}
    has_vertex(ag, k) ? (vertex_attr(ag)[k] = v) : nothing
end

"$(TYPEDSIGNATURES) Remove vertex attribute"
function remvertexattr!(ag::AttributeGraph{T,G,V,E}, k::T) where {T<:Integer,G<:AbstractGraph{T},V,E}
    has_vertex(ag, k) ? (vertex_attr(ag)[k] = missing) : nothing
end

"$(TYPEDSIGNATURES) Check if vertex has this attribute"
function hasvertexattr(ag::AttributeGraph{T,G,V,E}, k::T) where {T<:Integer,G<:AbstractGraph{T},V,E}
    length(vertex_attr(ag)) >= k && !ismissing(vertex_attr(ag)[k])
end

"$(TYPEDSIGNATURES) Get vertex attribute"
function getvertexattr(ag::AttributeGraph{T,G,V,E}, k::T) where {T<:Integer,G<:AbstractGraph{T},V,E}
    vertex_attr(ag)[k]
end

#
#---------------------------------- edge attributes ----------------------------------#
#

"$(TYPEDSIGNATURES)"
function _addedgeattr!(ag::AttributeGraph{T,G,V,E}, k::Kr, v::Vr) where {T<:Integer,G<:AbstractGraph{T},V,Kr,Vr,E<:AbstractDict{Kr, Vr}}
    edge_attr(ag)[k] = v
end
"$(TYPEDSIGNATURES) Add edge attribute `v` for edge defined by source `s` and destination `d`"
function addedgeattr!(ag::AttributeGraph{T,G,V,E}, s::T, d::T, v::Vr) where {T<:Integer,G<:AbstractGraph{T},V,Kr,Vr,E<:AbstractDict{Kr, Vr}}
    has_edge(ag, s, d) ? _addedgeattr!(ag, (s,d,1), v) : nothing
end
"$(TYPEDSIGNATURES) Add edge attribute `v` for edge defined by source `s`, destination `d` and multiplicity `m`."
function addedgeattr!(ag::AttributeGraph{T,G,V,E}, s::T, d::T, m::T, v::Vr) where {T<:Integer,G<:AbstractGraph{T},V,Kr,Vr,E<:AbstractDict{Kr, Vr}}
    has_edge(ag,s,d,m) ? _addedgeattr!(ag, (s,d,m), v) : nothing
end
"$(TYPEDSIGNATURES) Add edge attribute `v` for edge `e`"
function addedgeattr!(ag::AttributeGraph{T,G,V,E}, e::AbstractEdge, v::Vr) where {T<:Integer,G<:AbstractGraph{T},V,Kr,Vr,E<:AbstractDict{Kr, Vr}}
    addedgeattr!(ag, src(e), dst(e), v)
end
"$(TYPEDSIGNATURES) Add edge attribute `v` for edge `e` and multiplicity `m`."
function addedgeattr!(ag::AttributeGraph{T,G,V,E}, e::AbstractEdge, m::T, v::Vr) where {T<:Integer,G<:AbstractGraph{T},V,Kr,Vr,E<:AbstractDict{Kr, Vr}}
    addedgeattr!(ag, src(e), dst(e), m, v)
end

"$(TYPEDSIGNATURES)"
function _remedgeattr!(ag::AttributeGraph{T,G,V,E}, k::Kr) where {T<:Integer,G<:AbstractGraph{T},V,Kr,E<:AbstractDict{Kr}}
    delete!(edge_attr(ag),k)
end
"$(TYPEDSIGNATURES) Remove edge attribute for edge defined by source `s` and destination `d`"
function remedgeattr!(ag::AttributeGraph{T,G,V,E}, s::T, d::T) where {T<:Integer,G<:AbstractGraph{T},V,Kr,E<:AbstractDict{Kr}}
    _remedgeattr!(ag, (s,d,1))
end
"$(TYPEDSIGNATURES) Remove edge attribute for edge defined by source `s`, destination `d` and multiplicity `m`."
function remedgeattr!(ag::AttributeGraph{T,G,V,E}, s::T, d::T, m::T) where {T<:Integer,G<:AbstractGraph{T},V,Kr,E<:AbstractDict{Kr}}
    _remedgeattr!(ag, (s,d,m))
end
"$(TYPEDSIGNATURES) Remove edge attribute for edge `e`"
function remedgeattr!(ag::AttributeGraph{T,G,V,E}, e::AbstractEdge) where {T<:Integer,G<:AbstractGraph{T},V,Kr,E<:AbstractDict{Kr}}
    _remedgeattr!(ag, (src(e),dst(e),1))
end
"$(TYPEDSIGNATURES) Remove edge attribute for edge `e` and multiplicity `m`"
function remedgeattr!(ag::AttributeGraph{T,G,V,E}, e::AbstractEdge, m::T) where {T<:Integer,G<:AbstractGraph{T},V,Kr,E<:AbstractDict{Kr}}
    _remedgeattr!(ag, (src(e),dst(e),m))
end

"$(TYPEDSIGNATURES) Get edge attribute for edge defined by source `s` and destination `d`"
getedgeattr(ag::AttributeGraph{T,G,V,E}, s::T, d::T) where {T<:Integer,G<:AbstractGraph{T},V,Kr,E<:AbstractDict{Kr}} = edge_attr(ag)[s,d,1]
"$(TYPEDSIGNATURES) Get edge attribute for edge defined by source `s` and destination `d` and multiplicity `m`"
getedgeattr(ag::AttributeGraph{T,G,V,E}, s::T, d::T, m::T) where {T<:Integer,G<:AbstractGraph{T},V,Kr,E<:AbstractDict{Kr}} = edge_attr(ag)[s,d,m]
"$(TYPEDSIGNATURES) Get edge attribute for edge defined by `e`"
getedgeattr(ag::AttributeGraph{T,G,V,E}, e::AbstractEdge) where {T<:Integer,G<:AbstractGraph{T},V,E<:AbstractDict} = getedgeattr(ag, src(e), dst(e))
"$(TYPEDSIGNATURES) Get edge attribute for edge defined edge `e` with multiplicity `m`"
getedgeattr(ag::AttributeGraph{T,G,V,E}, e::AbstractEdge, m::T) where {T<:Integer,G<:AbstractGraph{T},V,E<:AbstractDict} = getedgeattr(ag, src(e), dst(e), m)

"$(TYPEDSIGNATURES) Check if edge has attribute for edge defined by the arguments `args` given as a tuple"
hasedgeattr(ag::AttributeGraph{T,G,V,E}, args::T...) where {T<:Integer,G<:AbstractGraph{T},V,Kr,E<:AbstractDict{Kr}} = haskey(edge_attr(ag), args)
"$(TYPEDSIGNATURES) Check if edge has attribute for edge defined by the tuple `ktup`"
hasedgeattr(ag::AttributeGraph{T,G,V,E}, ktup::Tuple) where {T<:Integer,G<:AbstractGraph{T},V,Kr,E<:AbstractDict{Kr}} = haskey(edge_attr(ag), ktup)
"$(TYPEDSIGNATURES) Check if edge has attribute for edge `e`"
hasedgeattr(ag::AttributeGraph{T,G,V,E}, e::AbstractEdge) where {T<:Integer,G<:AbstractGraph{T},V,E<:AbstractDict} = hasedgeattr(ag, src(e), dst(e), 1)
"$(TYPEDSIGNATURES) Check if edge has attribute for edge `e` and multiplicity `m`"
hasedgeattr(ag::AttributeGraph{T,G,V,E}, e::AbstractEdge, m::T) where {T<:Integer,G<:AbstractGraph{T},V,E<:AbstractDict} = hasedgeattr(ag, src(e), dst(e), m)

#
#---------------------------------- helpful functions ----------------------------------#
#

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
