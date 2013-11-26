//
//  GPUEffectSweetFlower.m
//  Gravy_1.0
//
//  Created by SSC on 2013/11/12.
//  Copyright (c) 2013年 SSC. All rights reserved.
//

#import "GPUEffectSweetFlower.h"

@implementation GPUEffectSweetFlower


- (UIImage*)process
{
    UIImage* resultImage = self.imageToProcess;
    UIImage* solidImage = self.imageToProcess;
    
    
    // Selective Color
    @autoreleasepool {
        GPUImageSelectiveColorFilter* selectiveColor = [[GPUImageSelectiveColorFilter alloc] init];
        [selectiveColor setRedsCyan:-22 Magenta:16 Yellow:33 Black:0];
        [selectiveColor setYellowsCyan:-45 Magenta:6 Yellow:32 Black:0];
        [selectiveColor setGreensCyan:4 Magenta:21 Yellow:-13 Black:0];
        [selectiveColor setCyansCyan:-2 Magenta:-2 Yellow:29 Black:0];
        [selectiveColor setNeutralsCyan:-20 Magenta:4 Yellow:7 Black:0];
        
        solidImage = [self mergeBaseImage:solidImage overlayFilter:selectiveColor opacity:1.0f blendingMode:MergeBlendingModeNormal];
    }
    
    
    // Curve
    @autoreleasepool {
        GPUImageToneCurveFilter* curveFilter = [[GPUImageToneCurveFilter alloc] initWithACV:@"Sweet1"];
        
        solidImage = [self mergeBaseImage:solidImage overlayFilter:curveFilter opacity:1.0f blendingMode:MergeBlendingModeNormal];
    }
    
    // Selective Color
    @autoreleasepool {
        GPUImageSelectiveColorFilter* selectiveColor = [[GPUImageSelectiveColorFilter alloc] init];
        [selectiveColor setRedsCyan:14 Magenta:1 Yellow:4 Black:0];
        [selectiveColor setYellowsCyan:2 Magenta:-10 Yellow:-11 Black:0];
        
        solidImage = [self mergeBaseImage:solidImage overlayFilter:selectiveColor opacity:1.0f blendingMode:MergeBlendingModeNormal];
    }
    
    
    // Fill Layer
    @autoreleasepool {
        GPUImageSolidColorGenerator* solidColor = [[GPUImageSolidColorGenerator alloc] init];
        [solidColor setColorRed:0.0f green:11.0f/255.0f blue:50.0f/255.0 alpha:1.0f];
        
        solidImage = [self mergeBaseImage:solidImage overlayFilter:solidColor opacity:0.30f blendingMode:MergeBlendingModeExclusion];
    }
    
    // Fill Layer
    @autoreleasepool {
        GPUImageSolidColorGenerator* solidColor = [[GPUImageSolidColorGenerator alloc] init];
        [solidColor setColorRed:29.0f/255.0f green:137.0f/255.0f blue:212.0f/255.0 alpha:1.0f];
        
        solidImage = [self mergeBaseImage:solidImage overlayFilter:solidColor opacity:0.15f blendingMode:MergeBlendingModeExclusion];
    }
    


    // Color Balance
    @autoreleasepool {
        GPUImageColorBalanceFilter* colorBalance = [[GPUImageColorBalanceFilter alloc] init];
        GPUVector3 shadows;
        shadows.one = 0.0f;
        shadows.two = 0.0f;
        shadows.three = 0.0f;
        [colorBalance setShadows:shadows];
        GPUVector3 midtones;
        midtones.one = -10.0f/255.0f;
        midtones.two = 0.0f;
        midtones.three = 23.0f/255.0f;
        [colorBalance setMidtones:midtones];
        GPUVector3 highlights;
        highlights.one = 0.0f;
        highlights.two = 0.0f;
        highlights.three = 0.0f;
        [colorBalance setHighlights:highlights];
        colorBalance.preserveLuminosity = YES;
        
        solidImage = [self mergeBaseImage:solidImage overlayFilter:colorBalance opacity:0.90f blendingMode:MergeBlendingModeNormal];
    }
    
    // Selective Color
    @autoreleasepool {
        GPUImageSelectiveColorFilter* selectiveColor = [[GPUImageSelectiveColorFilter alloc] init];
        [selectiveColor setRedsCyan:5 Magenta:0 Yellow:0 Black:0];
        [selectiveColor setYellowsCyan:9 Magenta:10 Yellow:3 Black:0];
        [selectiveColor setNeutralsCyan:-4 Magenta:-9 Yellow:-14 Black:0];
        
        solidImage = [self mergeBaseImage:solidImage overlayFilter:selectiveColor opacity:1.0f blendingMode:MergeBlendingModeNormal];
    }
    
    
    // Curve
    @autoreleasepool {
        GPUImageToneCurveFilter* curveFilter = [[GPUImageToneCurveFilter alloc] initWithACV:@"Sweet2"];
        
        solidImage = [self mergeBaseImage:solidImage overlayFilter:curveFilter opacity:1.0f blendingMode:MergeBlendingModeNormal];
    }
    
    // Merge
    @autoreleasepool {
        GPUImagePicture* basePicture = [[GPUImagePicture alloc] initWithImage:resultImage];
        GPUImagePicture* overlayPicture = [[GPUImagePicture alloc] initWithImage:solidImage];
        
        GPUImageOpacityFilter* opacityFilter = [[GPUImageOpacityFilter alloc] init];
        opacityFilter.opacity = 0.80f;
        [overlayPicture addTarget:opacityFilter];
        
        GPUImageNormalBlendFilter* normalBlend = [[GPUImageNormalBlendFilter alloc] init];
        [basePicture addTarget:normalBlend];
        [opacityFilter addTarget:normalBlend atTextureLocation:1];
        
        [basePicture processImage];
        [overlayPicture processImage];
        
        resultImage = [normalBlend imageFromCurrentlyProcessedOutput];
    }
    
    return  resultImage;
}
@end
