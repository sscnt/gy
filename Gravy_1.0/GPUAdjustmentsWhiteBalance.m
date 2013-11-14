//
//  GPUWhitebalanceImageFilter.m
//  Gravy_1.0
//
//  Created by SSC on 2013/10/27.
//  Copyright (c) 2013年 SSC. All rights reserved.
//

#import "GPUAdjustmentsWhiteBalance.h"

@implementation GPUAdjustmentsWhiteBalance

NSString *const kGPUAdjustmentsWhiteBalanceFragmentShaderString = SHADER_STRING
(
 precision highp float;
 varying vec2 textureCoordinate;
 uniform sampler2D inputImageTexture;
 uniform mediump float redWeight;
 uniform mediump float blueWeight;
 
 void main()
 {
     // Sample the input pixel
     highp vec4 pixel   = texture2D(inputImageTexture, textureCoordinate);
     
     mediump float r = pixel.r + redWeight;
     mediump float g = pixel.g;
     mediump float b = pixel.b + blueWeight;
     
     r = max(0.0, min(1.0, r));
     g = max(0.0, min(1.0, g));
     b = max(0.0, min(1.0, b));
    
     
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
    if (!(self = [super initWithFragmentShaderFromString:kGPUAdjustmentsWhiteBalanceFragmentShaderString]))
    {
        return nil;
    }
    
    redWeightUniform = [filterProgram uniformIndex:@"redWeight"];
    self.redWeight = 0.0f;
    
    blueWeightUniform = [filterProgram uniformIndex:@"blueWeight"];
    self.blueWeight = 0.0f;
    
    return self;
}

- (void)setRedWeight:(float)redWeight
{
    _redWeight = redWeight;
    [self setFloat:_redWeight forUniform:redWeightUniform program:filterProgram];
}

- (void)setBlueWeight:(float)blueWeight
{
    _blueWeight = blueWeight;
    [self setFloat:_blueWeight forUniform:blueWeightUniform program:filterProgram];
}

@end
