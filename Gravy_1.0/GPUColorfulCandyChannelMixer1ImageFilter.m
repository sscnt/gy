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
     
     highp float h = 0.0;
     highp float s = 0.0;
     highp float v = 0.0;
     
     highp float redRed = 0.92;
     highp float redGreen = 0.26;
     highp float redBlue = -0.2;
     highp float greenRed = 0.0;
     highp float greenGreen = 1.0;
     highp float greenBlue = 0.0;
     highp float blueRed = -0.08;
     highp float blueGreen = 0.04;
     highp float blueBlue = 1.08;
     
     highp float max = max(r, max(g, b));
     highp float min = min(r, min(g, b));
     h = 0.0;
     if(max < min){
         max = 0.0;
         min = 0.0;
     }
     if(max == min){
         
     } else if(max == r){
         h = 60.0 * (g - b) / (max - min);
     } else if(max == g){
         h = 60.0 * (b - r) / (max - min) + 120.0;
     } else if(max == b){
         h = 60.0 * (r - g) / (max - min) + 240.0;
     }
     if(h < 0.0){
         h += 360.0;
     }
     h = mod(h, 360.0);
     if(max == 0.0) {
         s = 0.0;
     } else {
         s = (max - min) / max;
     }
     v = max;

     // Process
     if(h <= 60.0 || h > 300.0){   // Red
         r += r * redRed;
         g += g * redGreen;
         b += b * redBlue;
     } else if(h > 60.0 && h <= 180.0){     // Green
         r += r * greenRed;
         g += g * greenGreen;
         b += b * greenBlue;
     } else{    // Blue
         r += r * blueRed;
         g += g * blueGreen;
         b += b * blueBlue;
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
    if (!(self = [super initWithFragmentShaderFromString:kGPUColorfulCandyChannelMixer1ImageFilterFragmentShaderString]))
    {
        return nil;
    }
    
    return self;
}
@end
