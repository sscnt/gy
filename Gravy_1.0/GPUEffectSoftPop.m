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
        [selectiveColor setRedsCyan:0 Magenta:0 Yellow:0 Black:0];
        [selectiveColor setYellowsCyan:0 Magenta:0 Yellow:0 Black:0];
        [selectiveColor setGreensCyan:0 Magenta:0 Yellow:0 Black:0];
        [selectiveColor setCyansCyan:0 Magenta:0 Yellow:0 Black:0];
        [selectiveColor setBluesCyan:0 Magenta:0 Yellow:0 Black:0];
        [selectiveColor setMagentasCyan:0 Magenta:0 Yellow:0 Black:0];
        [selectiveColor setWhitesCyan:-100 Magenta:100 Yellow:0 Black:100];
        [selectiveColor setNeutralsCyan:0 Magenta:0 Yellow:0 Black:0];
        [selectiveColor setBlacksCyan:0 Magenta:0 Yellow:0 Black:0];
        GPUImagePicture* pictureOriginal = [[GPUImagePicture alloc] initWithImage:resultImage];
        [pictureOriginal addTarget:selectiveColor];
        [pictureOriginal processImage];
        resultImage = [selectiveColor imageFromCurrentlyProcessedOutput];
    }
    
    return resultImage;
}

@end
