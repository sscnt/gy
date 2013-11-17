//
//  GPUEffectVintageFilm.m
//  Gravy_1.0
//
//  Created by SSC on 2013/11/17.
//  Copyright (c) 2013年 SSC. All rights reserved.
//

#import "GPUEffectVintageFilm.h"

@implementation GPUEffectVintageFilm


- (UIImage*)process
{
    UIImage* resultImage = self.imageToProcess;
    UIImage* solidImage;
    
    // Saturation
    @autoreleasepool {
        GPUImageSaturationFilter* saturationFilter = [[GPUImageSaturationFilter alloc] init];
        saturationFilter.saturation = 1.25f;
        GPUImagePicture* picture = [[GPUImagePicture alloc] initWithImage:resultImage];
        [picture addTarget:saturationFilter];
        [picture processImage];
        solidImage = [saturationFilter imageFromCurrentlyProcessedOutput];
    }
    
    // Contrast
    @autoreleasepool {
        GPUImageContrastFilter* contrastFilter = [[GPUImageContrastFilter alloc] init];
        contrastFilter.contrast = 1.05;
        
        GPUImagePicture* picture = [[GPUImagePicture alloc] initWithImage:solidImage];
        [picture addTarget:contrastFilter];
        [picture processImage];
        resultImage = [contrastFilter imageFromCurrentlyProcessedOutput];
    }
    
    
    // Gradient
    @autoreleasepool {
        GPUImageGradientColorGenerator* gradientColor = [[GPUImageGradientColorGenerator alloc] init];
        [gradientColor forceProcessingAtSize:CGSizeMake(resultImage.size.width, resultImage.size.height)];
        [gradientColor setStyle:GradientStyleRadial];
        [gradientColor setAngleDegree:90];
        [gradientColor setOffsetX:0.0f Y:0.0f];
        [gradientColor setScalePercent:110];
        [gradientColor addColorRed:255.0f Green:255.0f Blue:255.0f Opacity:100.0f Location:0 Midpoint:50];
        [gradientColor addColorRed:255.0f Green:255.0f Blue:255.0f Opacity:0.0f Location:4096 Midpoint:50];
        
        GPUImageOpacityFilter* opacityFilter = [[GPUImageOpacityFilter alloc] init];
        opacityFilter.opacity = 0.50f;
        [gradientColor addTarget:opacityFilter];
        
        GPUImageOverlayBlendFilter* blendFilter = [[GPUImageOverlayBlendFilter alloc] init];
        [opacityFilter addTarget:blendFilter atTextureLocation:1];
        
        GPUImagePicture* picture = [[GPUImagePicture alloc] initWithImage:resultImage];
        [picture addTarget:blendFilter];
        [picture addTarget:gradientColor];
        [picture processImage];
        resultImage = [blendFilter imageFromCurrentlyProcessedOutput];
        
    }
    
    // Gradient
    @autoreleasepool {
        GPUImageGradientColorGenerator* gradientColor = [[GPUImageGradientColorGenerator alloc] init];
        [gradientColor forceProcessingAtSize:CGSizeMake(resultImage.size.width, resultImage.size.height)];
        [gradientColor setStyle:GradientStyleRadial];
        [gradientColor setAngleDegree:90];
        [gradientColor setScalePercent:150];
        [gradientColor addColorRed:255.0f Green:255.0f Blue:255.0f Opacity:0.0f Location:0 Midpoint:50];
        [gradientColor addColorRed:0.0f Green:0.0f Blue:0.0f Opacity:100.0f Location:4096 Midpoint:50];
        
        GPUImageOpacityFilter* opacityFilter = [[GPUImageOpacityFilter alloc] init];
        opacityFilter.opacity = 0.50f;
        [gradientColor addTarget:opacityFilter];
        
        GPUImageOverlayBlendFilter* blendFilter = [[GPUImageOverlayBlendFilter alloc] init];
        [opacityFilter addTarget:blendFilter atTextureLocation:1];
        
        GPUImagePicture* picture = [[GPUImagePicture alloc] initWithImage:resultImage];
        [picture addTarget:blendFilter];
        [picture addTarget:gradientColor];
        [picture processImage];
        solidImage = [blendFilter imageFromCurrentlyProcessedOutput];
    }
    
    // Curve
    @autoreleasepool {
        GPUImageToneCurveFilter* curveFilter = [[GPUImageToneCurveFilter alloc] initWithACV:@"GPUCCCurve01"];
        
        GPUImagePicture* picture = [[GPUImagePicture alloc] initWithImage:resultImage];
        [picture addTarget:curveFilter];
        [picture processImage];
        solidImage = [curveFilter imageFromCurrentlyProcessedOutput];
    }
    
    // Hue / Saturation
    @autoreleasepool {
        GPUImageHueFilter* hueFilter = [[GPUImageHueFilter alloc] init];
        hueFilter.hue = 200;
        
        GPUImagePicture* picture = [[GPUImagePicture alloc] initWithImage:self.imageToProcess];
        [picture addTarget:hueFilter];
        [picture processImage];
        resultImage = [hueFilter imageFromCurrentlyProcessedOutput];
    }
    
    return resultImage;
}

@end
