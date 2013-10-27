//
//  GPUSaturationImageFilter.h
//  Gravy_1.0
//
//  Created by SSC on 2013/10/27.
//  Copyright (c) 2013年 SSC. All rights reserved.
//

#import "GPUImageFilter.h"

extern NSString *const kGravySaturationFragmentShaderString;

@interface GPUSaturationImageFilter : GPUImageFilter
{
    GLuint stSaturationWeightUniform;
    GLuint stVibranceWeightUniform;
}

@property (nonatomic, readwrite) float stVibranceWeight;
@property (nonatomic, readwrite) float stSaturationWeight;

@end
