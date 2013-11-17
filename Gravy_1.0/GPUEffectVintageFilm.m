//
//  GPUEffectVintageFilm.m
//  Gravy_1.0
//
//  Created by SSC on 2013/11/17.
//  Copyright (c) 2013年 SSC. All rights reserved.
//

#import "GPUEffectVintageFilm.h"

@implementation GPUEffectVintageFilm


- (UIImage*)process
{
    UIImage* resultImage = self.imageToProcess;
    UIImage* solidImage;
    
    // Saturation
    @autoreleasepool {
        GPUImageSaturationFilter* saturationFilter = [[GPUImageSaturationFilter alloc] init];
        saturationFilter.saturation = 1.20f;
        GPUImagePicture* picture = [[GPUImagePicture alloc] initWithImage:resultImage];
        [picture addTarget:saturationFilter];
        [picture processImage];
        solidImage = [saturationFilter imageFromCurrentlyProcessedOutput];
    }
    
    // Contrast
    @autoreleasepool {
        GPUImageContrastFilter* contrastFilter = [[GPUImageContrastFilter alloc] init];
        contrastFilter.contrast = 1.20f;
        
        GPUImagePicture* picture = [[GPUImagePicture alloc] initWithImage:solidImage];
        [picture addTarget:contrastFilter];
        [picture processImage];
        resultImage = [contrastFilter imageFromCurrentlyProcessedOutput];
    }
    
    return resultImage;
}

@end
