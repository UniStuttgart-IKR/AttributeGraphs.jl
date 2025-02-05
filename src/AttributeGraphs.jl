module AttributeGraphs

using DocStringExtensions

using Graphs
import Graphs: eltype, edgetype, vertices, ne, has_edge, add_vertex!, add_vertices!, add_edge!, rem_edge!, is_directed, all_neighbors, inneighbors, outneighbors, neighbors, rem_vertex!, rem_vertices!, nv, ne, edges, vertices, has_edge, has_vertex, weights, adjacency_matrix
import Graphs.SimpleGraphs: AbstractSimpleGraph, SimpleGraphEdge, SimpleDiGraphEdge, badj, adj

import Base: show, eltype

export AttributeGraph, OAttributeGraph, getwgraph, vertex_attr, edge_attr, graph_attr 

# opinionated API
export addgraphattr!, remgraphattr!, addedgeattr!, remedgeattr!, addvertexattr!, remvertexattr!, addvertex!, remvertex!, addedge!, remedge!, hasvertexattr, hasedgeattr, hasgraphattr, getvertexattr, getedgeattr, getgraphattr, OAttributeGraph

include("abstractattributegraph.jl")
include("attributegraph.jl")
include("opinionated.jl")

end
