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
    GLuint shadowsAmountUniform;
    GLuint shadowsRadiusUniform;
    GLuint highlightsAmountUniform;
    GLuint contrastAmountUniform;
}

// Percentage
@property (nonatomic, assign) float shadowsAmount;
@property (nonatomic, assign) float shadowsRadius;
@property (nonatomic, assign) float highlightsAmount;
@property (nonatomic, assign) float highlightsRadius;
@property (nonatomic, assign) float contrastAmount;

@end
