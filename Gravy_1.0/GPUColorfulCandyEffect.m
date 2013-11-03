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
    GPUImagePicture* pictureOriginal;
    GPUImagePicture* pictureBlend;
    GPUImageFilterGroup* filterGroup;
    GPUImageGradientLayerFilterGroup* gradientFilterGroup;
    GPUImageFilterGroup* gradientFilter;
    
    
    // Channel Mixer
    GPUImageChannelMixerFilter* mixerFilter = [[GPUImageChannelMixerFilter alloc] init];
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
    [gradientFilterGroup setScale:150 Angle:45];
    [gradientFilterGroup setOffsetX:20 Y:-30];
    [gradientFilterGroup addColorRed:89.479f Green:35.253f Blue:145.0f Opacity:100.0f Location:0 Midpoint:50];
    [gradientFilterGroup addColorRed:254.0f Green:177.0f Blue:244.0f Opacity:100.0f Location:1229 Midpoint:50];
    [gradientFilterGroup addColorRed:97.0f Green:108.0f Blue:22.0f Opacity:100.0f Location:3400 Midpoint:50];
    [gradientFilterGroup addColorRed:255.0f Green:255.0f Blue:255.0f Opacity:100.0f Location:4096 Midpoint:50];
    gradientFilter = [gradientFilterGroup filterGroup];
    
    
    pictureOriginal = [[GPUImagePicture alloc] initWithImage:resultImage];
    [pictureOriginal addTarget:gradientFilter];
    [pictureOriginal processImage];
    return [gradientFilter imageFromCurrentlyProcessedOutput];

    return resultImage;
}


@end
