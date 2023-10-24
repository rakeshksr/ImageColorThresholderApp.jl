push!(LOAD_PATH, "../src/")

using ImageColorThresholderApp
using Documenter

makedocs(
    modules=[ImageColorThresholderApp],
    sitename="ImageColorThresholderApp",
    pages=[
        "Home" => "index.md",
        "Usage" => "usage.md",
        "GUI" => "gui.md",
        "Export" => "export.md",
        "Adding support for new image color space" => "cspace.md",
        "API" => "api.md",
    ]
)

deploydocs(
    repo="github.com/rakeshksr/ImageColorThresholderApp.jl.git",
)
