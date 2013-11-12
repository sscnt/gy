//
//  GPUEffectSoftPop.m
//  Gravy_1.0
//
//  Created by SSC on 2013/11/04.
//  Copyright (c) 2013年 SSC. All rights reserved.
//

#import "GPUEffectSoftPop.h"

@implementation GPUEffectSoftPop

- (UIImage*)process
{
    UIImage* resultImage = self.imageToProcess;
    UIImage* solidImage;
    
    // Tonecurve
    @autoreleasepool {
        GPUImageToneCurveFilter* toneFilter = [[GPUImageToneCurveFilter alloc] initWithACV:@"GPUSoftPopCurve01"];
        GPUImagePicture* pictureOriginal = [[GPUImagePicture alloc] initWithImage:resultImage];
        [pictureOriginal addTarget:toneFilter];
        [pictureOriginal processImage];
        resultImage = [toneFilter imageFromCurrentlyProcessedOutput];
    }
    
    // Gradient Fill
    @autoreleasepool {
        GPUImageGradientColorGenerator* gradientGenerator = [[GPUImageGradientColorGenerator alloc] init];
        [gradientGenerator setAngleDegree:242.7f];
        [gradientGenerator setScalePercent:150.0f];
        [gradientGenerator setOffsetX:25.4f Y:-60.4f];
        [gradientGenerator addColorRed:255.0f Green:255.0f Blue:255.0f Opacity:100.0f Location:0 Midpoint:50];
        [gradientGenerator addColorRed:45.004f Green:53.004f Blue:34.0f Opacity:0.0f Location:4096 Midpoint:50];
        
        // Opacity
        GPUImageOpacityFilter* opacityFilter = [[GPUImageOpacityFilter alloc] init];
        opacityFilter.opacity = 0.70f;
        [gradientGenerator addTarget:opacityFilter];
        
        // Overlay
        GPUImageOverlayBlendFilter* overlayFilter = [[GPUImageOverlayBlendFilter alloc] init];
        [opacityFilter addTarget:overlayFilter atTextureLocation:1];
        
        // Merge
        GPUImagePicture* pictureOriginal = [[GPUImagePicture alloc] initWithImage:resultImage];
        [pictureOriginal addTarget:overlayFilter];
        [pictureOriginal addTarget:gradientGenerator];
        [pictureOriginal processImage];
        resultImage = [overlayFilter imageFromCurrentlyProcessedOutput];
        
    }
    
    // Selective Color
    @autoreleasepool {
        GPUImageSelectiveColorFilter* selectiveColor = [[GPUImageSelectiveColorFilter alloc] init];
        [selectiveColor setYellowsCyan:0 Magenta:5 Yellow:-9 Black:0];
        [selectiveColor setCyansCyan:0 Magenta:0 Yellow:-1 Black:0];
        [selectiveColor setMagentasCyan:13 Magenta:-12 Yellow:12 Black:0];
        [selectiveColor setWhitesCyan:0 Magenta:0 Yellow:-30 Black:0];
        GPUImagePicture* pictureOriginal = [[GPUImagePicture alloc] initWithImage:resultImage];
        [pictureOriginal addTarget:selectiveColor];
        [pictureOriginal processImage];
        resultImage = [selectiveColor imageFromCurrentlyProcessedOutput];
    }
    
    // Fill Layer
    @autoreleasepool {
        GPUImageSolidColorGenerator* solidColor = [[GPUImageSolidColorGenerator alloc] init];
        [solidColor setColorRed:0.0f green:8.0f/255.0f blue:28.0f/255.0f alpha:1.0f];
        GPUImageExclusionBlendFilter* exclusionFilter = [[GPUImageExclusionBlendFilter alloc] init];
        GPUImagePicture* pictureOriginal = [[GPUImagePicture alloc] initWithImage:resultImage];
        [solidColor addTarget:exclusionFilter];
        [pictureOriginal addTarget:exclusionFilter];
        [pictureOriginal addTarget:solidColor];
        [pictureOriginal processImage];
        resultImage = [exclusionFilter imageFromCurrentlyProcessedOutput];
    }
    
    // Fill Layer
    @autoreleasepool {
        GPUImageSolidColorGenerator* solidColor = [[GPUImageSolidColorGenerator alloc] init];
        [solidColor setColorRed:207.0f/255.0f green:224.0f/255.0f blue:1.0f alpha:1.0f];
        GPUImageSoftLightBlendFilter* softlightFilter = [[GPUImageSoftLightBlendFilter alloc] init];
        GPUImageOpacityFilter* opacityFilter = [[GPUImageOpacityFilter alloc] init];
        opacityFilter.opacity = 0.40f;
        [solidColor addTarget:opacityFilter];
        [opacityFilter addTarget:softlightFilter];
        GPUImagePicture* pictureOriginal = [[GPUImagePicture alloc] initWithImage:resultImage];
        [pictureOriginal addTarget:softlightFilter];
        [pictureOriginal addTarget:solidColor];
        [pictureOriginal processImage];
        resultImage = [softlightFilter imageFromCurrentlyProcessedOutput];
    }
    
    // Fill Layer
    @autoreleasepool {
        GPUImageSolidColorGenerator* solidColor = [[GPUImageSolidColorGenerator alloc] init];
        [solidColor setColorRed:236.0f/255.0f green:158.0f/255.0f blue:34.0f/255.0f alpha:1.0f];
        GPUImageSoftLightBlendFilter* softlightFilter = [[GPUImageSoftLightBlendFilter alloc] init];
        GPUImageOpacityFilter* opacityFilter = [[GPUImageOpacityFilter alloc] init];
        opacityFilter.opacity = 0.50f;
        [solidColor addTarget:opacityFilter];
        [opacityFilter addTarget:softlightFilter];
        GPUImagePicture* pictureOriginal = [[GPUImagePicture alloc] initWithImage:resultImage];
        [pictureOriginal addTarget:softlightFilter];
        [pictureOriginal addTarget:solidColor];
        [pictureOriginal processImage];
        resultImage = [softlightFilter imageFromCurrentlyProcessedOutput];
    }
    
    return resultImage;
}

@end
