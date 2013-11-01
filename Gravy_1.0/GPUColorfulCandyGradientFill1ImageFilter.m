//
//  GPUColorfulCandyGradientFill1ImageFilter.m
//  Gravy_1.0
//
//  Created by SSC on 2013/11/01.
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
     highp float x = textureCoordinate.x;
     
     highp float m255 = 0.00392156862;

     highp float rdiff;
     highp float gdiff;
     highp float bdiff;
     
     if(x < 0.3){
         /*
          * from
          * R:89 G:35 B:145
          * to
          * R:254 G:177 B:244
          */
         rdiff = 165.0 * m255;
         gdiff = 142.0 * m255;
         bdiff = 99.0 * m255;
         r = 89.0 * m255 + rdiff * x * 3.33333333333;
         g = 35.0 * m255 + gdiff * x *  3.33333333333;
         b = 145.0 * m255 + bdiff * x *  3.33333333333;
     } else if(x < 0.83){
         /*
          * from
          * R:254 G:177 B:244
          * to
          * R:97 G:108 B:22
          */
         rdiff = -157.0 * m255;
         gdiff = -69.0 * m255;
         bdiff = -222.0 * m255;
         r = 254.0 * m255 + rdiff * (x - 0.3) * 1.88679245283;
         g = 177.0 * m255 + gdiff * (x - 0.3) *  1.88679245283;
         b = 244.0 * m255 + bdiff * (x - 0.3) *  1.88679245283;
     } else{
         /*
          * from
          * R:97 G:108 B:22
          * to
          * R:255 G:255 B:255
          */
         rdiff = 158.0 * m255;
         gdiff = 147.0 * m255;
         bdiff = 233.0 * m255;
         r = 97.0 * m255 + rdiff * (x - 0.83) * 5.88235294118;
         g = 108.0 * m255 + gdiff * (x - 0.83) *  5.88235294118;
         b = 22.0 * m255 + bdiff * (x - 0.83) *  5.88235294118;
     }

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
