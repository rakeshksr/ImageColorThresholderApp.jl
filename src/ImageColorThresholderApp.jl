module ImageColorThresholderApp

using Makie
using ColorTypes

export image_color_thresholder_app, image_color_threshold

Base.@kwdef struct PlotProp{T<:Color3}
    type::Type{T}
    alpha_type::Type{<:ColorAlpha}
    type_string::String
    color_properties::NTuple{3,Symbol}
    names::NTuple{3,String}
    lengths::NTuple{3,Int}
    range::NTuple{3,NTuple{2,Int}}
    color_range::NTuple{3,NTuple{2,T}}
    background_color::T
end

"""
mask, timg = image_color_threshold(img[, bg])

# Arguments
- `img`: input image.
- `bg`: background color to replace, if not provided black color will be used.

# Returns
- `mask`: binary mask
- `timg`: thresholded image

!!! warning
    
    It needs to export from GUI

"""
function image_color_threshold end

function generate_code(ch1::NTuple{2,T}, ch2::NTuple{2,T}, ch3::NTuple{2,T}, it::Bool, type_string::String, bg::C, color_properties::NTuple{3,Symbol}) where {T<:Real,C<:Color3}
    _bg = replace("$bg", r"{.*}" => "")
    cnd = ifelse(it, "!(_cnd)", "_cnd")
    fcode = """
    function image_color_threshold(img::Matrix{$(type_string){T}}, bg=$(_bg)) where {T}
        mask = map(img) do pix
            _cnd = ($(ch1[1]) <= getproperty(pix, :$(color_properties[1])) <= $(ch1[2])) && ($(ch2[1]) <= getproperty(pix, :$(color_properties[2])) <= $(ch2[2])) && ($(ch3[1]) <= getproperty(pix, :$(color_properties[3])) <= $(ch3[2]))
            $(cnd)
        end
        new_img = deepcopy(img)
        new_img[.!mask] .= bg
        return (mask, new_img)
    end
    """
    return fcode
end

function _find_postion(val::T, arr::AbstractVector{T}, st::R) where {T,R<:Real}
    floor(Int, float(val - first(arr)) / st) + 1
end

function _find_postion(val::T, arr::Vector{C}, cprop::Symbol) where {T,C<:Color3}
    hasfield(C, cprop) || throw(ArgumentError("$C has no field $cprop"))
    _arr = getproperty.(arr, Ref(cprop))
    # st = (last(_arr) - first(_arr)) / (length(_arr) - 1)
    st = _arr[2] - _arr[1]
    _find_postion(val, _arr, st)
end

function _find_postion(val::T, arr::LinRange{T}) where {T}
    first(arr) <= val <= last(arr) || throw(ArgumentError("$val outside of $arr"))
    _find_postion(val, arr, step(arr))
end

function plot_channel(channel_grid::GridLayout, channel_slr::IntervalSlider, channel_vals::Vector{<:Real}, props::PlotProp, nchannel::Int)
    channel_extrema = extrema(channel_vals)
    chist_clrs = range(props.color_range[nchannel][1], props.color_range[nchannel][2], length=props.lengths[nchannel])
    channel_hist_clrs_range = range(_find_postion(channel_extrema[1], chist_clrs, props.color_properties[nchannel]), _find_postion(channel_extrema[2], chist_clrs, props.color_properties[nchannel]), step=1)
    channel_hist_bins = length(channel_hist_clrs_range)
    channel_hist_clrs = lift(channel_slr.interval) do i
        _clrs = map(chist_clrs) do c
            a = ifelse(i[1] <= getproperty(c, props.color_properties[nchannel]) <= i[2], 1, 0.5)
            props.alpha_type(c, a)
        end
        # To apply only required colors to histogram
        _clrs[channel_hist_clrs_range]
    end
    channel_line_pos = lift(channel_slr.interval) do i
        [i[1], i[2]]
    end
    channel_line_clrs = lift(channel_slr.interval) do i
        [chist_clrs[_find_postion(_i, channel_slr.range[])] for _i in i]
    end

    channel_axis = Makie.Axis(channel_grid[2, 1], limits=(props.range[nchannel], nothing), ylabel=props.names[nchannel], yticksvisible=false, yticklabelsvisible=false)
    hist!(channel_axis, channel_vals, bins=channel_hist_bins, color=channel_hist_clrs)
    vlines!(channel_axis, channel_line_pos, color=channel_line_clrs)
    rowgap!(channel_grid, 1, 0)
