using PrecompileTools

@setup_workload begin
    # rgb_img = rand(RGB{N0f8}, 100, 100) # Needs FixedPointNumbers
    rgb_img = rand(typeof(RGB(0,0,0)), 100, 100)
    hsv_img = rand(HSV{Float32}, 100, 100)
    # ybr_img = rand(YCbCr{Float32}, 100, 100) # No method availabe for rand(YCbCr{Float32})
    ybr_img = YCbCr.(rgb_img)
    lab_img = rand(Lab{Float32}, 100, 100)

    @compile_workload begin
        image_color_thresholder_app(rgb_img)
        image_color_thresholder_app(hsv_img)
        image_color_thresholder_app(ybr_img)
        image_color_thresholder_app(lab_img)
    end
end