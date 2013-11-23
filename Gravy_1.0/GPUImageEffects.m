//
//  GPUImageEffects.m
//  Gravy_1.0
//
//  Created by SSC on 2013/11/04.
//  Copyright (c) 2013年 SSC. All rights reserved.
//

#import "GPUImageEffects.h"

@implementation GPUImageEffects

- (UIImage*)mergeBaseImage:(UIImage *)baseImage overlayFilter:(GPUImageFilter *)overlayFilter opacity:(CGFloat)opacity blendingMode:(MergeBlendingMode)blendingMode
{
    GPUImageOpacityFilter* opacityFilter = [[GPUImageOpacityFilter alloc] init];
    opacityFilter.opacity = opacity;
    [overlayFilter addTarget:opacityFilter];
    
    GPUImagePicture* picture = [[GPUImagePicture alloc] initWithImage:baseImage];
    [picture addTarget:overlayFilter];
    
    if(blendingMode == MergeBlendingModeNormal){
        GPUImageNormalBlendFilter* blending = [[GPUImageNormalBlendFilter alloc] init];
        [opacityFilter addTarget:blending atTextureLocation:1];
        
        [picture addTarget:blending];
        [picture processImage];
        return [blending imageFromCurrentlyProcessedOutput];
    }
    
    if(blendingMode == MergeBlendingModeSoftLight){
        GPUImageSoftLightBlendFilter* blending = [[GPUImageSoftLightBlendFilter alloc] init];
        [opacityFilter addTarget:blending atTextureLocation:1];
        
        [picture addTarget:blending];
        [picture processImage];
        return [blending imageFromCurrentlyProcessedOutput];
    }
    
    if(blendingMode == MergeBlendingModeExclusion){
        GPUImageExclusionBlendFilter* blending = [[GPUImageExclusionBlendFilter alloc] init];
        [opacityFilter addTarget:blending atTextureLocation:1];
        
        [picture addTarget:blending];
        [picture processImage];
        return [blending imageFromCurrentlyProcessedOutput];
    }
    
    if(blendingMode == MergeBlendingModeHue){
        GPUImageHueBlendFilter* blending = [[GPUImageHueBlendFilter alloc] init];
        [opacityFilter addTarget:blending atTextureLocation:1];
        
        [picture addTarget:blending];
        [picture processImage];
        return [blending imageFromCurrentlyProcessedOutput];
    }
    return nil;
}

@end
