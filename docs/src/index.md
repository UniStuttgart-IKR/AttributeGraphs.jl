# AttributeGraphs.jl

`AttributeGraphs.jl` is an effort to make a dead-simple, type-stable, flexible, customizable and compliant with [`Graphs.jl`](https://github.com/JuliaGraphs/Graphs.jl) container of a graph and its attributes.
It wraps an `AbstractGraph`, thus in theory it can play with all subtypes, and provides API for edge, vertices and graph attributes.
The type of attributes is parametric.

To access the attributes you can use `vertex_attr(), edge_attr(), graph_attr().

An opinionated `OAttributeGraph` API using `{add,rem,has,get}{graph,vertex,edge}attr[!]` is exported, but if not appreciated one can easily create his/her own version.
The opinionated implementation uses a Vector for the data attributes of each vertex and a Dict for the edge attributes, to approach the Graphs.jl paradigm as much as possible.
The Dict keys are updated after a vertex removal.

### Similar packages and differences
- [`MetaGraphs.jl`](https://github.com/JuliaGraphs/MetaGraphs.jl)
  - type-unstable
  - only implements `SimpleGraph` and `SimpleDiGraph`
- [`MetaGraphsNext.jl`](https://github.com/JuliaGraphs/MetaGraphsNext.jl)
  - user must define labels for every node
  - hardcoded properties types using Dictionaries
  - edge properties can only be identified by a tuple of vertices.
- [`MetaDataGraphs.jl`](https://github.com/gdalle/MetaDataGraphs.jl)
  - similar to MetaGraphsNext.jl but `graph[label]` should return the integer code and not the metadata (to make integration with Graphs.jl easier)

#### Proposal
Go to MetaGraphsNext.jl if:
- you need labels for every node
- the edge-data is associated only from the source and destination

Stay here if:
- If you do not want labels for the vertices, but instead a Graphs.jl feel.
- If you want to customize the way you handle your attribute data types.
- If you don't like carrying data around seperately from your graph
- If you like our opinionated approach

`AttributesGraphs.jl` is a simple and small project and might break often in favor of design improvements.
