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
    UIImage* solidImage = resultImage;
    
    // Selective Color
    @autoreleasepool {
        GPUImageSelectiveColorFilter* selectiveColor = [[GPUImageSelectiveColorFilter alloc] init];
        [selectiveColor setRedsCyan:-22 Magenta:16 Yellow:33 Black:0];
        [selectiveColor setYellowsCyan:-45 Magenta:6 Yellow:32 Black:0];
        [selectiveColor setGreensCyan:4 Magenta:21 Yellow:-13 Black:0];
        [selectiveColor setCyansCyan:-2 Magenta:-2 Yellow:29 Black:0];
        [selectiveColor setNeutralsCyan:-20 Magenta:4 Yellow:7 Black:0];
        
        GPUImagePicture* pictureOriginal = [[GPUImagePicture alloc] initWithImage:solidImage];
        [pictureOriginal addTarget:selectiveColor];
        [pictureOriginal processImage];
        solidImage = [selectiveColor imageFromCurrentlyProcessedOutput];
    }
    
    // Levels
    @autoreleasepool {
        GPUImageToneCurveFilter* curveFilter = [[GPUImageToneCurveFilter alloc] initWithACV:@"GPUSweetFlowerCurve01"];
        
        GPUImagePicture* pictureOriginal = [[GPUImagePicture alloc] initWithImage:solidImage];
        [pictureOriginal addTarget:curveFilter];
        [pictureOriginal processImage];
        solidImage = [curveFilter imageFromCurrentlyProcessedOutput];
    }
    
    // Selective Color
    @autoreleasepool {
        GPUImageSelectiveColorFilter* selectiveColor = [[GPUImageSelectiveColorFilter alloc] init];
        [selectiveColor setRedsCyan:14 Magenta:1 Yellow:4 Black:0];
        [selectiveColor setYellowsCyan:2 Magenta:-10 Yellow:-11 Black:0];
        
        GPUImagePicture* pictureOriginal = [[GPUImagePicture alloc] initWithImage:solidImage];
        [pictureOriginal addTarget:selectiveColor];
        [pictureOriginal processImage];
        solidImage = [selectiveColor imageFromCurrentlyProcessedOutput];
    }
    
    // Fill Layer
    @autoreleasepool {
        GPUImageSolidColorGenerator* solidColor = [[GPUImageSolidColorGenerator alloc] init];
        [solidColor setColorRed:0.0f green:11.0f/255.0f blue:50.0f/255.0 alpha:1.0f];
        
        GPUImageOpacityFilter* opacityFilter = [[GPUImageOpacityFilter alloc] init];
        opacityFilter.opacity = 0.30f;
        [solidColor addTarget:opacityFilter];
        
        GPUImageExclusionBlendFilter* exclusionFilter = [[GPUImageExclusionBlendFilter alloc] init];
        [opacityFilter addTarget:exclusionFilter atTextureLocation:1];
        
        GPUImagePicture* pictureOriginal = [[GPUImagePicture alloc] initWithImage:solidImage];
        [pictureOriginal addTarget:solidColor];
        [pictureOriginal addTarget:exclusionFilter];
        [pictureOriginal processImage];
        solidImage = [exclusionFilter imageFromCurrentlyProcessedOutput];
    }
    
    
    
    // Merge
    @autoreleasepool {
        GPUImageOpacityFilter* opacityFilter = [[GPUImageOpacityFilter alloc] init];
        opacityFilter.opacity = 0.80f;
        
        GPUImageNormalBlendFilter* normalFilter = [[GPUImageNormalBlendFilter alloc] init];
        [opacityFilter addTarget:normalFilter atTextureLocation:1];

        GPUImagePicture* pictureOriginal = [[GPUImagePicture alloc] initWithImage:resultImage];
        [pictureOriginal addTarget:normalFilter];
        [pictureOriginal processImage];
        
        GPUImagePicture* pictureSolid = [[GPUImagePicture alloc] initWithImage:solidImage];
        [pictureSolid addTarget:opacityFilter];
        [pictureSolid processImage];
        resultImage = [normalFilter imageFromCurrentlyProcessedOutput];
    }
    
    
    return  resultImage;
}
@end
