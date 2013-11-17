//
//  GPUImageHueSaturationFilter.h
//  Gravy_1.0
//
//  Created by SSC on 2013/11/17.
//  Copyright (c) 2013年 SSC. All rights reserved.
//

#import "GPUImageFilter.h"

extern NSString *const kGPUImageHueSaturationFilterFragmentShaderString;

@interface GPUImageHueSaturationFilter : GPUImageFilter
{
    GLuint hueUniform;
    GLuint saturationUniform;
    GLuint LightnessUniform;
}

@property (nonatomic, assign) int hue;
@property (nonatomic, assign) int saturation;
@property (nonatomic, assign) int lightness;

@end
