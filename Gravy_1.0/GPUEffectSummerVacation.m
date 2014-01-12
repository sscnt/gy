//
//  GPUEffectSummerVacation.m
//  Gravy_1.0
//
//  Created by SSC on 2014/01/12.
//  Copyright (c) 2014年 SSC. All rights reserved.
//

#import "GPUEffectSummerVacation.h"
#import "GPUAdjustmentsSaturation.h"

@implementation GPUEffectSummerVacation
- (UIImage*)process
{
    UIImage* resultImage = self.imageToProcess;
    
    
    // Curve
    @autoreleasepool {
        GPUImageToneCurveFilter* curveFilter = [[GPUImageToneCurveFilter alloc] initWithACV:@"SummerVacation1"];
        
        resultImage = [self mergeBaseImage:resultImage overlayFilter:curveFilter opacity:1.0f blendingMode:MergeBlendingModeNormal];
    }
    
    
    // Vibrance
    @autoreleasepool {
        GPUAdjustmentsSaturation* saturationFilter = [[GPUAdjustmentsSaturation alloc] init];
        saturationFilter.saturation = 0.5f;
        
        resultImage = [self mergeBaseImage:resultImage overlayFilter:saturationFilter opacity:1.0f blendingMode:MergeBlendingModeNormal];
    }
    
    // Selective Color
    @autoreleasepool {
        GPUImageSelectiveColorFilter* selectiveColor = [[GPUImageSelectiveColorFilter alloc] init];
        [selectiveColor setRedsCyan:-31 Magenta:11 Yellow:7 Black:8];
        [selectiveColor setGreensCyan:8 Magenta:-12 Yellow:29 Black:4];
        [selectiveColor setCyansCyan:3 Magenta:-16 Yellow:-5 Black:-32];
        [selectiveColor setNeutralsCyan:4 Magenta:-4 Yellow:5 Black:0];
        
        resultImage = [self mergeBaseImage:resultImage overlayFilter:selectiveColor opacity:1.0f blendingMode:MergeBlendingModeNormal];
    }
    
    // Curve
    @autoreleasepool {
        GPUImageToneCurveFilter* curveFilter = [[GPUImageToneCurveFilter alloc] initWithACV:@"SummerVacation2"];
        
        resultImage = [self mergeBaseImage:resultImage overlayFilter:curveFilter opacity:1.0f blendingMode:MergeBlendingModeNormal];
    }
    
    
    // Fill Layer
    @autoreleasepool {
        GPUImageGradientColorGenerator* gradientColor = [[GPUImageGradientColorGenerator alloc] init];
        [gradientColor forceProcessingAtSize:CGSizeMake(resultImage.size.width, resultImage.size.height)];
        [gradientColor setStyle:GradientStyleLinear];
        [gradientColor setAngleDegree:-125];
        [gradientColor setScalePercent:66];
        [gradientColor setOffsetX:0.0f Y:0.0f];
        [gradientColor addColorRed:255.0f Green:158.0f Blue:65.0f Opacity:100.0f Location:0 Midpoint:50];
        [gradientColor addColorRed:251.0f Green:230.0f Blue:180.0f Opacity:100.0f Location:4096 Midpoint:50];
        
        resultImage = [self mergeBaseImage:resultImage overlayFilter:gradientColor opacity:0.25f blendingMode:MergeBlendingModeSoftLight];
    }
    
    
    // Fill Layer
    @autoreleasepool {
        GPUImageGradientColorGenerator* gradientColor = [[GPUImageGradientColorGenerator alloc] init];
        [gradientColor forceProcessingAtSize:CGSizeMake(resultImage.size.width, resultImage.size.height)];
        [gradientColor setStyle:GradientStyleRadial];
        [gradientColor setAngleDegree:50.0f];
        [gradientColor setScalePercent:100];
        [gradientColor setOffsetX:-30.0f Y:-30.0f];
        [gradientColor addColorRed:255.0f Green:64.0f Blue:64.0f Opacity:100.0f Location:0 Midpoint:50];
        [gradientColor addColorRed:251.0f Green:64.0f Blue:64.0f Opacity:0.0f Location:4096 Midpoint:50];
        
        resultImage = [self mergeBaseImage:resultImage overlayFilter:gradientColor opacity:0.31f blendingMode:MergeBlendingModeScreen];
    }
    
    // Fill Layer
    @autoreleasepool {
        GPUImageGradientColorGenerator* gradientColor = [[GPUImageGradientColorGenerator alloc] init];
        [gradientColor forceProcessingAtSize:CGSizeMake(resultImage.size.width, resultImage.size.height)];
        [gradientColor setStyle:GradientStyleLinear];
        [gradientColor setAngleDegree:-140];
        [gradientColor setScalePercent:100];
        [gradientColor setOffsetX:0.0f Y:0.0f];
        [gradientColor addColorRed:241.0f Green:252.0f Blue:120.0f Opacity:100.0f Location:0 Midpoint:50];
        [gradientColor addColorRed:241.0f Green:252.0f Blue:120.0f Opacity:0.0f Location:4096 Midpoint:50];
        
        resultImage = [self mergeBaseImage:resultImage overlayFilter:gradientColor opacity:0.12f blendingMode:MergeBlendingModeScreen];
    }

    
    return resultImage;
    
    // Paind Daubs
    @autoreleasepool {
        GPUImageSharpenFilter* unsharp = [[GPUImageSharpenFilter alloc] init];
        unsharp.sharpness = 0.5f;
        resultImage = [self mergeBaseImage:resultImage overlayFilter:unsharp opacity:1.0f blendingMode:MergeBlendingModeNormal];
    }
    
    
    
    // Hue / Saturation
    @autoreleasepool {
        GPUImageHueSaturationFilter* hueSaturation = [[GPUImageHueSaturationFilter alloc] init];
        hueSaturation.hue = 0.0f;
        hueSaturation.saturation = -30.0f;
        hueSaturation.lightness = 0.0f;
        hueSaturation.colorize =  NO;
        
        resultImage = [self mergeBaseImage:resultImage overlayFilter:hueSaturation opacity:1.0f blendingMode:MergeBlendingModeNormal];
    }
    
    // Curve
    @autoreleasepool {
        GPUImageToneCurveFilter* curveFilter = [[GPUImageToneCurveFilter alloc] initWithACV:@"Girder2"];
        
        resultImage = [self mergeBaseImage:resultImage overlayFilter:curveFilter opacity:1.0f blendingMode:MergeBlendingModeNormal];
    }
    
    // Photo Filter
    @autoreleasepool {
        GPUPhotoFilter* photoFilter = [[GPUPhotoFilter alloc] init];
        [photoFilter setRed:255.0f/255.0f Green:213.0f/255.0f Blue:0.0f];
        photoFilter.strength = 10.0f;
        resultImage = [self mergeBaseImage:resultImage overlayFilter:photoFilter opacity:1.0f blendingMode:MergeBlendingModeNormal];
    }
    
    // Fill Layer
    @autoreleasepool {
        GPUImageSolidColorGenerator* solidColor = [[GPUImageSolidColorGenerator alloc] init];
        [solidColor setColorRed:40.0f/255.0f green:40.0f/255.0f blue:40.0f/255.0 alpha:1.0f];
        
        resultImage = [self mergeBaseImage:resultImage overlayFilter:solidColor opacity:1.0f blendingMode:MergeBlendingModeLighten];
    }
    
    // Curve
    @autoreleasepool {
        GPUImageToneCurveFilter* curveFilter = [[GPUImageToneCurveFilter alloc] initWithACV:@"Girder3"];
        
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
        midtones.one = -10.0f/255.0f;
        midtones.two = 0.0f/255.0f;
        midtones.three = 30.0f/255.0f;
        [colorBalance setMidtones:midtones];
        GPUVector3 highlights;
        highlights.one = 0.0f/255.0f;
        highlights.two = 0.0f/255.0f;
        highlights.three = 0.0f/255.0f;
        [colorBalance setHighlights:highlights];
        colorBalance.preserveLuminosity = YES;
        
        resultImage = [self mergeBaseImage:resultImage overlayFilter:colorBalance opacity:1.0f blendingMode:MergeBlendingModeNormal];
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
        midtones.one = 45.0f/255.0f;
        midtones.two = 0.0f/255.0f;
        midtones.three = -60.0f/255.0f;
        [colorBalance setMidtones:midtones];
        GPUVector3 highlights;
        highlights.one = 0.0f/255.0f;
        highlights.two = 0.0f/255.0f;
        highlights.three = 0.0f/255.0f;
        [colorBalance setHighlights:highlights];
        colorBalance.preserveLuminosity = YES;
        
        resultImage = [self mergeBaseImage:resultImage overlayFilter:colorBalance opacity:1.0f blendingMode:MergeBlendingModeNormal];
    }
    
    // Curve
    @autoreleasepool {
        GPUImageToneCurveFilter* curveFilter = [[GPUImageToneCurveFilter alloc] initWithACV:@"Girder4"];
        
        resultImage = [self mergeBaseImage:resultImage overlayFilter:curveFilter opacity:1.0f blendingMode:MergeBlendingModeNormal];
    }
    
    
    // Levels
    @autoreleasepool {
        GPUImageLevelsFilter* levelsFilter = [[GPUImageLevelsFilter alloc] init];
        [levelsFilter setMin:5.0f/255.0f gamma:1.05f max:255.0f/255.0f minOut:5.0/255.0f maxOut:1.0f];
        
        resultImage = [self mergeBaseImage:resultImage overlayFilter:levelsFilter opacity:1.0f blendingMode:MergeBlendingModeNormal];
    }
    
    
    // Gradient Map
    @autoreleasepool {
        GPUImageGradientMapFilter* gradientMap = [[GPUImageGradientMapFilter alloc] init];
        [gradientMap addColorRed:28.0f Green:64.0f Blue:100.0f Opacity:100.0f Location:0 Midpoint:50];
        [gradientMap addColorRed:14.0f Green:37.0f Blue:68.0f Opacity:100.0f Location:4096 Midpoint:50];
        
        resultImage = [self mergeBaseImage:resultImage overlayFilter:gradientMap opacity:0.25f blendingMode:MergeBlendingModeExclusion];
    }
    
    return resultImage;
    
}


@end
