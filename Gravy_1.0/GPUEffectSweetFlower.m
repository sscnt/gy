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
    UIImage* solidImage;
    
    // Selective Color / Curve
    @autoreleasepool {
        GPUImageSelectiveColorFilter* selectiveColor = [[GPUImageSelectiveColorFilter alloc] init];
        [selectiveColor setRedsCyan:-22 Magenta:16 Yellow:33 Black:0];
        [selectiveColor setYellowsCyan:-45 Magenta:6 Yellow:32 Black:0];
        [selectiveColor setGreensCyan:4 Magenta:21 Yellow:-13 Black:0];
        [selectiveColor setCyansCyan:-2 Magenta:-2 Yellow:29 Black:0];
        [selectiveColor setNeutralsCyan:-20 Magenta:4 Yellow:7 Black:0];
        
        GPUImageToneCurveFilter* curveFilter = [[GPUImageToneCurveFilter alloc] initWithACV:@"GPUSweetFlowerCurve01"];
        [selectiveColor addTarget:curveFilter];
        
        GPUImagePicture* pictureOriginal = [[GPUImagePicture alloc] initWithImage:resultImage];
        [pictureOriginal addTarget:selectiveColor];
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
    
    
    // Fill Layer
    @autoreleasepool {
        GPUImageSolidColorGenerator* solidColor = [[GPUImageSolidColorGenerator alloc] init];
        [solidColor setColorRed:29.0f/255.0f green:137.0f/255.0f blue:212.0f/255.0 alpha:1.0f];
        
        GPUImageOpacityFilter* opacityFilter = [[GPUImageOpacityFilter alloc] init];
        opacityFilter.opacity = 0.15f;
        [solidColor addTarget:opacityFilter];
        
        GPUImageExclusionBlendFilter* exclusionFilter = [[GPUImageExclusionBlendFilter alloc] init];
        [opacityFilter addTarget:exclusionFilter atTextureLocation:1];
        
        GPUImagePicture* pictureOriginal = [[GPUImagePicture alloc] initWithImage:solidImage];
        [pictureOriginal addTarget:solidColor];
        [pictureOriginal addTarget:exclusionFilter];
        [pictureOriginal processImage];
        solidImage = [exclusionFilter imageFromCurrentlyProcessedOutput];
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
        midtones.two = 0.0f;
        midtones.three = 0.0f;
        [colorBalance setHighlights:midtones];
        colorBalance.preserveLuminosity = YES;
        
        GPUImageOpacityFilter* opacityFilter = [[GPUImageOpacityFilter alloc] init];
        opacityFilter.opacity = 0.90f;
        [colorBalance addTarget:opacityFilter];
        
        GPUImageNormalBlendFilter* normalFilter = [[GPUImageNormalBlendFilter alloc] init];
        [opacityFilter addTarget:normalFilter atTextureLocation:1];
        
        GPUImagePicture* pictureBase = [[GPUImagePicture alloc] initWithImage:solidImage];
        [pictureBase addTarget:normalFilter];
        [pictureBase addTarget:colorBalance];
        [pictureBase processImage];
        solidImage = [normalFilter imageFromCurrentlyProcessedOutput];
    }
    
    // Selective Color
    @autoreleasepool {
        GPUImageSelectiveColorFilter* selectiveColor = [[GPUImageSelectiveColorFilter alloc] init];
        [selectiveColor setRedsCyan:5 Magenta:0 Yellow:0 Black:0];
        [selectiveColor setYellowsCyan:9 Magenta:10 Yellow:3 Black:0];
        [selectiveColor setNeutralsCyan:-4 Magenta:-9 Yellow:-14 Black:0];
        
        GPUImagePicture* pictureOriginal = [[GPUImagePicture alloc] initWithImage:solidImage];
        [pictureOriginal addTarget:selectiveColor];
        [pictureOriginal processImage];
        solidImage = [selectiveColor imageFromCurrentlyProcessedOutput];
    }
    
    
    // Curve
    @autoreleasepool {
        GPUImageToneCurveFilter* curveFilter = [[GPUImageToneCurveFilter alloc] initWithACV:@"GPUSweetFlowerCurve02"];
        
        GPUImagePicture* pictureOriginal = [[GPUImagePicture alloc] initWithImage:solidImage];
        [pictureOriginal addTarget:curveFilter];
        [pictureOriginal processImage];
        solidImage = [curveFilter imageFromCurrentlyProcessedOutput];
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
