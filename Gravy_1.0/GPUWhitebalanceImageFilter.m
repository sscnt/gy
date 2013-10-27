//
//  GPUWhitebalanceImageFilter.m
//  Gravy_1.0
//
//  Created by SSC on 2013/10/27.
//  Copyright (c) 2013年 SSC. All rights reserved.
//

#import "GPUWhitebalanceImageFilter.h"

@implementation GPUWhitebalanceImageFilter

NSString *const kGPUImageWhitebalanceFragmentShaderString = SHADER_STRING
(
 precision highp float;
 varying vec2 textureCoordinate;
 uniform sampler2D inputImageTexture;
 uniform int redWeight;
 uniform int blueWeight;
 
 void main()
 {
     // Sample the input pixel
     highp vec4 pixel   = texture2D(inputImageTexture, textureCoordinate);
     
     int r = pixel.r + redWeight;
     int g = pixel.g;
     int b = pixel.b + blueWeight;
     
     r = max(0, min(255, r));
     g = max(0, min(255, g));
     b = max(0, min(255, b));
     
     pixel.r = r;
     pixel.g = g;
     pixel.b = b;     
     
     // Save the result
     gl_FragColor = pixel;
 }
 );

#pragma mark -
#pragma mark Initialization and teardown

- (id)init;
{
    if (!(self = [super initWithFragmentShaderFromString:kGPUImageWhitebalanceFragmentShaderString]))
    {
        return nil;
    }
    
    redWeightUniform = [filterProgram uniformIndex:@"redWeight"];
    self.redWeight = 0.0;
    
    blueWeightUniform = [filterProgram uniformIndex:@"blueWeight"];
    self.blueWeight = 0.0;
    
    return self;
}

- (void)setRedWeight:(int)redWeight
{
    _redWeight = redWeight;
    [self setInteger:_redWeight forUniform:redWeightUniform program:filterProgram];
}

- (void)setBlueWeight:(int)blueWeight
{
    _blueWeight = blueWeight;
    [self setInteger:_blueWeight forUniform:blueWeightUniform program:filterProgram];
}

@end
