//
//  GPUGradientColorFilter.h
//  Gravy_1.0
//
//  Created by SSC on 2013/11/03.
//  Copyright (c) 2013年 SSC. All rights reserved.
//

#import "GPUImageFilter.h"

extern NSString *const kGPUImageGradientColorGeneratorFragmentShaderString;

@interface GPUImageGradientColorGenerator : GPUImageFilter
{
    GLuint locationsUniform;
    GLuint colorsUniform;
    GLuint midpointUniform;
    GLuint angleUniform;
    GLuint scaleUniform;
    GLuint baselineLengthUniform;
    GLuint imageWidthUniform;
    GLuint imageHeightUniform;
    
    int index;
    float locations[20];
    float midpoints[20];
    GPUVector4 colors[20];
    
    float _angle;
    float _scale;
    
    float imageWidth;
    float imageHeight;
    float baselineLength;
}

/*
 * red      0.0 - 255.0
 * green    0.0 - 255.0
 * blue     0.0 - 255.0
 * opacity  0.0 - 100.0
 * location 0   - 4096
 */
- (void)addColorRed:(float)red Green:(float)green Blue:(float)blue Opacity:(float)opacity Location:(int)location Midpoint:(int)midpoint;

/*
 * degree -360.0 - 360.0
 */
- (void)setAngleDegree:(float)angle;

/*
 * percent 0.0 - 150.0
 */
- (void)setScalePercent:(float)scale;

- (void)setup;

@end
