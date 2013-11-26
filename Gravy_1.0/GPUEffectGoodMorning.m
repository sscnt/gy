//
//  GPUEffectGoodMorning.m
//  Gravy_1.0
//
//  Created by SSC on 2013/11/26.
//  Copyright (c) 2013年 SSC. All rights reserved.
//

#import "GPUEffectGoodMorning.h"

@implementation GPUEffectGoodMorning

- (UIImage*)process
{
    UIImage* resultImage = self.imageToProcess;
    
    // Curve
    @autoreleasepool {
        GPUImageToneCurveFilter* curveFilter = [[GPUImageToneCurveFilter alloc] initWithACV:@"Morning1"];
        
        resultImage = [self mergeBaseImage:resultImage overlayFilter:curveFilter opacity:1.0f blendingMode:MergeBlendingModeNormal];
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
        midtones.one = -25.0f/255.0f;
        midtones.two = 0.0f;
        midtones.three = 24.0f/255.0f;
        [colorBalance setMidtones:midtones];
        GPUVector3 highlights;
        highlights.one = 0.0f;
        highlights.two = 0.0f;
        highlights.three = 0.0f;
        [colorBalance setHighlights:highlights];
        colorBalance.preserveLuminosity = YES;
        
        resultImage = [self mergeBaseImage:resultImage overlayFilter:colorBalance opacity:0.90f blendingMode:MergeBlendingModeNormal];
    }
    
    // Curve
    @autoreleasepool {
        GPUImageToneCurveFilter* curveFilter = [[GPUImageToneCurveFilter alloc] initWithACV:@"Morning2"];
        
        resultImage = [self mergeBaseImage:resultImage overlayFilter:curveFilter opacity:1.0f blendingMode:MergeBlendingModeNormal];
    }
    
    // Duplicate
    @autoreleasepool {
        UIImage* solidImage = resultImage;
        
        GPUImageSolidColorGenerator* solidColor = [[GPUImageSolidColorGenerator alloc] init];
        [solidColor setColorRed:255.0f/255.0f green:204.0f/255.0f blue:153.0f/255.0 alpha:1.0f];
        
        solidImage = [self mergeBaseImage:solidImage overlayFilter:solidColor opacity:0.31f blendingMode:MergeBlendingModeMultiply];
        
        GPUImagePicture* basePicture = [[GPUImagePicture alloc] initWithImage:resultImage];
        GPUImagePicture* overlayPicture = [[GPUImagePicture alloc] initWithImage:solidImage];
        
        GPUImageOpacityFilter* opacityFilter = [[GPUImageOpacityFilter alloc] init];
        opacityFilter.opacity = 0.69f;
        
        GPUImageNormalBlendFilter* normalBlend = [[GPUImageNormalBlendFilter alloc] init];
        [opacityFilter addTarget:normalBlend atTextureLocation:1];
        [basePicture addTarget:normalBlend];
        [overlayPicture addTarget:opacityFilter];
        [basePicture processImage];
        [overlayPicture processImage];
        resultImage = [normalBlend imageFromCurrentlyProcessedOutput];
    }
    
    // Curve
    @autoreleasepool {
        GPUImageToneCurveFilter* curveFilter = [[GPUImageToneCurveFilter alloc] initWithACV:@"Morning3"];
        
        resultImage = [self mergeBaseImage:resultImage overlayFilter:curveFilter opacity:1.0f blendingMode:MergeBlendingModeNormal];
    }
    
    // Gradient Map
    @autoreleasepool {
        GPUImageGradientMapFilter* gradientMap = [[GPUImageGradientMapFilter alloc] init];
        [gradientMap addColorRed:255.0f Green:0.0f Blue:0.0f Opacity:1.0f Location:0 Midpoint:50];
        [gradientMap addColorRed:0.0f Green:255.0f Blue:255.0f Opacity:1.0f Location:4096 Midpoint:50];
        
        resultImage = [self mergeBaseImage:resultImage overlayFilter:gradientMap opacity:1.0f blendingMode:MergeBlendingModeNormal];
    }
    
    return resultImage;
}
    
@end
