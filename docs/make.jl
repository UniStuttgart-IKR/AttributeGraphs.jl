using Documenter, AttributeGraphs, Graphs

makedocs(sitename="AttributeGraphs.jl",
    pages = [
        "Introduction" => "index.md",
        "Usage and Examples" => "usage.md",
        "API" => "API.md"
    ])

deploydocs(
    repo = "github.com/UniStuttgart-IKR/AttributeGraphs.jl.git",
)
