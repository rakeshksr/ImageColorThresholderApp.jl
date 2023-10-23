push!(LOAD_PATH,"../src/")

using ImageColorThresholderApp
using Documenter

makedocs(
    modules = [ImageColorThresholderApp],
    sitename = "ImageColorThresholderApp",
    pages = [
        "index.md",
        "API" => "api.md"
    ]
)