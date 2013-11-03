//
//  GPUImageChannelMixerFilter.m
//  Gravy_1.0
//
//  Created by SSC on 2013/11/03.
//  Copyright (c) 2013年 SSC. All rights reserved.
//

#import "GPUImageChannelMixerFilter.h"

@implementation GPUImageChannelMixerFilter

NSString *const kGPUImageChannelMixerFilterFragmentShaderString = SHADER_STRING
(
 precision highp float;
 varying vec2 textureCoordinate;
 uniform sampler2D inputImageTexture;
 
 uniform highp float redRed; // 1.0 base
 uniform highp float redGreen; // 0.0 base
 uniform highp float redBlue; // 0.0 base
 uniform highp float redConstant;
 uniform highp float greenRed;
 uniform highp float greenGreen;
 uniform highp float greenBlue;
 uniform highp float greenConstant;
 uniform highp float blueRed;
 uniform highp float blueGreen;
 uniform highp float blueBlue;
 uniform highp float blueConstant;

 
 void main()
 {
     // Sample the input pixel
     highp vec4 pixel   = texture2D(inputImageTexture, textureCoordinate);
     highp float r = pixel.r;
     highp float g = pixel.g;
     highp float b = pixel.b;
     highp float _r;
     highp float _g;
     highp float _b;
     
    
     
     _r = r * redRed + r + redConstant + g * redGreen + b * redBlue;
     _g = g * greenGreen + g + greenConstant + r * greenRed + b * greenBlue;
     _b = b * blueBlue + b + blueConstant + r * blueRed + g * blueGreen;
     
     r = max(0.0, min(1.0, _r));
     g = max(0.0, min(1.0, _g));
     b = max(0.0, min(1.0, _b));
     
     pixel.r = r;
     pixel.g = g;
     pixel.b = b;
     
     // Save the result
     gl_FragColor = pixel;
 }
 );


#pragma mark Initialization and teardown

- (id)init;
{
    if (!(self = [super initWithFragmentShaderFromString:kGPUImageChannelMixerFilterFragmentShaderString]))
    {
        return nil;
    }
    redRedUniform = [filterProgram uniformIndex:@"redRed"];
    redGreenUniform = [filterProgram uniformIndex:@"redGreen"];
    redBlueUniform = [filterProgram uniformIndex:@"redBlue"];
    redConstantUniform = [filterProgram uniformIndex:@"redConstant"];
    
    greenRedUniform = [filterProgram uniformIndex:@"greenRed"];
    greenGreenUniform = [filterProgram uniformIndex:@"greenGreen"];
    greenBlueUniform = [filterProgram uniformIndex:@"greenBlue"];
    greenConstantUniform = [filterProgram uniformIndex:@"greenConstant"];
    
    blueRedUniform = [filterProgram uniformIndex:@"blueRed"];
    blueGreenUniform = [filterProgram uniformIndex:@"blueGreen"];
    blueBlueUniform = [filterProgram uniformIndex:@"blueBlue"];
    blueConstantUniform = [filterProgram uniformIndex:@"blueConstant"];
    
    return self;
}

- (void)setRedChannelRed:(int)red Green:(int)green Blue:(int)blue Constant:(int)constant
{
    [self setFloat:(float)(red - 100) / 100.0f forUniform:redRedUniform program:filterProgram];
    [self setFloat:(float)green / 100.0f forUniform:redGreenUniform program:filterProgram];
    [self setFloat:(float)blue / 100.0f forUniform:redBlueUniform program:filterProgram];
    [self setFloat:(float)constant / 100.0f forUniform:redConstantUniform program:filterProgram];
}

- (void)setGreenChannelRed:(int)red Green:(int)green Blue:(int)blue Constant:(int)constant
{
    [self setFloat:(float)red / 100.0f forUniform:greenRedUniform program:filterProgram];
    [self setFloat:(float)(green - 100) / 100.0f forUniform:greenGreenUniform program:filterProgram];
    [self setFloat:(float)blue / 100.0f forUniform:greenBlueUniform program:filterProgram];
    [self setFloat:(float)constant / 100.0f forUniform:greenConstantUniform program:filterProgram];
}

- (void)setBlueChannelRed:(int)red Green:(int)green Blue:(int)blue Constant:(int)constant
{
    [self setFloat:(float)red / 100.0f forUniform:blueRedUniform program:filterProgram];
    [self setFloat:(float)green / 100.0f forUniform:blueGreenUniform program:filterProgram];
    [self setFloat:(float)(blue - 100) / 100.0f forUniform:blueBlueUniform program:filterProgram];
    [self setFloat:(float)constant / 100.0f forUniform:blueConstantUniform program:filterProgram];
}

@end
