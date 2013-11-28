//
//  GPUEffectWeekend.m
//  Gravy_1.0
//
//  Created by SSC on 2013/11/28.
//  Copyright (c) 2013年 SSC. All rights reserved.
//

#import "GPUEffectWeekend.h"

@implementation GPUEffectWeekend

- (UIImage*)process
{
    UIImage* resultImage = self.imageToProcess;
    
    // Contrast
    @autoreleasepool {
        GPUImageContrastFilter* contrastFilter = [[GPUImageContrastFilter alloc] init];
        contrastFilter.contrast = 1.05;
        
        resultImage = [self mergeBaseImage:resultImage overlayFilter:contrastFilter opacity:1.0f blendingMode:MergeBlendingModeNormal];
    }
    
    // Hue / Saturation
    @autoreleasepool {
        GPUImageHueSaturationFilter* hueSaturation = [[GPUImageHueSaturationFilter alloc] init];
        hueSaturation.hue = 0.0f;
        hueSaturation.saturation = 3.0f;
        hueSaturation.lightness = -4.0;
        hueSaturation.colorize = NO;
        
        resultImage = [self mergeBaseImage:resultImage overlayFilter:hueSaturation opacity:1.0f blendingMode:MergeBlendingModeNormal];
    }
    
    // Levels
    @autoreleasepool {
        GPUImageLevelsFilter* levelsFilter = [[GPUImageLevelsFilter alloc] init];
        [levelsFilter setMin:10.0f/255.0f gamma:1.10f max:250.0f/255.0f minOut:0.0f maxOut:255.0f/255.0f];
        
        resultImage = [self mergeBaseImage:resultImage overlayFilter:levelsFilter opacity:1.0f blendingMode:MergeBlendingModeNormal];
    }
    
    // Fill Layer
    @autoreleasepool {
        GPUImageSolidColorGenerator* solidColor = [[GPUImageSolidColorGenerator alloc] init];
        [solidColor setColorRed:15.0f/255.0f green:35.0f/255.0f blue:65.0f/255.0 alpha:1.0f];
        
        resultImage = [self mergeBaseImage:resultImage overlayFilter:solidColor opacity:1.0f blendingMode:MergeBlendingModeExclusion];
    }
    
    
    // Levels
    @autoreleasepool {
        GPUImageLevelsFilter* levelsFilter = [[GPUImageLevelsFilter alloc] init];
        [levelsFilter setMin:0.0f gamma:1.0f max:1.0f minOut:0.0f maxOut:1.0f];
        [levelsFilter setRedMin:20.0f/255.0f gamma:1.30f max:240.0f/255.0f minOut:0.0f maxOut:255.0f/255.0f];
        
        resultImage = [self mergeBaseImage:resultImage overlayFilter:levelsFilter opacity:1.0f blendingMode:MergeBlendingModeNormal];
    }

    
    // Levels
    @autoreleasepool {
        GPUImageLevelsFilter* levelsFilter = [[GPUImageLevelsFilter alloc] init];
        [levelsFilter setMin:20.0f/255.0f gamma:0.90f max:220.0f/255.0f minOut:0.0f maxOut:255.0f/255.0f];
        
        resultImage = [self mergeBaseImage:resultImage overlayFilter:levelsFilter opacity:1.0f blendingMode:MergeBlendingModeNormal];
    }
    
    return resultImage;
}

@end
