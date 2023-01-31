module AttributeGraphs

using DocStringExtensions

using Graphs
import Graphs: eltype, edgetype, vertices, ne, has_edge, add_vertex!, add_vertices!, add_edge!, rem_edge!, is_directed, all_neighbors, inneighbors, outneighbors, neighbors, rem_vertex!, rem_vertices!, nv, ne, edges, vertices, has_edge, has_vertex, weights
import Graphs.SimpleGraphs: AbstractSimpleGraph, SimpleGraphEdge, SimpleDiGraphEdge, badj, adj

import Base: show, eltype

export AttributeGraph, graph, vertex_attr, edge_attr, graph_attr, addgraphattr!, remgraphattr!, addedgeattr!, remedgeattr!, addvertexattr!, remvertexattr!, addvertex!, remvertex!, addedge!, remedge!

include("abstractattributegraph.jl")
include("attributegraph.jl")

end
