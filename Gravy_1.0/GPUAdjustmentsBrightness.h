//
//  GPUBrightnessImageFilter.h
//  Gravy_1.0
//
//  Created by SSC on 2013/11/13.
//  Copyright (c) 2013年 SSC. All rights reserved.
//

#import "GPUImageFilter.h"

extern NSString *const kGravyBrightnessFragmentShaderString;

@interface GPUAdjustmentsBrightness : GPUImageFilter
{
    GLuint shadowsUniform;
    GLuint highlightsUniform;
}

// Percentage
@property (nonatomic, assign) CGFloat shadows;
@property (nonatomic, assign) CGFloat highlights;

@end
