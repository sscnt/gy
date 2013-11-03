//
//  GPUColorfulCandyEffect.m
//  Gravy_1.0
//
//  Created by SSC on 2013/11/01.
//  Copyright (c) 2013年 SSC. All rights reserved.
//

#import "GPUColorfulCandyEffect.h"

@implementation GPUColorfulCandyEffect

- (UIImage*)process
{
    UIImage* resultImage = _imageToProcess;
    GPUImageSolidColorGenerator* solidGenerator = [[GPUImageSolidColorGenerator alloc] init];
    [solidGenerator setColorRed:0.0f green:0.0f blue:0.0f alpha:0.0f];
    [solidGenerator forceProcessingAtSize:CGSizeMake(resultImage.size.width, resultImage.size.height)];
    UIImage* solidImage = [solidGenerator imageFromCurrentlyProcessedOutput];
    GPUImageOpacityFilter* opacityFilter;
    GPUImageHardLightBlendFilter* hardlightFilter;
    GPUImageHueBlendFilter* hueFilter;
    GPUImageDifferenceBlendFilter* diffFilter;
    GPUImageDarkenBlendFilter* darkenFilter;
    GPUImagePicture* pictureOriginal;
    GPUImagePicture* pictureBlend;
    GPUImageFilterGroup* filterGroup;
    GPUImageGradientLayerFilterGroup* gradientFilterGroup;
    GPUImageFilterGroup* gradientFilter;
    GPUImageToneCurveFilter* curveFilter;
    GPUImageChannelMixerFilter* mixerFilter;

    
    // test
    GPUImageGradientColorGenerator* gradientGenerator = [[GPUImageGradientColorGenerator alloc] init];
    [gradientGenerator forceProcessingAtSize:CGSizeMake(resultImage.size.width, resultImage.size.height)];
    [gradientGenerator forceProcessingAtSize:CGSizeMake(resultImage.size.width, resultImage.size.height)];
    [gradientGenerator setAngleDegree:45.0f];
    [gradientGenerator setScalePercent:100.0f];
    [gradientGenerator addColorRed:231.996f Green:114.008f Blue:42.763f Opacity:100.0f Location:0 Midpoint:50];
    [gradientGenerator addColorRed:255.0f Green:255.0f Blue:255.0f Opacity:0.0f Location:4096 Midpoint:50];
    pictureOriginal = [[GPUImagePicture alloc] initWithImage:resultImage];
    [pictureOriginal addTarget:gradientGenerator];
    [pictureOriginal processImage];
    return [gradientGenerator imageFromCurrentlyProcessedOutput];
    
    
    
    // Channel Mixer
    mixerFilter = [[GPUImageChannelMixerFilter alloc] init];
    [mixerFilter setRedChannelRed:92 Green:26 Blue:-20 Constant:0];
    [mixerFilter setGreenChannelRed:0 Green:100 Blue:0 Constant:0];
    [mixerFilter setBlueChannelRed:-8 Green:4 Blue:108 Constant:0];
    pictureOriginal = [[GPUImagePicture alloc] initWithImage:resultImage];
    [pictureOriginal addTarget:mixerFilter];
    [pictureOriginal processImage];
    resultImage = [mixerFilter imageFromCurrentlyProcessedOutput];
    
    // Gradient Fill
    gradientFilterGroup = [[GPUImageGradientLayerFilterGroup alloc] initWithImageToProcess:solidImage];
    [gradientFilterGroup setScale:150 Angle:-90];
    [gradientFilterGroup setOffsetX:0.0f Y:15.0f];
    [gradientFilterGroup addColorRed:231.996f Green:114.008f Blue:42.763f Opacity:100.0f Location:0 Midpoint:50];
    [gradientFilterGroup addColorRed:255.0f Green:255.0f Blue:255.0f Opacity:0.0f Location:4096 Midpoint:50];
    gradientFilter = [gradientFilterGroup filterGroup];
    
    filterGroup = [[GPUImageFilterGroup alloc] init];
    [filterGroup addFilter:gradientFilter];
    [filterGroup setInitialFilters:@[gradientFilter]];
    
    // Opacity
    opacityFilter = [[GPUImageOpacityFilter alloc] init];
    opacityFilter.opacity = 0.30f;
    [filterGroup addTarget:opacityFilter];
    [gradientFilter addTarget:opacityFilter];
    
    // Hardlight Blending
    hardlightFilter = [[GPUImageHardLightBlendFilter alloc] init];
    [filterGroup addFilter:hardlightFilter];
    [opacityFilter addTarget:hardlightFilter atTextureLocation:1];
    [filterGroup setTerminalFilter:hardlightFilter];
    
    // Flatten
    pictureOriginal = [[GPUImagePicture alloc] initWithImage:resultImage];
    pictureBlend = [[GPUImagePicture alloc] initWithImage:solidImage];
    [pictureOriginal addTarget:hardlightFilter];
    [pictureBlend addTarget:filterGroup];
    [pictureOriginal processImage];
    [pictureBlend processImage];
    resultImage = [hardlightFilter imageFromCurrentlyProcessedOutput];
    
    // Fill layer
    solidGenerator = [[GPUImageSolidColorGenerator alloc] init];
    [solidGenerator setColorRed:122.0f/255.0f green:18.0f/255.0f blue:18.0f/255.0f alpha:1.0f];
    [solidGenerator forceProcessingAtSize:CGSizeMake(resultImage.size.width, resultImage.size.height)];
    
    // Hue Blending
    hueFilter = [[GPUImageHueBlendFilter alloc] init];
    
    // Opacity
    opacityFilter = [[GPUImageOpacityFilter alloc] init];
    opacityFilter.opacity = 0.30f;
    
    // Flatten
    pictureOriginal = [[GPUImagePicture alloc] initWithImage:resultImage];
    [pictureOriginal addTarget:hueFilter];
    [pictureOriginal processImage];
    pictureBlend = [[GPUImagePicture alloc] initWithImage:solidImage];
    [pictureBlend addTarget:solidGenerator];
    [solidGenerator addTarget:opacityFilter];
    [opacityFilter addTarget:hueFilter];
    [pictureBlend processImage];
    resultImage = [hueFilter imageFromCurrentlyProcessedOutput];
    
    // Fill Gradient
    gradientFilterGroup = [[GPUImageGradientLayerFilterGroup alloc] initWithImageToProcess:solidImage];
    [gradientFilterGroup setScale:150.0f Angle:60.0f];
    [gradientFilterGroup setOffsetX:6.0f Y:-10.0f];
    [gradientFilterGroup addColorRed:89.479f Green:35.253f Blue:145.0f Opacity:100.0f Location:0 Midpoint:50];
    [gradientFilterGroup addColorRed:254.0f Green:177.0f Blue:244.0f Opacity:100.0f Location:1529 Midpoint:50];
    [gradientFilterGroup addColorRed:97.0f Green:108.0f Blue:22.0f Opacity:100.0f Location:3400 Midpoint:50];
    [gradientFilterGroup addColorRed:255.0f Green:255.0f Blue:255.0f Opacity:100.0f Location:4096 Midpoint:50];
    gradientFilter = [gradientFilterGroup filterGroup];
    
    // Tone Curve
    curveFilter = [[GPUImageToneCurveFilter alloc] initWithACV:@"GPUCCCurve01"];
    [gradientFilter addTarget:curveFilter];
    
    // Flatten
    opacityFilter = [[GPUImageOpacityFilter alloc] init];
    opacityFilter.opacity = 0.10f;
    [curveFilter addTarget:opacityFilter];
    hardlightFilter = [[GPUImageHardLightBlendFilter alloc] init];
    [opacityFilter addTarget:hardlightFilter atTextureLocation:1];
    [gradientFilter addTarget:hardlightFilter];
    pictureOriginal = [[GPUImagePicture alloc] initWithImage:resultImage];
    [pictureOriginal addTarget:gradientFilter];
    [pictureOriginal processImage];
    pictureBlend = [[GPUImagePicture alloc] initWithImage:[hardlightFilter imageFromCurrentlyProcessedOutput]];
    return [hardlightFilter imageFromCurrentlyProcessedOutput];
    
    // Flatten
    hardlightFilter = [[GPUImageHardLightBlendFilter alloc] init];
    opacityFilter = [[GPUImageOpacityFilter alloc] init];
    opacityFilter.opacity = 0.34f;
    [opacityFilter addTarget:hardlightFilter atTextureLocation:1];
    pictureOriginal = [[GPUImagePicture alloc] initWithImage:resultImage];
    [pictureOriginal addTarget:hardlightFilter];
    [pictureOriginal processImage];
    [pictureBlend addTarget:opacityFilter];
    [pictureBlend processImage];
    resultImage = [hardlightFilter imageFromCurrentlyProcessedOutput];

    return resultImage;

    
    // Fill Gradient
    gradientFilterGroup = [[GPUImageGradientLayerFilterGroup alloc] initWithImageToProcess:resultImage];
    [gradientFilterGroup setScale:150.0f Angle:-130.0f];
    [gradientFilterGroup setOffsetX:13.0f Y:-22.0f];
    [gradientFilterGroup addColorRed:255.0f Green:255.0f Blue:255.0f Opacity:100.0f Location:0 Midpoint:50];
    [gradientFilterGroup addColorRed:255.0f Green:255.0f Blue:255.0f Opacity:0.0f Location:4096 Midpoint:50];
    gradientFilter = [gradientFilterGroup filterGroup];

    
    // Flatten
    opacityFilter = [[GPUImageOpacityFilter alloc] init];
    opacityFilter.opacity = 0.34f;
    [gradientFilter addTarget:opacityFilter];
    hardlightFilter = [[GPUImageHardLightBlendFilter alloc] init];
    [opacityFilter addTarget:hardlightFilter atTextureLocation:1];
    pictureOriginal = [[GPUImagePicture alloc] initWithImage:resultImage];
    [pictureOriginal addTarget:hardlightFilter];
    [pictureOriginal addTarget:gradientFilter];
    [pictureOriginal processImage];
    resultImage = [hardlightFilter imageFromCurrentlyProcessedOutput];
    
    // Fill
    solidGenerator = [[GPUImageSolidColorGenerator alloc] init];
    [solidGenerator setColorRed:17.0f/255.0f green:21.0f/255.0f blue:103.0f/255.0f alpha:1.0f];
    [solidGenerator forceProcessingAtSize:CGSizeMake(resultImage.size.width, resultImage.size.height)];
    opacityFilter = [[GPUImageOpacityFilter alloc] init];
    opacityFilter.opacity = 0.10f;
    [solidGenerator addTarget:opacityFilter];
    diffFilter = [[GPUImageDifferenceBlendFilter alloc] init];
    [opacityFilter addTarget:diffFilter atTextureLocation:1];
    pictureOriginal = [[GPUImagePicture alloc] initWithImage:resultImage];
    [pictureOriginal addTarget:diffFilter];
    [pictureOriginal addTarget:solidGenerator];
    [pictureOriginal processImage];
    resultImage = [diffFilter imageFromCurrentlyProcessedOutput];
    
    
    
    // Channel Mixer
    mixerFilter = [[GPUImageChannelMixerFilter alloc] init];
    [mixerFilter setRedChannelRed:100 Green:-24 Blue:20 Constant:0];
    [mixerFilter setGreenChannelRed:-8 Green:98 Blue:12 Constant:0];
    [mixerFilter setBlueChannelRed:-20 Green:10 Blue:124 Constant:0];
    pictureOriginal = [[GPUImagePicture alloc] initWithImage:resultImage];
    [pictureOriginal addTarget:mixerFilter];
    [pictureOriginal processImage];
    resultImage = [mixerFilter imageFromCurrentlyProcessedOutput];
    
    
    // Fill
    solidGenerator = [[GPUImageSolidColorGenerator alloc] init];
    [solidGenerator setColorRed:209.0f/255.0f green:200.0f/255.0f blue:157.0f/255.0f alpha:1.0f];
    [solidGenerator forceProcessingAtSize:CGSizeMake(resultImage.size.width, resultImage.size.height)];
    opacityFilter = [[GPUImageOpacityFilter alloc] init];
    opacityFilter.opacity = 0.50f;
    [solidGenerator addTarget:opacityFilter];
    
    
    GPUImageNormalBlendFilter* blendNormal = [[GPUImageNormalBlendFilter alloc] init];
    [opacityFilter addTarget:blendNormal atTextureLocation:1];
    pictureOriginal = [[GPUImagePicture alloc] initWithImage:resultImage];
    [pictureOriginal addTarget:solidGenerator];
    [pictureOriginal addTarget:blendNormal];
    [pictureOriginal processImage];
    return [blendNormal imageFromCurrentlyProcessedOutput];

    
    darkenFilter = [[GPUImageDarkenBlendFilter alloc] init];
    [opacityFilter addTarget:darkenFilter atTextureLocation:1];
    pictureOriginal = [[GPUImagePicture alloc] initWithImage:resultImage];
    [pictureOriginal addTarget:darkenFilter];
    [pictureOriginal addTarget:solidGenerator];
    [pictureOriginal processImage];
    resultImage = [darkenFilter imageFromCurrentlyProcessedOutput];
   
    
    
    /*
    GPUImageNormalBlendFilter* blendNormal = [[GPUImageNormalBlendFilter alloc] init];
    [gradientFilter addTarget:blendNormal atTextureLocation:1];
    pictureOriginal = [[GPUImagePicture alloc] initWithImage:resultImage];
    [pictureOriginal addTarget:gradientFilter];
    [pictureOriginal addTarget:blendNormal];
    [pictureOriginal processImage];
    return [blendNormal imageFromCurrentlyProcessedOutput];
     */
    
    /*
    pictureOriginal = [[GPUImagePicture alloc] initWithImage:solidImage];
    [pictureOriginal addTarget:gradientFilter];
    [pictureOriginal processImage];
    return [gradientFilter imageFromCurrentlyProcessedOutput];
     */
    
    

    return resultImage;
}


@end