end

function _color_thresholder(img::Matrix{<:Color3}, props::PlotProp)
    flat_img = vec(img)
    channel1_vals = getproperty.(flat_img, Ref(props.color_properties[1]))
    channel2_vals = getproperty.(flat_img, Ref(props.color_properties[2]))
    channel3_vals = getproperty.(flat_img, Ref(props.color_properties[3]))

    fig = Figure()

    iax = Makie.Axis(fig[1:2, 1])
    clrhist = fig[1, 2] = GridLayout()
    if props.type == HSV
        clrspace = Axis3(fig[2, 2], zlabel=props.names[3], xlabelvisible=false, xticksvisible=false, xticklabelsvisible=false, ylabelvisible=false, yticksvisible=false, yticklabelsvisible=false)
    elseif props.type == RGB
        clrspace = Axis3(fig[2, 2], xlabel=props.names[1], ylabel=props.names[2], zlabel=props.names[3])
    else
        # For YCbCr, Lab
        clrspace = Axis3(fig[2, 2], xlabel=props.names[2], ylabel=props.names[3], zlabel=props.names[1])
    end
    wgrd = fig[3, :] = GridLayout(tellwidth=false)

    channel1_grid = clrhist[1, 1] = GridLayout()
    channel1_slr = IntervalSlider(channel1_grid[1, 1], range=LinRange(props.range[1][1], props.range[1][2], props.lengths[1])) # startvalues=channel1_extrema, removes some pixels
    plot_channel(channel1_grid, channel1_slr, channel1_vals, props, 1)

    channel2_grid = clrhist[2, 1] = GridLayout()
    channel2_slr = IntervalSlider(channel2_grid[1, 1], range=LinRange(props.range[2][1], props.range[2][2], props.lengths[2])) # startvalues=channel2_extrema, , removes some pixels
    plot_channel(channel2_grid, channel2_slr, channel2_vals, props, 2)

    channel3_grid = clrhist[3, 1] = GridLayout()
    channel3_slr = IntervalSlider(channel3_grid[1, 1], range=LinRange(props.range[3][1], props.range[3][2], props.lengths[3])) # startvalues=channel3_extrema, removes some pixels
    plot_channel(channel3_grid, channel3_slr, channel3_vals, props, 3)

    scatter_clrs = lift(channel1_slr.interval, channel2_slr.interval, channel3_slr.interval) do c1, c2, c3
        map(flat_img) do pix
            cnd = (c1[1] <= getproperty(pix, props.color_properties[1]) <= c1[2]) && (c2[1] <= getproperty(pix, props.color_properties[2]) <= c2[2]) && (c3[1] <= getproperty(pix, props.color_properties[3]) <= c3[2])
            a = ifelse(cnd, 1.0, 0.0)
            props.alpha_type(pix, a)
        end
    end

    if props.type == HSV
        xvals = channel2_vals .* cosd.(channel1_vals) .* channel3_vals
        yvals = channel2_vals .* sind.(channel1_vals) .* channel3_vals
        scatter!(clrspace, xvals, yvals, channel3_vals, color=scatter_clrs, markersize=5)
    elseif props.type == RGB
        scatter!(clrspace, channel1_vals, channel2_vals, channel3_vals, color=scatter_clrs, markersize=5)
    else
        # For YCbCr, Lab
        scatter!(clrspace, channel2_vals, channel3_vals, channel1_vals, color=scatter_clrs, markersize=5)
    end

    invert_toggle = wgrd[1, 1] = Makie.Toggle(fig, active=false)
    invert_label = wgrd[1, 2] = Makie.Label(fig, "Invert")
    reset_button = wgrd[1, 3] = Makie.Button(fig, label="Reset")
    # save_button = wgrd[1, 4] = Makie.Button(fig, label="Save Image")
    export_button = wgrd[1, 4] = Makie.Button(fig, label="Export Code")
    tb = wgrd[1, 5] = Textbox(fig, placeholder="Enter julia file path to export")

    julia_export_path = Observable("")

    on(tb.stored_string) do s
        julia_export_path[] = s
    end


    on(reset_button.clicks) do _
        set_close_to!(channel1_slr, props.range[1][1], props.range[1][2])
        set_close_to!(channel2_slr, props.range[2][1], props.range[2][2])
        set_close_to!(channel3_slr, props.range[3][1], props.range[3][2])
    end

    # on(save_button.clicks) do _
    #     save("testout.png", rotl90(preview_img[]))
    # end

    on(export_button.clicks) do _
        fcode = generate_code(channel1_slr.interval[], channel2_slr.interval[], channel3_slr.interval[], invert_toggle.active[], props.type_string, props.background_color, props.color_properties)
        if !isempty(julia_export_path[])
            open(julia_export_path[], "w") do fid
                write(fid, fcode)
            end
        end
        eval(Meta.parse(fcode))
    end

    preview_img = lift(channel1_slr.interval, channel2_slr.interval, channel3_slr.interval, invert_toggle.active) do c1, c2, c3, it
        _img = map(img) do pix
            _cnd = (c1[1] <= getproperty(pix, props.color_properties[1]) <= c1[2]) && (c2[1] <= getproperty(pix, props.color_properties[2]) <= c2[2]) && (c3[1] <= getproperty(pix, props.color_properties[3]) <= c3[2])
            cnd = ifelse(it, !(_cnd), _cnd)
            # cnd = it || _cnd
            ifelse(cnd, pix, props.background_color)
        end
        rotr90(_img)
    end

    hidedecorations!(iax)
    image!(iax, preview_img)

    return fig
