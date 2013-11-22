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
        [gradientGenerator setStyle:GradientStyleRadial];
        [gradientGenerator setAngleDegree:42.7];
        [gradientGenerator setScalePercent:150.0f];
        [gradientGenerator setOffsetX:29.4f Y:-65.4f];
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
        [selectiveColor setYellowsCyan:0 Magenta:5 Yellow:-9 Black:0];
        [selectiveColor setCyansCyan:0 Magenta:0 Yellow:-1 Black:0];
        [selectiveColor setMagentasCyan:13 Magenta:-12 Yellow:12 Black:0];
        [selectiveColor setWhitesCyan:0 Magenta:0 Yellow:-30 Black:0];
        GPUImagePicture* pictureOriginal = [[GPUImagePicture alloc] initWithImage:resultImage];
        [pictureOriginal addTarget:selectiveColor];
        [pictureOriginal processImage];
        resultImage = [selectiveColor imageFromCurrentlyProcessedOutput];
    }
    
    // Fill Layer
    @autoreleasepool {
        GPUImageSolidColorGenerator* solidColor = [[GPUImageSolidColorGenerator alloc] init];
        [solidColor setColorRed:0.0f green:8.0f/255.0f blue:28.0f/255.0f alpha:1.0f];
        
        GPUImageExclusionBlendFilter* exclusionFilter = [[GPUImageExclusionBlendFilter alloc] init];
        [solidColor addTarget:exclusionFilter atTextureLocation:1];
        
        GPUImagePicture* pictureOriginal = [[GPUImagePicture alloc] initWithImage:resultImage];
        [pictureOriginal addTarget:exclusionFilter];
        [pictureOriginal addTarget:solidColor];
        [pictureOriginal processImage];
        resultImage = [exclusionFilter imageFromCurrentlyProcessedOutput];
    }
    
    
    // Fill Layer
    @autoreleasepool {
        GPUImageSolidColorGenerator* solidColor = [[GPUImageSolidColorGenerator alloc] init];
        [solidColor setColorRed:207.0f/255.0f green:224.0f/255.0f blue:1.0f alpha:1.0f];
        
        GPUImageOpacityFilter* opacityFilter = [[GPUImageOpacityFilter alloc] init];
        opacityFilter.opacity = 0.40f;
        [solidColor addTarget:opacityFilter];
        
        GPUImageSoftLightBlendFilter* softlightFilter = [[GPUImageSoftLightBlendFilter alloc] init];
        [opacityFilter addTarget:softlightFilter atTextureLocation:1];
        
        GPUImagePicture* pictureOriginal = [[GPUImagePicture alloc] initWithImage:resultImage];
        [pictureOriginal addTarget:softlightFilter];
        [pictureOriginal addTarget:solidColor];
        [pictureOriginal processImage];
        resultImage = [softlightFilter imageFromCurrentlyProcessedOutput];
    }
    
    
    // Fill Layer
    @autoreleasepool {
        GPUImageSolidColorGenerator* solidColor = [[GPUImageSolidColorGenerator alloc] init];
        [solidColor setColorRed:236.0f/255.0f green:158.0f/255.0f blue:34.0f/255.0f alpha:1.0f];
        
        GPUImageOpacityFilter* opacityFilter = [[GPUImageOpacityFilter alloc] init];
        opacityFilter.opacity = 0.50f;
        [solidColor addTarget:opacityFilter];
        
        GPUImageSoftLightBlendFilter* softlightFilter = [[GPUImageSoftLightBlendFilter alloc] init];
        [opacityFilter addTarget:softlightFilter atTextureLocation:1];
        
        GPUImagePicture* pictureOriginal = [[GPUImagePicture alloc] initWithImage:resultImage];
        [pictureOriginal addTarget:softlightFilter];
        [pictureOriginal addTarget:solidColor];
        [pictureOriginal processImage];
        resultImage = [softlightFilter imageFromCurrentlyProcessedOutput];
    }
    
    // Levels
    @autoreleasepool {
        GPUImageLevelsFilter* levelsFilter = [[GPUImageLevelsFilter alloc] init];
        [levelsFilter setMin:10.0f/255.0f gamma:0.97f max:244.0f/255.0f minOut:0.0f maxOut:246.0f/255.0f];
        
        GPUImageNormalBlendFilter* normalFilter = [[GPUImageNormalBlendFilter alloc] init];
        [levelsFilter addTarget:normalFilter atTextureLocation:1];
        
        GPUImagePicture* pictureOriginal = [[GPUImagePicture alloc] initWithImage:resultImage];
        [pictureOriginal addTarget:levelsFilter];
        [pictureOriginal addTarget:normalFilter];
        [pictureOriginal processImage];
        resultImage = [normalFilter imageFromCurrentlyProcessedOutput];
    }
    
    // Gradient Fill
    @autoreleasepool {
        GPUImageGradientColorGenerator* gradientColor = [[GPUImageGradientColorGenerator alloc] init];
        [gradientColor setAngleDegree:116.6];
        [gradientColor setScalePercent:150.0f];
        [gradientColor setOffsetX:-4.5 Y:10.4f];
        [gradientColor addColorRed:208.0f Green:225.0f Blue:253.0f Opacity:100.0f Location:0 Midpoint:50];
        [gradientColor addColorRed:45.004f Green:53.004f Blue:34.0f Opacity:0.0f Location:4096 Midpoint:50];
        
        GPUImageOpacityFilter* opacityFilter = [[GPUImageOpacityFilter alloc] init];
        opacityFilter.opacity = 0.50f;
        [gradientColor addTarget:opacityFilter];
        
        GPUImageSoftLightBlendFilter* softlightFilter = [[GPUImageSoftLightBlendFilter alloc] init];
        [opacityFilter addTarget:softlightFilter atTextureLocation:1];

        GPUImagePicture* pictureOriginal = [[GPUImagePicture alloc] initWithImage:resultImage];
        [pictureOriginal addTarget:gradientColor];
        [pictureOriginal addTarget:softlightFilter];
        [pictureOriginal processImage];
        resultImage = [softlightFilter imageFromCurrentlyProcessedOutput];

    }
    

    // Fill Layer
    @autoreleasepool {
        GPUImageSolidColorGenerator* solidColor = [[GPUImageSolidColorGenerator alloc] init];
        [solidColor setColorRed:0.0f green:24.0f/255.0f blue:42.0f/255.0f alpha:1.0f];
        
        GPUImageOpacityFilter* opacityFilter = [[GPUImageOpacityFilter alloc] init];
        opacityFilter.opacity = 0.40f;
        [solidColor addTarget:opacityFilter];
        
        GPUImageExclusionBlendFilter* exclusionFilter = [[GPUImageExclusionBlendFilter alloc] init];
        [opacityFilter addTarget:exclusionFilter atTextureLocation:1];
        
        GPUImagePicture* pictureOriginal = [[GPUImagePicture alloc] initWithImage:resultImage];
        [pictureOriginal addTarget:exclusionFilter];
        [pictureOriginal addTarget:solidColor];
        [pictureOriginal processImage];
        resultImage = [exclusionFilter imageFromCurrentlyProcessedOutput];
    }
    
    
    // Gradient Fill
    @autoreleasepool {
        GPUImageGradientColorGenerator* gradientColor = [[GPUImageGradientColorGenerator alloc] init];
        [gradientColor setStyle:GradientStyleRadial];
        [gradientColor setAngleDegree:51.8];
        [gradientColor setScalePercent:150.0f];
        [gradientColor setOffsetX:6.3 Y:-5.7f];
        [gradientColor addColorRed:213.0f Green:133.0f Blue:56.f Opacity:0.0f Location:0 Midpoint:50];
        [gradientColor addColorRed:213.0f Green:133.0f Blue:56.f Opacity:100.0f Location:4096 Midpoint:65];
        
        GPUImageOpacityFilter* opacityFilter = [[GPUImageOpacityFilter alloc] init];
        opacityFilter.opacity = 0.40f;
        [gradientColor addTarget:opacityFilter];

        GPUImageHardLightBlendFilter* hardlightFilter = [[GPUImageHardLightBlendFilter alloc] init];
        [opacityFilter addTarget:hardlightFilter atTextureLocation:1];
        
        GPUImagePicture* pictureOriginal = [[GPUImagePicture alloc] initWithImage:resultImage];
        [pictureOriginal addTarget:gradientColor];
        [pictureOriginal addTarget:hardlightFilter];
        [pictureOriginal processImage];
        resultImage = [hardlightFilter imageFromCurrentlyProcessedOutput];
    }
    
    
    // Gradient Fill
    @autoreleasepool {
        GPUImageGradientColorGenerator* gradientColor = [[GPUImageGradientColorGenerator alloc] init];
        [gradientColor setStyle:GradientStyleRadial];
        [gradientColor setAngleDegree:51.8];
        [gradientColor setScalePercent:150.0f];
        [gradientColor setOffsetX:18.7f Y:-10.4f];
        [gradientColor addColorRed:132.0f Green:132.0f Blue:236.0f Opacity:0.0f Location:0 Midpoint:50];
        [gradientColor addColorRed:132.0f Green:132.0f Blue:236.0f Opacity:100.0f Location:4096 Midpoint:65];
        
        GPUImageOpacityFilter* opacityFilter = [[GPUImageOpacityFilter alloc] init];
        opacityFilter.opacity = 0.40f;
        [gradientColor addTarget:opacityFilter];
        
        GPUImageHardLightBlendFilter* hardlightFilter = [[GPUImageHardLightBlendFilter alloc] init];
        [opacityFilter addTarget:hardlightFilter atTextureLocation:1];
        
        GPUImagePicture* pictureOriginal = [[GPUImagePicture alloc] initWithImage:resultImage];
        [pictureOriginal addTarget:gradientColor];
        [pictureOriginal addTarget:hardlightFilter];
        [pictureOriginal processImage];
        resultImage = [hardlightFilter imageFromCurrentlyProcessedOutput];
    }
    
    
    // Gradient Fill
    @autoreleasepool {
        GPUImageGradientColorGenerator* gradientColor = [[GPUImageGradientColorGenerator alloc] init];
        [gradientColor setAngleDegree:51.8];
        [gradientColor setScalePercent:150.0f];
        [gradientColor setOffsetX:-23.6f Y:19.3f];
        [gradientColor addColorRed:166.0f Green:140.0f Blue:188.0f Opacity:0.0f Location:0 Midpoint:50];
        [gradientColor addColorRed:166.0f Green:140.0f Blue:188.0f Opacity:100.0f Location:4096 Midpoint:65];
        
        GPUImageOpacityFilter* opacityFilter = [[GPUImageOpacityFilter alloc] init];
        opacityFilter.opacity = 0.26f;
        [gradientColor addTarget:opacityFilter];
        
        GPUImageHardLightBlendFilter* hardlightFilter = [[GPUImageHardLightBlendFilter alloc] init];
        [opacityFilter addTarget:hardlightFilter atTextureLocation:1];
        
        GPUImagePicture* pictureOriginal = [[GPUImagePicture alloc] initWithImage:resultImage];
        [pictureOriginal addTarget:gradientColor];
        [pictureOriginal addTarget:hardlightFilter];
        [pictureOriginal processImage];
        resultImage = [hardlightFilter imageFromCurrentlyProcessedOutput];
    }
    
    return resultImage;
}

@end
