//
//  GPUEffectFaerieVintage.m
//  Gravy_1.0
//
//  Created by SSC on 2013/12/15.
//  Copyright (c) 2013年 SSC. All rights reserved.
//

#import "GPUEffectFaerieVintage.h"

@implementation GPUEffectFaerieVintage

- (UIImage*)process
{
    UIImage* resultImage = self.imageToProcess;
    
    // Fill Layer
    @autoreleasepool {
        GPUImageSolidColorGenerator* solidColor = [[GPUImageSolidColorGenerator alloc] init];
        [solidColor setColorRed:114.0f/255.0f green:87.0f/255.0f blue:71.0f/255.0 alpha:1.0f];
        
        resultImage = [self mergeBaseImage:resultImage overlayFilter:solidColor opacity:0.35f blendingMode:MergeBlendingModeColor];
    }
    
    // Fill Layer
    @autoreleasepool {
        GPUImageSolidColorGenerator* solidColor = [[GPUImageSolidColorGenerator alloc] init];
        [solidColor setColorRed:202.0f/255.0f green:179.0f/255.0f blue:154.0f/255.0 alpha:1.0f];
        
        resultImage = [self mergeBaseImage:resultImage overlayFilter:solidColor opacity:0.10f blendingMode:MergeBlendingModeSoftLight];
    }
    
    // Curve
    @autoreleasepool {
        GPUImageToneCurveFilter* curveFilter = [[GPUImageToneCurveFilter alloc] initWithACV:@"FaerieVintage"];
        
        resultImage = [self mergeBaseImage:resultImage overlayFilter:curveFilter opacity:0.40f blendingMode:MergeBlendingModeNormal];
    }
    

    
    return resultImage;
}

@end
