//
//  GPUEffectHazelnut.m
//  Gravy_1.0
//
//  Created by SSC on 2013/11/22.
//  Copyright (c) 2013年 SSC. All rights reserved.
//

#import "GPUEffectHazelnut.h"

@implementation GPUEffectHazelnut


- (UIImage*)process
{
    UIImage* resultImage = self.imageToProcess;
    UIImage* solidImage;
    

    // Curve
    @autoreleasepool {
        GPUImageToneCurveFilter* curveFilter = [[GPUImageToneCurveFilter alloc] initWithACV:@"GPUHazelnutCurve01"];
        
        GPUImagePicture* picture = [[GPUImagePicture alloc] initWithImage:resultImage];
        [picture addTarget:curveFilter];
        [picture processImage];
        resultImage = [curveFilter imageFromCurrentlyProcessedOutput];
    }
    
    
    // Fill Layer
    @autoreleasepool {
        GPUImageSolidColorGenerator* solidColor = [[GPUImageSolidColorGenerator alloc] init];
        [solidColor setColorRed:0.0f/255.0f green:8.0f/255.0f blue:28.0f/255.0 alpha:1.0f];
        
        GPUImageOpacityFilter* opacityFilter = [[GPUImageOpacityFilter alloc] init];
        opacityFilter.opacity = 0.80f;
        [solidColor addTarget:opacityFilter];
        
        GPUImageExclusionBlendFilter* exclusionFilter = [[GPUImageExclusionBlendFilter alloc] init];
        [opacityFilter addTarget:exclusionFilter atTextureLocation:1];
        
        GPUImagePicture* pictureOriginal = [[GPUImagePicture alloc] initWithImage:resultImage];
        [pictureOriginal addTarget:solidColor];
        [pictureOriginal addTarget:exclusionFilter];
        [pictureOriginal processImage];
        resultImage = [exclusionFilter imageFromCurrentlyProcessedOutput];
    }
    
    // Gradient
    @autoreleasepool {
        GPUImageGradientColorGenerator* gradientColor = [[GPUImageGradientColorGenerator alloc] init];
        [gradientColor forceProcessingAtSize:CGSizeMake(resultImage.size.width, resultImage.size.height)];
        [gradientColor setStyle:GradientStyleLinear];
        [gradientColor setAngleDegree:-125];
        [gradientColor setScalePercent:100];
        [gradientColor setOffsetX:0.0f Y:0.0f];
        [gradientColor addColorRed:159.0f Green:132.0f Blue:75.0f Opacity:100.0f Location:0 Midpoint:50];
        [gradientColor addColorRed:128.0f Green:123.0f Blue:59.0f Opacity:0.0f Location:4096 Midpoint:50];
        
        GPUImageSoftLightBlendFilter* softlightBlend = [[GPUImageSoftLightBlendFilter alloc] init];
        [gradientColor addTarget:softlightBlend atTextureLocation:1];
        
        GPUImagePicture* picture = [[GPUImagePicture alloc] initWithImage:resultImage];
        [picture addTarget:softlightBlend];
        [picture addTarget:gradientColor];
        [picture processImage];
        resultImage = [softlightBlend imageFromCurrentlyProcessedOutput];
    }
    
    
    // Gradient
    @autoreleasepool {
        GPUImageGradientColorGenerator* gradientColor = [[GPUImageGradientColorGenerator alloc] init];
        [gradientColor forceProcessingAtSize:CGSizeMake(resultImage.size.width, resultImage.size.height)];
        [gradientColor setStyle:GradientStyleRadial];
        [gradientColor setAngleDegree:55];
        [gradientColor setScalePercent:150];
        [gradientColor setOffsetX:2.0f Y:-4.0f];
        [gradientColor addColorRed:255.0f Green:229.0f Blue:183.0f Opacity:100.0f Location:0 Midpoint:50];
        [gradientColor addColorRed:128.0f Green:123.0f Blue:59.0f Opacity:0.0f Location:4096 Midpoint:50];
        
        GPUImageOverlayBlendFilter* overlayBlend = [[GPUImageOverlayBlendFilter alloc] init];
        [gradientColor addTarget:overlayBlend atTextureLocation:1];
        
        GPUImageNormalBlendFilter* normal = [[GPUImageNormalBlendFilter alloc] init];
        [gradientColor addTarget:normal atTextureLocation:1];
        
        GPUImagePicture* picture = [[GPUImagePicture alloc] initWithImage:resultImage];
        [picture addTarget:gradientColor];
        [picture addTarget:normal];
        [picture processImage];
        resultImage = [normal imageFromCurrentlyProcessedOutput];
    }


    
    return resultImage;
}

@end
