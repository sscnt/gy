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
        //resultImage = [blendFilter imageFromCurrentlyProcessedOutput];
        
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
        
        GPUImageOverlayBlendFilter* overlayBlend = [[GPUImageOverlayBlendFilter alloc] init];
        [opacityFilter addTarget:overlayBlend atTextureLocation:1];
        
        GPUImagePicture* picture = [[GPUImagePicture alloc] initWithImage:resultImage];
        [picture addTarget:overlayBlend];
        [picture addTarget:gradientColor];
        [picture processImage];
        //resultImage = [overlayBlend imageFromCurrentlyProcessedOutput];
    }
    
    // Curve
    @autoreleasepool {

        GPUImageToneCurveFilter* curveFilter = [[GPUImageToneCurveFilter alloc] initWithACV:@"VintageFilm"];
        
        GPUImagePicture* picture = [[GPUImagePicture alloc] initWithImage:resultImage];
        [picture addTarget:curveFilter];
        [picture processImage];
        resultImage = [curveFilter imageFromCurrentlyProcessedOutput];
    }
    
    
    // Hue / Saturation
    @autoreleasepool {
        GPUImageHueSaturationFilter* hueSaturation = [[GPUImageHueSaturationFilter alloc] init];
        hueSaturation.hue = 35.0f;
        hueSaturation.saturation = 25.0f;
        hueSaturation.lightness = 0.0f;
        hueSaturation.colorize = YES;
        
        GPUImageOpacityFilter* opacityFilter = [[GPUImageOpacityFilter alloc] init];
        opacityFilter.opacity = 0.50f;
        [hueSaturation addTarget:opacityFilter];
        
        GPUImageNormalBlendFilter* normalBlend = [[GPUImageNormalBlendFilter alloc] init];
        [opacityFilter addTarget:normalBlend atTextureLocation:1];
        
        GPUImagePicture* picture = [[GPUImagePicture alloc] initWithImage:resultImage];
        [picture addTarget:hueSaturation];
        [picture addTarget:normalBlend];
        [picture processImage];
        resultImage = [normalBlend imageFromCurrentlyProcessedOutput];
    }
    
    @autoreleasepool {
        GPUImageSolidColorGenerator* solidColor = [[GPUImageSolidColorGenerator alloc] init];
        [solidColor forceProcessingAtSize:CGSizeMake(resultImage.size.width, resultImage.size.height)];
        [solidColor setColorRed:236.0f/255.0f green:0.0f blue:139.0f/255.0f alpha:1.0f];
        
        
        GPUImageOpacityFilter* opacityFilter = [[GPUImageOpacityFilter alloc] init];
        opacityFilter.opacity = 0.10f;
        [solidColor addTarget:opacityFilter];
        
        GPUImageScreenBlendFilter* screenBlend = [[GPUImageScreenBlendFilter alloc] init];
        [opacityFilter addTarget:screenBlend atTextureLocation:1];
        
        GPUImagePicture* picture = [[GPUImagePicture alloc] initWithImage:resultImage];
        [picture addTarget:solidColor];
        [picture addTarget:screenBlend];
        [picture processImage];
        resultImage = [screenBlend imageFromCurrentlyProcessedOutput];
        
    }
    
    return resultImage;
}

@end
