rgb_img = rand(typeof(RGB(0, 0, 0)), 100, 100)
hsv_img = rand(HSV{Float32}, 100, 100)
ybr_img = YCbCr.(rgb_img)
lab_img = rand(Lab{Float32}, 100, 100)

@testset "RGB Image" begin
    fig = image_color_thresholder_app(rgb_img)
    @test fig isa Figure
end

@testset "HSV Image" begin
    fig = image_color_thresholder_app(hsv_img)
    @test fig isa Figure
end

@testset "YCbCr Image" begin
    fig = image_color_thresholder_app(ybr_img)
    @test fig isa Figure
end

@testset "Lab Image" begin
    fig = image_color_thresholder_app(lab_img)
    @test fig isa Figure
end