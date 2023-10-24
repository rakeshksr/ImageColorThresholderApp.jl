# Adding support for new image color space

To add new image color space need to dispatch  [`image_color_thresholder_app`](@ref) with that type.

1. Need to create instance of `PlotProp` structure for required type. Here is explanantion for `PlotProp` fields

    * **type**: Required color space type(must be <:Color3).
    * **alpha_type**: alpha type for color space type
    * **type_string**: String representation of type.
    * **color_properties**: Field names of type.
    * **names**: Names to diplay on histograms y-axis.
    * **lengths**: Length of each channel, used in histogram bins.
    * **range**: Each channel min and max values.
    * **color_range**: Color range for each channel to represnt in hisograms.
    * **background_color**: Background color to replace in preview image. Use black color as backgound. Use `zero(type)` if not works enter values manually.
2. Call `_color_thresholder` with image and instance of PlotProp.

Here example code for `YCbCr` format

```julia
using ImageColorThresholderApp: image_color_thresholder_app, PlotProp, _color_thresholder

function image_color_thresholder_app(img::Matrix{YCbCr{T}}) where {T}
    plotprop = PlotProp(
        type=YCbCr,
        alpha_type=YCbCrA,
        type_string="YCbCr",
        color_properties=(:y, :cb, :cr),
        names=("Y", "Cb", "Cr"),
        lengths=(220, 225, 225),
        range=(
            (16, 235),
            (16, 240),
            (16, 240),
        ),
        color_range=(
            (YCbCr(16.0f0, 128.0f0, 128.0f0), YCbCr(235.0f0, 128.0f0, 128.0f0)),
            (YCbCr(210.0f0, 16.0f0, 146.0f0), YCbCr(41.0f0, 240.0f0, 110.0f0)),
            (YCbCr(165.5f0, 166.0f0, 16.0f0), YCbCr(81.5f0, 90.0f0, 240.0f0)),
        ),
        background_color=YCbCr(16.0f0, 128.0f0, 128.0f0),
    )
    _color_thresholder(img, plotprop)
end
```