# AttributeGraphs.jl

[![](https://img.shields.io/badge/docs-dev-blue.svg)](https://UniStuttgart-IKR.github.io/AttributeGraphs.jl/dev)
[![codecov.io](http://codecov.io/github/UniStuttgart-IKR/AttributeGraphs.jl/coverage.svg?branch=main)](http://codecov.io/github/UniStuttgart-IKR/AttributeGraphs.jl?branch=main)

`AttributeGraphs.jl` is an effort to make a dead-simple, type-stable, flexible, compliant with [`Graphs.jl`](https://github.com/JuliaGraphs/Graphs.jl) container of a graph and its attributes.
It wraps an `AbstractGraph`, thus in theory it can play with all subtypes, and provides API for edge, vertices and graph properties.
The type of properties is parametric and fully flexible.

To access the properties you can use `vertex_attr(), edge_attr(), graph_attr()`.

An opinionated API using `addvertex!, remvertex!, addedge!, remedge!` is exported, but if not appreciated one can directly use the `add_vertex!, rem_vertex!, add_edge!, rem_edge!` functions or easily create his/her own.
The opinionated implementation uses a Vector for the data properties of each vertex and a Dict for the edge properties.
The Dict keys are updated after a vertex removal.

See [the docs](https://unistuttgart-ikr.github.io/AttributeGraphs.jl/dev/#Similar-packages-and-differences) for a comparison with similar packages

`AttributesGraphs.jl` is a simple and small project and might break often in favor of design improvements.