end

"""
image_color_thresholder_app(img)

Open the image color thresholder app GUI.

"""
function image_color_thresholder_app(img::Matrix{RGB{T}}) where {T}
    plotprop = PlotProp(
        type=RGB,
        alpha_type=RGBA,
        type_string="RGB",
        color_properties=(:r, :g, :b),
        names=("Red", "Green", "Blue"),
        lengths=(256, 256, 256),
        range=(
            (0, 1),
            (0, 1),
            (0, 1),
        ),
        color_range=(
            (RGB(0, 0, 0), RGB(1, 0, 0)),
            (RGB(0, 0, 0), RGB(0, 1, 0)),
            (RGB(0, 0, 0), RGB(0, 0, 1)),
        ),
        background_color=zero(RGB)
    )
    _color_thresholder(img, plotprop)
end

function image_color_thresholder_app(img::Matrix{HSV{T}}) where {T}
    plotprop = PlotProp(
        type=HSV,
        alpha_type=HSVA,
        type_string="HSV",
        color_properties=(:h, :s, :v),
        names=("Hue", "Saturation", "Value"),
        lengths=(361, 256, 256),
        range=(
            (0, 360),
            (0, 1),
            (0, 1),
        ),
        color_range=(
            (HSV(0.0f0, 1.0f0, 1.0f0), HSV(360.0f0, 1.0f0, 1.0f0)),
            (HSV(0.0f0, 0.0f0, 1.0f0), HSV(0.0f0, 1.0f0, 1.0f0)),
            (HSV(0.0f0, 0.0f0, 0.0f0), HSV(0.0f0, 0.0f0, 1.0f0)),
        ),
        background_color=zero(HSV)
    )
    _color_thresholder(img, plotprop)
end

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

function image_color_thresholder_app(img::Matrix{Lab{T}}) where {T}
    plotprop = PlotProp(
        type=Lab,
        alpha_type=LabA,
        type_string="Lab",
        color_properties=(:l, :a, :b,),
        names=("L", "a", "b"),
        lengths=(101, 256, 256),
        range=(
            (0, 100),
            (-128, 127),
            (-128, 127),
        ),
        color_range=(
            (Lab(0.0f0, 0.0f0, 0.0f0), Lab(100.0f0, 0.0f0, 0.0f0)),
            (Lab(80.0f0, -128.0f0, 0.0f0), Lab(80.0f0, 127.0f0, 0.0f0)),
            (Lab(80.0f0, 0.0f0, -128.0f0), Lab(80.0f0, 0.0f0, 127.0f0)),
        ),
        background_color=zero(Lab)
    )
    _color_thresholder(img, plotprop)
end

include("precompile.jl")
end
