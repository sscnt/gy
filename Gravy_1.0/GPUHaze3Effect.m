//
//  GPUHaze3Effect.m
//  Gravy_1.0
//
//  Created by SSC on 2013/11/01.
//  Copyright (c) 2013年 SSC. All rights reserved.
//

#import "GPUHaze3Effect.h"

@implementation GPUHaze3Effect

- (UIImage*)process
{
    // Blur
    GPUImageOpacityFilter* opacityFilter = [[GPUImageOpacityFilter alloc] init];
    opacityFilter.opacity = 0.4f;
    GPUImagePicture* pictureBlur = [[GPUImagePicture alloc] initWithImage:_imageToProcess];
    [pictureBlur addTarget:opacityFilter];
    GPUImageGaussianBlurFilter* blurFilter = [[GPUImageGaussianBlurFilter alloc] init];
    blurFilter.blurRadiusInPixels = 40.0f;
    [opacityFilter addTarget:blurFilter];
    [pictureBlur processImage];
    UIImage* bluredImage = [blurFilter imageFromCurrentlyProcessedOutput];
    
    // Fill
    GPUImageSolidColorGenerator* solidGen = [[GPUImageSolidColorGenerator alloc] init];
    [solidGen setColorRed:5.0f/255.0f green:23.0f/255.0f blue:50.0f/255.0f alpha:1.0f];
    GPUImagePicture* pictureFill = [[GPUImagePicture alloc] initWithImage:_imageToProcess];
    [pictureFill addTarget:solidGen];
    [pictureFill processImage];
    UIImage* solidImage = [solidGen imageFromCurrentlyProcessedOutput];
    
    // Blend
    GPUImageOverlayBlendFilter* overlayFilter = [[GPUImageOverlayBlendFilter alloc] init];
    GPUImagePicture* pictureOriginal = [[GPUImagePicture alloc] initWithImage:_imageToProcess];
    pictureBlur = [[GPUImagePicture alloc] initWithImage:bluredImage];
    [pictureOriginal addTarget:overlayFilter];
    [pictureBlur addTarget:overlayFilter];
    [pictureBlur processImage];
    [pictureOriginal processImage];
    UIImage* resultImage = [overlayFilter imageFromCurrentlyProcessedOutput];
    
    GPUImageExclusionBlendFilter* exclusionFilter = [[GPUImageExclusionBlendFilter alloc] init];
    pictureOriginal = [[GPUImagePicture alloc] initWithImage:resultImage];
    pictureFill = [[GPUImagePicture alloc] initWithImage:solidImage];
    [pictureOriginal addTarget:exclusionFilter];
    [pictureFill addTarget:exclusionFilter];
    [pictureOriginal processImage];
    [pictureFill processImage];
    resultImage = [exclusionFilter imageFromCurrentlyProcessedOutput];
    
    return resultImage;
}

@end
