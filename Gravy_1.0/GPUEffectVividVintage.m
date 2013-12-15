//
//  GPUEffectVividVintage.m
//  Gravy_1.0
//
//  Created by SSC on 2013/12/15.
//  Copyright (c) 2013年 SSC. All rights reserved.
//

#import "GPUEffectVividVintage.h"

@implementation GPUEffectVividVintage

- (UIImage*)process
{
    UIImage* resultImage = self.imageToProcess;
    
    // Contrast
    @autoreleasepool {
        GPUImageContrastFilter* contrastFilter = [[GPUImageContrastFilter alloc] init];
        contrastFilter.contrast = 1.20f;
        
        resultImage = [self mergeBaseImage:resultImage overlayFilter:contrastFilter opacity:1.0f blendingMode:MergeBlendingModeNormal];
    }
    
    // Saturation
    @autoreleasepool {
        GPUImageSaturationFilter* saturationFilter = [[GPUImageSaturationFilter alloc] init];
        saturationFilter.saturation = 1.12f;
        
        resultImage = [self mergeBaseImage:resultImage overlayFilter:saturationFilter opacity:0.20f blendingMode:MergeBlendingModeNormal];
    }
    
    // Curve
    @autoreleasepool {
        GPUImageToneCurveFilter* curveFilter = [[GPUImageToneCurveFilter alloc] initWithACV:@"VividVintage1"];
        
        resultImage = [self mergeBaseImage:resultImage overlayFilter:curveFilter opacity:0.50f blendingMode:MergeBlendingModeNormal];
    }
    
    // Curve
    @autoreleasepool {
        GPUImageToneCurveFilter* curveFilter = [[GPUImageToneCurveFilter alloc] initWithACV:@"VividVintage2"];
        
        resultImage = [self mergeBaseImage:resultImage overlayFilter:curveFilter opacity:0.75f blendingMode:MergeBlendingModeNormal];
    }
    
    // Curve
    @autoreleasepool {
        GPUImageToneCurveFilter* curveFilter = [[GPUImageToneCurveFilter alloc] initWithACV:@"VividVintage3"];
        
        resultImage = [self mergeBaseImage:resultImage overlayFilter:curveFilter opacity:0.50f blendingMode:MergeBlendingModeSoftLight];
    }
    
    return resultImage;
}

@end
