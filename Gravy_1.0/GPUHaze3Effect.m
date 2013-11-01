//
//  GPUHaze3Effect.m
//  Gravy_1.0
//
//  Created by SSC on 2013/11/01.
//  Copyright (c) 2013年 SSC. All rights reserved.
//

#import "GPUHaze3Effect.h"

@implementation GPUHaze3Effect

- (void)setImageToProcess:(UIImage *)imageToProcess
{
    _imageToProcess = imageToProcess;
}

- (UIImage*)process
{
    GPUImageOpacityFilter* opacityFilter = [[GPUImageOpacityFilter alloc] init];
    opacityFilter.opacity = 0.4f;
    GPUImagePicture* pictureToOpacity = [[GPUImagePicture alloc] initWithImage:_imageToProcess];
    [pictureToOpacity addTarget:opacityFilter];
    GPUImageGaussianBlurFilter* blurFilter = [[GPUImageGaussianBlurFilter alloc] init];
    blurFilter.blurRadiusInPixels = 40.0f;
    [opacityFilter addTarget:blurFilter];
    
    [pictureToOpacity processImage];
    return [blurFilter imageFromCurrentlyProcessedOutput];
}

@end
