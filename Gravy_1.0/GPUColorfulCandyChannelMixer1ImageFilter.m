//
//  GPUColorfulCandyChannelMixer1ImageFilter.m
//  Gravy_1.0
//
//  Created by SSC on 2013/11/01.
//  Copyright (c) 2013年 SSC. All rights reserved.
//

#import "GPUColorfulCandyChannelMixer1ImageFilter.h"

@implementation GPUColorfulCandyChannelMixer1ImageFilter

NSString *const kGPUColorfulCandyChannelMixer1ImageFilterFragmentShaderString = SHADER_STRING
(
 precision highp float;
 varying vec2 textureCoordinate;
 uniform sampler2D inputImageTexture;
 

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
     
     highp float redRed = -0.08; // 1.0 base
     highp float redGreen = 0.26; // 0.0 base
     highp float redBlue = -0.2; // 0.0 base
     highp float redConstant = 0.0;
     highp float greenRed = 0.0;
     highp float greenGreen = 0.0;
     highp float greenBlue = 0.0;
     highp float greenConstant = 0.0;
     highp float blueRed = -0.08;
     highp float blueGreen = 0.04;
     highp float blueBlue = 0.08;
     highp float blueConstant = 0.0;
     
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
    if (!(self = [super initWithFragmentShaderFromString:kGPUColorfulCandyChannelMixer1ImageFilterFragmentShaderString]))
    {
        return nil;
    }
    
    return self;
}
@end
