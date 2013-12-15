//
//  GPUEffectLeakLight.m
//  Gravy_1.0
//
//  Created by SSC on 2013/12/15.
//  Copyright (c) 2013年 SSC. All rights reserved.
//

#import "GPUEffectLeakLight.h"

@implementation GPUEffectLeakLight

- (UIImage*)process
{
    UIImage* resultImage = self.imageToProcess;
    
    // Curve
    @autoreleasepool {
        GPUImageToneCurveFilter* curveFilter = [[GPUImageToneCurveFilter alloc] initWithACV:@"LeakLight1"];
        
        resultImage = [self mergeBaseImage:resultImage overlayFilter:curveFilter opacity:1.0f blendingMode:MergeBlendingModeNormal];
    }
    
    // Fill Layer
    @autoreleasepool {
        GPUImageSolidColorGenerator* solidColor = [[GPUImageSolidColorGenerator alloc] init];
        [solidColor setColorRed:104.0f/255.0f green:22.0f/255.0f blue:22.0f/255.0 alpha:1.0f];
        
        resultImage = [self mergeBaseImage:resultImage overlayFilter:solidColor opacity:0.42f blendingMode:MergeBlendingModeSoftLight];
    }
    
    // Fill Layer
    @autoreleasepool {
        GPUImageSolidColorGenerator* solidColor = [[GPUImageSolidColorGenerator alloc] init];
        [solidColor setColorRed:16.0f/255.0f green:79.0f/255.0f blue:151.0f/255.0 alpha:1.0f];
        
        resultImage = [self mergeBaseImage:resultImage overlayFilter:solidColor opacity:0.26f blendingMode:MergeBlendingModeExclusion];
    }
    
    // Contrast
    @autoreleasepool {
        GPUImageContrastFilter* contrastFilter = [[GPUImageContrastFilter alloc] init];
        contrastFilter.contrast = 1.3f;
        
        resultImage = [self mergeBaseImage:resultImage overlayFilter:contrastFilter opacity:1.0f blendingMode:MergeBlendingModeNormal];
    }

    // Fill Layer
    @autoreleasepool {
        GPUImageSolidColorGenerator* solidColor = [[GPUImageSolidColorGenerator alloc] init];
        [solidColor setColorRed:254.0f/255.0f green:229.0f/255.0f blue:181.0f/255.0 alpha:1.0f];
        
        resultImage = [self mergeBaseImage:resultImage overlayFilter:solidColor opacity:0.07f blendingMode:MergeBlendingModeVividLight];
    }
    
    // Fill Layer
    @autoreleasepool {
        GPUImageSolidColorGenerator* solidColor = [[GPUImageSolidColorGenerator alloc] init];
        [solidColor setColorRed:50.0f/255.0f green:208.0f/255.0f blue:87.0f/255.0 alpha:1.0f];
        
        resultImage = [self mergeBaseImage:resultImage overlayFilter:solidColor opacity:0.02f blendingMode:MergeBlendingModeExclusion];
    }
    
    // Color Balance
    @autoreleasepool {
        GPUImageColorBalanceFilter* colorBalance = [[GPUImageColorBalanceFilter alloc] init];
        GPUVector3 shadows;
        shadows.one = 3.0f/255.0f;
        shadows.two = -9.0f/255.0f;
        shadows.three = 15.0f/255.0f;
        [colorBalance setShadows:shadows];
        GPUVector3 midtones;
        midtones.one = 0.0f/255.0f;
        midtones.two = 0.0f/255.0f;
        midtones.three = -1.0f/255.0f;
        [colorBalance setMidtones:midtones];
        GPUVector3 highlights;
        highlights.one = 0.0f/255.0f;
        highlights.two = 0.0f/255.0f;
        highlights.three = 0.0f/255.0f;
        [colorBalance setHighlights:highlights];
        colorBalance.preserveLuminosity = YES;
        
        resultImage = [self mergeBaseImage:resultImage overlayFilter:colorBalance opacity:1.0f blendingMode:MergeBlendingModeNormal];
    }
    
    // Fill Layer
    @autoreleasepool {
        GPUImageGradientColorGenerator* gradientColor = [[GPUImageGradientColorGenerator alloc] init];
        [gradientColor forceProcessingAtSize:CGSizeMake(resultImage.size.width, resultImage.size.height)];
        [gradientColor setStyle:GradientStyleLinear];
        [gradientColor setAngleDegree:90];
        [gradientColor setScalePercent:100];
        [gradientColor setOffsetX:0.0f Y:25.0f];
        [gradientColor addColorRed:255.0f Green:253.0f Blue:225.0f Opacity:100.0f Location:0 Midpoint:50];
        [gradientColor addColorRed:255.0f Green:253.0f Blue:225.0f Opacity:99.2f Location:32 Midpoint:50];
        [gradientColor addColorRed:255.0f Green:248.0f Blue:147.0f Opacity:56.6f Location:1778 Midpoint:50];
        [gradientColor addColorRed:255.0f Green:194.0f Blue:76.0f Opacity:17.5f Location:3376 Midpoint:50];
        [gradientColor addColorRed:171.0f Green:17.0f Blue:185.0f Opacity:0.0f Location:4096 Midpoint:50];
        
        resultImage = [self mergeBaseImage:resultImage overlayFilter:gradientColor opacity:0.09 blendingMode:MergeBlendingModeVividLight];
    }
    
    // Fill Layer
    @autoreleasepool {
        GPUImageGradientColorGenerator* gradientColor = [[GPUImageGradientColorGenerator alloc] init];
        [gradientColor forceProcessingAtSize:CGSizeMake(resultImage.size.width, resultImage.size.height)];
        [gradientColor setStyle:GradientStyleLinear];
        [gradientColor setAngleDegree:2];
        [gradientColor setScalePercent:116];
        [gradientColor setOffsetX:-47.0f Y:40.0f];
        [gradientColor addColorRed:255.0f Green:0.0f Blue:0.0f Opacity:90.0f Location:0 Midpoint:50];
        [gradientColor addColorRed:255.0f Green:0.0f Blue:90.0f Opacity:55.0f Location:2667 Midpoint:50];
        [gradientColor addColorRed:242.0f Green:8.0f Blue:117.0f Opacity:0.0f Location:4096 Midpoint:50];
        
        resultImage = [self mergeBaseImage:resultImage overlayFilter:gradientColor opacity:1.0f blendingMode:MergeBlendingModeScreen];
    }
    
    // Fill Layer
    @autoreleasepool {
        GPUImageGradientColorGenerator* gradientColor = [[GPUImageGradientColorGenerator alloc] init];
        [gradientColor forceProcessingAtSize:CGSizeMake(resultImage.size.width, resultImage.size.height)];
        [gradientColor setStyle:GradientStyleReflected];
        [gradientColor setAngleDegree:-177];
        [gradientColor setScalePercent:20];
        [gradientColor setOffsetX:25.0f Y:34.0f];
        [gradientColor addColorRed:255.0f Green:0.0f Blue:0.0f Opacity:90.0f Location:0 Midpoint:50];
        [gradientColor addColorRed:255.0f Green:0.0f Blue:90.0f Opacity:50.0f Location:2551 Midpoint:50];
        [gradientColor addColorRed:242.0f Green:8.0f Blue:117.0f Opacity:0.0f Location:4096 Midpoint:50];
        
        resultImage = [self mergeBaseImage:resultImage overlayFilter:gradientColor opacity:1.0f blendingMode:MergeBlendingModeScreen];
    }
    
    
    // Color Balance
    @autoreleasepool {
        GPUImageColorBalanceFilter* colorBalance = [[GPUImageColorBalanceFilter alloc] init];
        GPUVector3 shadows;
        shadows.one = 0.0f/255.0f;
        shadows.two = 0.0f/255.0f;
        shadows.three = 0.0f/255.0f;
        [colorBalance setShadows:shadows];
        GPUVector3 midtones;
        midtones.one = 0.0f/255.0f;
        midtones.two = 0.0f/255.0f;
        midtones.three = 0.0f/255.0f;
        [colorBalance setMidtones:midtones];
        GPUVector3 highlights;
        highlights.one = -6.0f/255.0f;
        highlights.two = 0.0f/255.0f;
        highlights.three = -22.0f/255.0f;
        [colorBalance setHighlights:highlights];
        colorBalance.preserveLuminosity = YES;
        
        resultImage = [self mergeBaseImage:resultImage overlayFilter:colorBalance opacity:1.0f blendingMode:MergeBlendingModeNormal];
    }
    
    return resultImage;

}

@end
