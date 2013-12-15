//
//  GPUEffectSoftGlare.m
//  Gravy_1.0
//
//  Created by SSC on 2013/12/15.
//  Copyright (c) 2013年 SSC. All rights reserved.
//

#import "GPUEffectSoftGlare.h"

@implementation GPUEffectSoftGlare

- (UIImage*)process
{
    UIImage* resultImage = self.imageToProcess;
    
    // Curve
    @autoreleasepool {
        GPUImageToneCurveFilter* curveFilter = [[GPUImageToneCurveFilter alloc] initWithACV:@"SoftGlare1"];
        
        resultImage = [self mergeBaseImage:resultImage overlayFilter:curveFilter opacity:1.0f blendingMode:MergeBlendingModeNormal];
    }
    
    // Fill Layer
    @autoreleasepool {
        GPUImageSolidColorGenerator* solidColor = [[GPUImageSolidColorGenerator alloc] init];
        [solidColor setColorRed:228.0f/255.0f green:170.0f/255.0f blue:237.0f/255.0f alpha:1.0f];
        
        resultImage = [self mergeBaseImage:resultImage overlayFilter:solidColor opacity:0.15 blendingMode:MergeBlendingModeOverlay];
    }
    
    // Fill Layer
    @autoreleasepool {
        GPUImageSolidColorGenerator* solidColor = [[GPUImageSolidColorGenerator alloc] init];
        [solidColor setColorRed:142.0f/255.0f green:49.0f/255.0f blue:201.0f/255.0f alpha:1.0f];
        
        resultImage = [self mergeBaseImage:resultImage overlayFilter:solidColor opacity:0.16f blendingMode:MergeBlendingModeOverlay];
    }
    
    // Fill Layer
    @autoreleasepool {
        GPUImageSolidColorGenerator* solidColor = [[GPUImageSolidColorGenerator alloc] init];
        [solidColor setColorRed:251.0f/255.0f green:215.0f/255.0f blue:93.0f/255.0f alpha:1.0f];
        
        resultImage = [self mergeBaseImage:resultImage overlayFilter:solidColor opacity:0.07f blendingMode:MergeBlendingModeOverlay];
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
        midtones.three = 16.0f/255.0f;
        [colorBalance setMidtones:midtones];
        GPUVector3 highlights;
        highlights.one = 0.0f/255.0f;
        highlights.two = 0.0f/255.0f;
        highlights.three = -16.0f/155.0f;
        [colorBalance setHighlights:highlights];
        colorBalance.preserveLuminosity = YES;
        
        resultImage = [self mergeBaseImage:resultImage overlayFilter:colorBalance opacity:1.0f blendingMode:MergeBlendingModeNormal];
    }
    
    // Fill Layer
    @autoreleasepool {
        GPUImageGradientColorGenerator* gradientColor = [[GPUImageGradientColorGenerator alloc] init];
        [gradientColor forceProcessingAtSize:CGSizeMake(resultImage.size.width, resultImage.size.height)];
        [gradientColor setStyle:GradientStyleRadial];
        [gradientColor setAngleDegree:90];
        [gradientColor setScalePercent:150];
        [gradientColor setOffsetX:7.0f Y:-46.0f];
        [gradientColor addColorRed:246.0f Green:238.0f Blue:210.0f Opacity:100.0f Location:0 Midpoint:50];
        [gradientColor addColorRed:246.0f Green:238.0f Blue:210.0f Opacity:100.0f Location:85 Midpoint:50];
        [gradientColor addColorRed:255.0f Green:228.0f Blue:135.0f Opacity:93.0f Location:1027 Midpoint:50];
        [gradientColor addColorRed:250.0f Green:204.0f Blue:47.0f Opacity:0.0f Location:4096 Midpoint:50];
        
        resultImage = [self mergeBaseImage:resultImage overlayFilter:gradientColor opacity:1.0f blendingMode:MergeBlendingModeScreen];
        resultImage = [self mergeBaseImage:resultImage overlayFilter:gradientColor opacity:0.15f blendingMode:MergeBlendingModeMultiply];
        resultImage = [self mergeBaseImage:resultImage overlayFilter:gradientColor opacity:0.03f blendingMode:MergeBlendingModeVividLight];
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
        midtones.three = 9.0f/255.0f;
        [colorBalance setMidtones:midtones];
        GPUVector3 highlights;
        highlights.one = 0.0f/255.0f;
        highlights.two = 0.0f/255.0f;
        highlights.three = 0.0f/155.0f;
        [colorBalance setHighlights:highlights];
        colorBalance.preserveLuminosity = YES;
        
        resultImage = [self mergeBaseImage:resultImage overlayFilter:colorBalance opacity:1.0f blendingMode:MergeBlendingModeNormal];
    }
    
    
    // Contrast
    @autoreleasepool {
        GPUImageContrastFilter* contrastFilter = [[GPUImageContrastFilter alloc] init];
        contrastFilter.contrast = 1.05;
        
        resultImage = [self mergeBaseImage:resultImage overlayFilter:contrastFilter opacity:1.0f blendingMode:MergeBlendingModeNormal];
    }
    
    return resultImage;
}

@end
