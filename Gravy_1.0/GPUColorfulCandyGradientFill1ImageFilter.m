//
//  GPUColorfulCandyGradientFill1ImageFilter.m
//  Gravy_1.0
//
//  Created by SSC on 2013/11/02.
//  Copyright (c) 2013年 SSC. All rights reserved.
//

#import "GPUColorfulCandyGradientFill1ImageFilter.h"

@implementation GPUColorfulCandyGradientFill1ImageFilter


NSString *const kGPUColorfulCandyGradientFill1ImageFilterFragmentShaderString = SHADER_STRING
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
     highp float a = pixel.a;
     highp float x = textureCoordinate.x;
     
     highp float m255 = 0.00392156862;
     
     highp float rdiff;
     highp float gdiff;
     highp float bdiff;
     highp float adiff;
     
     /*
      * from
      * R:232 G:114 B:43 A:1.0
      * to
      * R:255 G:255 B:255 A: 0.0
      */
     rdiff = 23.0 * m255;
     gdiff = 141.0 * m255;
     bdiff = 212.0 * m255;
     adiff = -1.0;
     r = 232.0 * m255 + rdiff * x;
     g = 114.0 * m255 + gdiff * x;
     b = 43.0 * m255 + bdiff * x;
     a = 1.0 + adiff * x;
     
     r = max(0.0, min(1.0, r));
     g = max(0.0, min(1.0, g));
     b = max(0.0, min(1.0, b));
     a = max(0.0, min(1.0, a));
     
     pixel.r = r;
     pixel.g = g;
     pixel.b = b;
     pixel.a = a;
     
     // Save the result
     gl_FragColor = pixel;
 }
 );


#pragma mark Initialization and teardown

- (id)init;
{
    if (!(self = [super initWithFragmentShaderFromString:kGPUColorfulCandyGradientFill1ImageFilterFragmentShaderString]))
    {
        return nil;
    }
    
    return self;
}



@end
