# Usage

**ImageColorThresholderApp** supports following image color spaces

- RGB
- HSV
- Lab
- YCbCr

Each color space image open with thier repsected channels.

```julia
using GLMakie
using ImageColorThresholderApp
using TestImages
using ColorTypes

rgb_img = testimage("monarch_color")
hsv_img = HSV.(rgb_img)
lab_img = Lab.(rgb_img)
ycbcr_img = YCbCr.(rgb_img)
```

```julia
image_color_thresholder_app(rgb_img)
```
![rgb](./assets/rgb.png)

```julia
image_color_thresholder_app(hsv_img)
```
![hsv](./assets/hsv.png)

```julia
image_color_thresholder_app(lab_img)
```
![lab](./assets/lab.png)

```julia
image_color_thresholder_app(ycbcr_img)
```
![ycbcr](./assets/ycbcr.png)

## Pluto.jl

**ImageColorThresholderApp** integrate with [Pluto.jl](https://github.com/fonsp/Pluto.jl) by using `WGLMakie`

![pluto](./assets/pluto.jpg)