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
    GPUImageGradientColorGenerator* gradientGenerator;
    GPUImageToneCurveFilter* curveFilter;
    GPUImageChannelMixerFilter* mixerFilter;

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
    gradientGenerator = [[GPUImageGradientColorGenerator alloc] init];
    [gradientGenerator forceProcessingAtSize:CGSizeMake(resultImage.size.width, resultImage.size.height)];
    [gradientGenerator setAngleDegree:-90.0f];
    [gradientGenerator setScalePercent:150.0f];
    [gradientGenerator setOffsetX:0.0f Y:15.0f];
    [gradientGenerator addColorRed:231.996f Green:114.008f Blue:42.763f Opacity:100.0f Location:0 Midpoint:50];
    [gradientGenerator addColorRed:255.0f Green:255.0f Blue:255.0f Opacity:0.0f Location:4096 Midpoint:50];
    
    //// Opacity
    opacityFilter = [[GPUImageOpacityFilter alloc] init];
    opacityFilter.opacity = 0.30f;
    [gradientGenerator addTarget:opacityFilter];
    
    //// Hardlight Blending
    hardlightFilter = [[GPUImageHardLightBlendFilter alloc] init];
    [opacityFilter addTarget:hardlightFilter atTextureLocation:1];
    
    // Flatten
    pictureOriginal = [[GPUImagePicture alloc] initWithImage:resultImage];
    [pictureOriginal addTarget:hardlightFilter];
    [pictureOriginal addTarget:gradientGenerator];
    [pictureOriginal processImage];
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
    [solidGenerator addTarget:opacityFilter];
    [opacityFilter addTarget:hueFilter atTextureLocation:1];
    
    
    // Flatten
    pictureOriginal = [[GPUImagePicture alloc] initWithImage:resultImage];
    [pictureOriginal addTarget:hueFilter];
    [pictureOriginal addTarget:solidGenerator];
    [pictureOriginal processImage];
    resultImage = [hueFilter imageFromCurrentlyProcessedOutput];

    // Fill Gradient
    gradientGenerator = [[GPUImageGradientColorGenerator alloc] init];
    [gradientGenerator forceProcessingAtSize:CGSizeMake(resultImage.size.width, resultImage.size.height)];
    [gradientGenerator setAngleDegree:40.0f];
    [gradientGenerator setScalePercent:170.0f];
    [gradientGenerator setOffsetX:22.6f Y:-29.1f];
    [gradientGenerator addColorRed:89.479f Green:35.253f Blue:145.0f Opacity:100.0f Location:0 Midpoint:50];
    [gradientGenerator addColorRed:254.0f Green:177.0f Blue:244.0f Opacity:100.0f Location:1229 Midpoint:50];
    [gradientGenerator addColorRed:97.0f Green:108.0f Blue:22.0f Opacity:100.0f Location:3400 Midpoint:50];
    [gradientGenerator addColorRed:255.0f Green:255.0f Blue:255.0f Opacity:100.0f Location:4096 Midpoint:50];
    
    //// Tone Curve
    curveFilter = [[GPUImageToneCurveFilter alloc] initWithACV:@"GPUCCCurve01"];
    [gradientGenerator addTarget:curveFilter];
    
    //// Blending
    pictureBlend = [[GPUImagePicture alloc] initWithImage:resultImage];
    [pictureBlend addTarget:gradientGenerator];
    [pictureBlend processImage];
    pictureOriginal = [[GPUImagePicture alloc] initWithImage:[gradientGenerator imageFromCurrentlyProcessedOutput]];
    pictureBlend = [[GPUImagePicture alloc] initWithImage:[curveFilter imageFromCurrentlyProcessedOutput]];
    opacityFilter = [[GPUImageOpacityFilter alloc] init];
    opacityFilter.opacity = 0.10f;
    hardlightFilter = [[GPUImageHardLightBlendFilter alloc] init];
    [opacityFilter addTarget:hardlightFilter atTextureLocation:1];
    [pictureOriginal addTarget:hardlightFilter];
    [pictureBlend addTarget:opacityFilter];
    [pictureBlend processImage];
    [pictureOriginal processImage];
    pictureBlend = [[GPUImagePicture alloc] initWithImage:[hardlightFilter imageFromCurrentlyProcessedOutput]];


    // Flatten
    opacityFilter = [[GPUImageOpacityFilter alloc] init];
    opacityFilter.opacity = 0.34f;
    hardlightFilter = [[GPUImageHardLightBlendFilter alloc] init];
    [opacityFilter addTarget:hardlightFilter atTextureLocation:1];
    pictureOriginal = [[GPUImagePicture alloc] initWithImage:resultImage];
    [pictureOriginal addTarget:hardlightFilter];
    [pictureBlend addTarget:opacityFilter];
    [pictureOriginal processImage];
    [pictureBlend processImage];
    resultImage = [hardlightFilter imageFromCurrentlyProcessedOutput];
    
    // Fill Gradient
    gradientGenerator = [[GPUImageGradientColorGenerator alloc] init];
    [gradientGenerator forceProcessingAtSize:CGSizeMake(resultImage.size.width, resultImage.size.height)];
    [gradientGenerator setAngleDegree:-130.0f];
    [gradientGenerator setScalePercent:150.0f];
    [gradientGenerator setOffsetX:48.6f Y:-45.3f];
    [gradientGenerator addColorRed:255.0f Green:255.0f Blue:255.0f Opacity:100.0f Location:0 Midpoint:50];
    [gradientGenerator addColorRed:255.0f Green:255.0f Blue:255.0f Opacity:0.0f Location:4096 Midpoint:50];
    
    // Flatten
    opacityFilter = [[GPUImageOpacityFilter alloc] init];
    opacityFilter.opacity = 0.34f;
    [gradientGenerator addTarget:opacityFilter];
    hardlightFilter = [[GPUImageHardLightBlendFilter alloc] init];
    [opacityFilter addTarget:hardlightFilter atTextureLocation:1];
    pictureOriginal = [[GPUImagePicture alloc] initWithImage:resultImage];
    [pictureOriginal addTarget:hardlightFilter];
    [pictureOriginal addTarget:gradientGenerator];
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
    
    //// Blending
    GPUImageScreenBlendFilter* screenFilter = [[GPUImageScreenBlendFilter alloc] init];
    opacityFilter = [[GPUImageOpacityFilter alloc] init];
    opacityFilter.opacity = 0.2f;
    [mixerFilter addTarget:opacityFilter];
    [opacityFilter addTarget:screenFilter atTextureLocation:1];
    pictureOriginal = [[GPUImagePicture alloc] initWithImage:resultImage];
    [pictureOriginal addTarget:screenFilter];
    [pictureOriginal addTarget:mixerFilter];
    [pictureOriginal processImage];
    resultImage = [screenFilter imageFromCurrentlyProcessedOutput];
    
    // Fill
    solidGenerator = [[GPUImageSolidColorGenerator alloc] init];
    [solidGenerator setColorRed:209.0f/255.0f green:200.0f/255.0f blue:157.0f/255.0f alpha:1.0f];
    [solidGenerator forceProcessingAtSize:CGSizeMake(resultImage.size.width, resultImage.size.height)];
    darkenFilter = [[GPUImageDarkenBlendFilter alloc] init];
    [solidGenerator addTarget:darkenFilter atTextureLocation:1];
    pictureBlend = [[GPUImagePicture alloc] initWithImage:resultImage];
    [pictureBlend addTarget:solidGenerator];
    pictureOriginal = [[GPUImagePicture alloc] initWithImage:resultImage];
    [pictureOriginal addTarget:darkenFilter];
    [pictureOriginal processImage];
    [pictureBlend processImage];
    solidImage = [darkenFilter imageFromCurrentlyProcessedOutput];
    
    
    // Fill
    solidGenerator = [[GPUImageSolidColorGenerator alloc] init];
    [solidGenerator setColorRed:209.0f/255.0f green:200.0f/255.0f blue:157.0f/255.0f alpha:1.0f];
    [solidGenerator forceProcessingAtSize:CGSizeMake(resultImage.size.width, resultImage.size.height)];
    opacityFilter = [[GPUImageOpacityFilter alloc] init];
    opacityFilter.opacity = 0.30f;
    [solidGenerator addTarget:opacityFilter];
    
    // Blending
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
