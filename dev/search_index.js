var documenterSearchIndex = {"docs":
[{"location":"api/","page":"API","title":"API","text":"image_color_thresholder_app\nimage_color_threshold","category":"page"},{"location":"api/#ImageColorThresholderApp.image_color_thresholder_app","page":"API","title":"ImageColorThresholderApp.image_color_thresholder_app","text":"imagecolorthresholder_app(img)\n\nOpen the image color thresholder app GUI.\n\n\n\n\n\n","category":"function"},{"location":"api/#ImageColorThresholderApp.image_color_threshold","page":"API","title":"ImageColorThresholderApp.image_color_threshold","text":"mask, timg = imagecolorthreshold(img[, bg])\n\nArguments\n\nimg: input image.\nbg: background color to replace, if not provided black color will be used.\n\nReturns\n\nmask: binary mask\ntimg: thresholded image\n\nwarning: Warning\nIt needs to export from GUI\n\n\n\n\n\n","category":"function"},{"location":"cspace/#Adding-support-for-new-image-color-space","page":"Adding support for new image color space","title":"Adding support for new image color space","text":"","category":"section"},{"location":"cspace/","page":"Adding support for new image color space","title":"Adding support for new image color space","text":"To add new image color space need to dispatch  image_color_thresholder_app with that type.","category":"page"},{"location":"cspace/","page":"Adding support for new image color space","title":"Adding support for new image color space","text":"Need to create instance of PlotProp structure for required type. Here is explanantion for PlotProp fields\ntype: Required color space type(must be <:Color3).\nalpha_type: alpha type for color space type\ntype_string: String representation of type.\ncolor_properties: Field names of type.\nnames: Names to diplay on histograms y-axis.\nlengths: Length of each channel, used in histogram bins.\nrange: Each channel min and max values.\ncolor_range: Color range for each channel to represnt in hisograms.\nbackground_color: Background color to replace in preview image. Use black color as backgound. Use zero(type) if not works enter values manually.\nCall _color_thresholder with image and instance of PlotProp.","category":"page"},{"location":"cspace/","page":"Adding support for new image color space","title":"Adding support for new image color space","text":"Here example code for YCbCr format","category":"page"},{"location":"cspace/","page":"Adding support for new image color space","title":"Adding support for new image color space","text":"using ImageColorThresholderApp: image_color_thresholder_app, PlotProp, _color_thresholder\n\nfunction image_color_thresholder_app(img::Matrix{YCbCr{T}}) where {T}\n    plotprop = PlotProp(\n        type=YCbCr,\n        alpha_type=YCbCrA,\n        type_string=\"YCbCr\",\n        color_properties=(:y, :cb, :cr),\n        names=(\"Y\", \"Cb\", \"Cr\"),\n        lengths=(220, 225, 225),\n        range=(\n            (16, 235),\n            (16, 240),\n            (16, 240),\n        ),\n        color_range=(\n            (YCbCr(16.0f0, 128.0f0, 128.0f0), YCbCr(235.0f0, 128.0f0, 128.0f0)),\n            (YCbCr(210.0f0, 16.0f0, 146.0f0), YCbCr(41.0f0, 240.0f0, 110.0f0)),\n            (YCbCr(165.5f0, 166.0f0, 16.0f0), YCbCr(81.5f0, 90.0f0, 240.0f0)),\n        ),\n        background_color=YCbCr(16.0f0, 128.0f0, 128.0f0),\n    )\n    _color_thresholder(img, plotprop)\nend","category":"page"},{"location":"export/#Export","page":"Export","title":"Export","text":"","category":"section"},{"location":"export/","page":"Export","title":"Export","text":"Pages = [\"export.md\"]\nDepth = 2:2","category":"page"},{"location":"export/","page":"Export","title":"Export","text":"ImageColorThresholderApp gui makes possible to export progress to workspace and file to do furthur analysis on images. ","category":"page"},{"location":"export/#Export-as-function","page":"Export","title":"Export as function","text":"","category":"section"},{"location":"export/","page":"Export","title":"Export","text":"After changing interval sliders as per use case, select Export button. It exports selection to workspace as function named image_color_threshold. image_color_threshold takes image, background color(optional) as inputs, if background color omitted it takes black as background color, it returns mask and thresholded image.","category":"page"},{"location":"export/","page":"Export","title":"Export","text":"Without background color","category":"page"},{"location":"export/","page":"Export","title":"Export","text":"mask, timg1 = image_color_threshold(img)\n\ntimg1","category":"page"},{"location":"export/","page":"Export","title":"Export","text":"(Image: nobg)","category":"page"},{"location":"export/","page":"Export","title":"Export","text":"With backgound color(magenta)","category":"page"},{"location":"export/","page":"Export","title":"Export","text":"mask, timg2 = image_color_threshold(img, RGB(1, 0, 1))\n\ntimg2","category":"page"},{"location":"export/","page":"Export","title":"Export","text":"(Image: magentabg)","category":"page"},{"location":"export/","page":"Export","title":"Export","text":"in both cases mask image is same","category":"page"},{"location":"export/","page":"Export","title":"Export","text":"Gray.(mask)","category":"page"},{"location":"export/","page":"Export","title":"Export","text":"(Image: mask)","category":"page"},{"location":"export/#Export-code-to-file","page":"Export","title":"Export code to file","text":"","category":"section"},{"location":"export/","page":"Export","title":"Export","text":"Enter valid julia file path in Julia file path textbox then press enter, after select Export button. Export button exports selection to workspace and write as julia code in given file path. If julia file not exists at given location it creates automatically, if exists it overwrites file content.","category":"page"},{"location":"export/","page":"Export","title":"Export","text":"Sample file path","category":"page"},{"location":"export/","page":"Export","title":"Export","text":"/home/programs/export.jl","category":"page"},{"location":"export/","page":"Export","title":"Export","text":"Sample exported code","category":"page"},{"location":"export/","page":"Export","title":"Export","text":"function image_color_threshold(img::Matrix{RGB{T}}, bg=RGB(0.0,0.0,0.0)) where {T}\n    mask = map(img) do pix\n        _cnd = (0.0 <= getproperty(pix, :r) <= 1.0) && (0.5607843137254902 <= getproperty(pix, :g) <= 1.0) && (0.0 <= getproperty(pix, :b) <= 1.0)\n        !(_cnd)\n    end\n    new_img = deepcopy(img)\n    new_img[.!mask] .= bg\n    return (mask, new_img)\nend","category":"page"},{"location":"export/#Export-as-image","page":"Export","title":"Export as image","text":"","category":"section"},{"location":"export/","page":"Export","title":"Export","text":"As previous mentioned export as function then","category":"page"},{"location":"export/","page":"Export","title":"Export","text":"using FileIO\n\nmask, timg = image_color_threshold(img)\n\n# Save thresholded image\nsave(\"thresholded_image.png\", timg)\n\n# Save mask as image\nsave(\"mask.png\", Gray.(mask))","category":"page"},{"location":"export/#Export-variables","page":"Export","title":"Export variables","text":"","category":"section"},{"location":"export/","page":"Export","title":"Export","text":"JLD2 useful to export mask and thresholed image to JLD2 file which can be used in different julia sessions.","category":"page"},{"location":"export/","page":"Export","title":"Export","text":"using JLD2\n\nmask, timg = image_color_threshold(img, bg)\n\njldsave(\"export.jld2\"; mask, timg)","category":"page"},{"location":"gui/#GUI","page":"GUI","title":"GUI","text":"","category":"section"},{"location":"gui/","page":"GUI","title":"GUI","text":"Pages = [\"gui.md\"]\nDepth = 2:3","category":"page"},{"location":"gui/","page":"GUI","title":"GUI","text":"GUI has 4 parts","category":"page"},{"location":"gui/","page":"GUI","title":"GUI","text":"Image preview\nChannel threshold\n3D channel scatter\nWidgets","category":"page"},{"location":"gui/","page":"GUI","title":"GUI","text":"(Image: gui)","category":"page"},{"location":"gui/#Image-preview","page":"GUI","title":"Image preview","text":"","category":"section"},{"location":"gui/","page":"GUI","title":"GUI","text":"It show live preview of image, image preview changes as per channels histogram change.","category":"page"},{"location":"gui/#Channel-threshold","page":"GUI","title":"Channel threshold","text":"","category":"section"},{"location":"gui/","page":"GUI","title":"GUI","text":"It contains histograms with interval sliders for each channel. Changing slider values changes the following","category":"page"},{"location":"gui/","page":"GUI","title":"GUI","text":"Change histogram transparent and add vertical lines on histogram axis to indicate selection range\nChange image preview , non selection pixel values changed to black.\nChange 3D channel scatter, remove non selection pixel values from scatter plot.","category":"page"},{"location":"gui/#D-channel-scatter","page":"GUI","title":"3D channel scatter","text":"","category":"section"},{"location":"gui/","page":"GUI","title":"GUI","text":"It show live 3D scatter plot for 3 channels of image. Scatter points changes per channels histogram change.","category":"page"},{"location":"gui/#Widgets","page":"GUI","title":"Widgets","text":"","category":"section"},{"location":"gui/","page":"GUI","title":"GUI","text":"It contains widgets to perform different operations.","category":"page"},{"location":"gui/#Revert","page":"GUI","title":"Revert","text":"","category":"section"},{"location":"gui/","page":"GUI","title":"GUI","text":"It reverts histogram selections, see below","category":"page"},{"location":"gui/","page":"GUI","title":"GUI","text":"<img src=\"../assets/before_revert.png\" alt=\"before\" width=\"50%\"><img src=\"../assets/after_revert.png\" alt=\"after\" width=\"50%\">","category":"page"},{"location":"gui/#Reset","page":"GUI","title":"Reset","text":"","category":"section"},{"location":"gui/","page":"GUI","title":"GUI","text":"It reset the selection. It reset interval slider to orignal positions.","category":"page"},{"location":"gui/#Export-code","page":"GUI","title":"Export code","text":"","category":"section"},{"location":"gui/","page":"GUI","title":"GUI","text":"It export selection process as function named image_color_threshold and also If textbox is contains valid file path it exports as julia code. More can be found in here.","category":"page"},{"location":"gui/#Julia-file-path-textbox","page":"GUI","title":"Julia file path textbox","text":"","category":"section"},{"location":"gui/","page":"GUI","title":"GUI","text":"It holds file path to export result as julia code.","category":"page"},{"location":"usage/#Usage","page":"Usage","title":"Usage","text":"","category":"section"},{"location":"usage/","page":"Usage","title":"Usage","text":"ImageColorThresholderApp supports following image color spaces","category":"page"},{"location":"usage/","page":"Usage","title":"Usage","text":"RGB\nHSV\nLab\nYCbCr","category":"page"},{"location":"usage/","page":"Usage","title":"Usage","text":"Each color space image open with thier repsected channels.","category":"page"},{"location":"usage/","page":"Usage","title":"Usage","text":"using GLMakie\nusing ImageColorThresholderApp\nusing TestImages\nusing ColorTypes\n\nrgb_img = testimage(\"monarch_color\")\nhsv_img = HSV.(rgb_img)\nlab_img = Lab.(rgb_img)\nycbcr_img = YCbCr.(rgb_img)","category":"page"},{"location":"usage/","page":"Usage","title":"Usage","text":"image_color_thresholder_app(rgb_img)","category":"page"},{"location":"usage/","page":"Usage","title":"Usage","text":"(Image: rgb)","category":"page"},{"location":"usage/","page":"Usage","title":"Usage","text":"image_color_thresholder_app(hsv_img)","category":"page"},{"location":"usage/","page":"Usage","title":"Usage","text":"(Image: hsv)","category":"page"},{"location":"usage/","page":"Usage","title":"Usage","text":"image_color_thresholder_app(lab_img)","category":"page"},{"location":"usage/","page":"Usage","title":"Usage","text":"(Image: lab)","category":"page"},{"location":"usage/","page":"Usage","title":"Usage","text":"image_color_thresholder_app(ycbcr_img)","category":"page"},{"location":"usage/","page":"Usage","title":"Usage","text":"(Image: ycbcr)","category":"page"},{"location":"usage/#Pluto.jl","page":"Usage","title":"Pluto.jl","text":"","category":"section"},{"location":"usage/","page":"Usage","title":"Usage","text":"ImageColorThresholderApp integrate with Pluto.jl by using WGLMakie","category":"page"},{"location":"usage/","page":"Usage","title":"Usage","text":"(Image: pluto)","category":"page"},{"location":"#ImageColorThresholderApp.jl","page":"Home","title":"ImageColorThresholderApp.jl","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"ImageColorThresholderApp is a GUI application powered by Makie.jl, Inspired by MATLAB Color Thresholder app.","category":"page"},{"location":"","page":"Home","title":"Home","text":"ImageColorThresholderApp is a GUI tool for segmenting color images. By using it threshold individual color channels or combinations of channels in different color spaces, such as RGB, HSV, Lab and YCbCr. This app generates binary segmentation mask and thresholded image for color images.","category":"page"},{"location":"","page":"Home","title":"Home","text":"Here are features of ImageColorThresholderApp:","category":"page"},{"location":"","page":"Home","title":"Home","text":"Threshold individual color channels or combinations of channels in different color spaces (RGB, HSV, Lab, YCbCr, etc.).\nAdjust the threshold levels interactively.\nPreview the thresholded image in real time.\nGenerate julia code to work space as well as external file.\nGenerate thresholded images and segmentation masks.","category":"page"},{"location":"","page":"Home","title":"Home","text":"ImageColorThresholderApp needs one of Makie backend.","category":"page"},{"location":"","page":"Home","title":"Home","text":"Using GLMakie it opens app window.\nusing WGLMakie It integrate with Pluto.jl notebook.","category":"page"},{"location":"#Installation","page":"Home","title":"Installation","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"You can install ImageColorThresholderApp.jl using Julia's package manager.","category":"page"},{"location":"","page":"Home","title":"Home","text":"For the stable version:","category":"page"},{"location":"","page":"Home","title":"Home","text":"Open a Julia REPL and run the following command:","category":"page"},{"location":"","page":"Home","title":"Home","text":"] add ImageColorThresholderApp","category":"page"},{"location":"","page":"Home","title":"Home","text":"For the development version:","category":"page"},{"location":"","page":"Home","title":"Home","text":"using Pkg\nPkg.add(url=\"https://github.com/rakeshksr/ImageColorThresholderApp.jl\")","category":"page"}]
}