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
    GPUImageSolidColorGenerator* solid = [[GPUImageSolidColorGenerator alloc] init];
    [solid setColorRed:0.0f green:0.0f blue:0.0f alpha:0.0f];
    [solid forceProcessingAtSize:CGSizeMake(resultImage.size.width, resultImage.size.height)];
    UIImage* solidImage = [solid imageFromCurrentlyProcessedOutput];
    GPUImageOpacityFilter* opacityFilter;
    GPUImageHardLightBlendFilter* hardlightFilter;
    GPUImagePicture* pictureOriginal;
    GPUImagePicture* pictureBlend;
    GPUImageFilterGroup* filterGroup;
    
    
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
    GPUImageGradientLayerFilterGroup* gradientFilterGroup = [[GPUImageGradientLayerFilterGroup alloc] initWithImageToProcess:solidImage];
    [gradientFilterGroup setScale:150 Angle:-90];
    [gradientFilterGroup setOffsetX:0.0f Y:15.0f];
    [gradientFilterGroup addColorRed:231.996f Green:114.008f Blue:42.763f Opacity:100.0f Location:0 Midpoint:50];
    [gradientFilterGroup addColorRed:255.0f Green:255.0f Blue:255.0f Opacity:0.0f Location:4096 Midpoint:50];
    GPUImageFilterGroup* gradientFilter = [gradientFilterGroup filterGroup];
    
    filterGroup = [[GPUImageFilterGroup alloc] init];
    [filterGroup addFilter:gradientFilter];
    [filterGroup setInitialFilters:@[gradientFilter]];
    
    // Opacity
    opacityFilter = [[GPUImageOpacityFilter alloc] init];
    [opacityFilter setOpacity:0.30f];
    [filterGroup addTarget:opacityFilter];
    [gradientFilter addTarget:opacityFilter];
    
    // Hardlight
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
    solid = [[GPUImageSolidColorGenerator alloc] init];
    [solid setColorRed:122.0f/255.0f green:18.0f/255.0f blue:18.0f/255.0f alpha:1.0f];
    [solid forceProcessingAtSize:CGSizeMake(resultImage.size.width, resultImage.size.height)];
    solidImage = [solid imageFromCurrentlyProcessedOutput];
    

    return resultImage;
}


@end
