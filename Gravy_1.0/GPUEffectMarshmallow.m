//
//  GPUEffectMarshmallow.m
//  Gravy_1.0
//
//  Created by SSC on 2013/12/15.
//  Copyright (c) 2013年 SSC. All rights reserved.
//

#import "GPUEffectMarshmallow.h"

@implementation GPUEffectMarshmallow

- (UIImage*)process
{
    UIImage* resultImage = self.imageToProcess;
    
    // Curve
    @autoreleasepool {
        GPUImageToneCurveFilter* curveFilter = [[GPUImageToneCurveFilter alloc] initWithACV:@"Marshmallow1"];
        
        resultImage = [self mergeBaseImage:resultImage overlayFilter:curveFilter opacity:1.0f blendingMode:MergeBlendingModeNormal];
    }
    
    // Fill Layer
    @autoreleasepool {
        GPUImageGradientColorGenerator* gradientColor = [[GPUImageGradientColorGenerator alloc] init];
        [gradientColor forceProcessingAtSize:CGSizeMake(resultImage.size.width, resultImage.size.height)];
        [gradientColor setStyle:GradientStyleRadial];
        [gradientColor setAngleDegree:90];
        [gradientColor setScalePercent:150];
        [gradientColor setOffsetX:0.0f Y:0.0f];
        [gradientColor addColorRed:244.0f Green:237.0f Blue:234.0f Opacity:100.0f Location:0 Midpoint:50];
        [gradientColor addColorRed:151.0f Green:161.0f Blue:205.0f Opacity:100.0f Location:1891 Midpoint:36];
        [gradientColor addColorRed:127.0f Green:125.0f Blue:239.0f Opacity:100.0f Location:3771 Midpoint:50];
        [gradientColor addColorRed:127.0f Green:125.0f Blue:239.0f Opacity:100.0f Location:4096 Midpoint:50];
        
        resultImage = [self mergeBaseImage:resultImage overlayFilter:gradientColor opacity:0.50f blendingMode:MergeBlendingModeSoftLight];
    }
    
    // Fill Layer
    @autoreleasepool {
        GPUImageSolidColorGenerator* solidColor = [[GPUImageSolidColorGenerator alloc] init];
        [solidColor setColorRed:90.0f/255.0f green:122.0f/255.0f blue:153.0f/255.0 alpha:1.0f];
        
        resultImage = [self mergeBaseImage:resultImage overlayFilter:solidColor opacity:0.30f blendingMode:MergeBlendingModeOverlay];
    }
    
    // Selective Color
    @autoreleasepool {
        GPUImageSelectiveColorFilter* selectiveColor = [[GPUImageSelectiveColorFilter alloc] init];
        [selectiveColor setYellowsCyan:2 Magenta:5 Yellow:-9 Black:0];
        [selectiveColor setCyansCyan:0 Magenta:0 Yellow:-1 Black:0];
        [selectiveColor setMagentasCyan:13 Magenta:-12 Yellow:0 Black:0];
        [selectiveColor setWhitesCyan:0 Magenta:0 Yellow:-30 Black:0];
        
        resultImage = [self mergeBaseImage:resultImage overlayFilter:selectiveColor opacity:1.0f blendingMode:MergeBlendingModeNormal];
    }
    
    // Fill Layer
    @autoreleasepool {
        GPUImageSolidColorGenerator* solidColor = [[GPUImageSolidColorGenerator alloc] init];
        [solidColor setColorRed:0.0f/255.0f green:8.0f/255.0f blue:28.0f/255.0 alpha:1.0f];
        
        resultImage = [self mergeBaseImage:resultImage overlayFilter:solidColor opacity:0.75f blendingMode:MergeBlendingModeExclusion];
    }
    
    // Selective Color
    @autoreleasepool {
        GPUImageSelectiveColorFilter* selectiveColor = [[GPUImageSelectiveColorFilter alloc] init];
        [selectiveColor setRedsCyan:0 Magenta:0 Yellow:-4 Black:0];
        [selectiveColor setMagentasCyan:0 Magenta:0 Yellow:1 Black:0];
        [selectiveColor setBlacksCyan:0 Magenta:0 Yellow:0 Black:10];
        
        resultImage = [self mergeBaseImage:resultImage overlayFilter:selectiveColor opacity:1.0f blendingMode:MergeBlendingModeNormal];
    }
    
    // Fill Layer
    @autoreleasepool {
        GPUImageSolidColorGenerator* solidColor = [[GPUImageSolidColorGenerator alloc] init];
        [solidColor setColorRed:235.0f/255.0f green:157.0f/255.0f blue:34.0f/255.0 alpha:1.0f];
        
        resultImage = [self mergeBaseImage:resultImage overlayFilter:solidColor opacity:0.50f blendingMode:MergeBlendingModeSoftLight];
    }
    
    // Fill Layer
    @autoreleasepool {
        GPUImageSolidColorGenerator* solidColor = [[GPUImageSolidColorGenerator alloc] init];
        [solidColor setColorRed:181.0f/255.0f green:187.0f/255.0f blue:238.0f/255.0 alpha:1.0f];
        
        resultImage = [self mergeBaseImage:resultImage overlayFilter:solidColor opacity:0.10f blendingMode:MergeBlendingModeOverlay];
    }
    
    // Fill Layer
    @autoreleasepool {
        GPUImageSolidColorGenerator* solidColor = [[GPUImageSolidColorGenerator alloc] init];
        [solidColor setColorRed:0.0f/255.0f green:24.0f/255.0f blue:42.0f/255.0 alpha:1.0f];
        
        resultImage = [self mergeBaseImage:resultImage overlayFilter:solidColor opacity:0.40f blendingMode:MergeBlendingModeExclusion];
    }
    
    return resultImage;
}

@end
