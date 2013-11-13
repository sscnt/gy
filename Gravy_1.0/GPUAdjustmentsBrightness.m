//
//  GPUBrightnessImageFilter.m
//  Gravy_1.0
//
//  Created by SSC on 2013/11/13.
//  Copyright (c) 2013年 SSC. All rights reserved.
//

#import "GPUAdjustmentsBrightness.h"

@implementation GPUAdjustmentsBrightness

NSString *const kGravyBrightnessFragmentShaderString = SHADER_STRING
(
 precision highp float;
 varying vec2 textureCoordinate;
 uniform sampler2D inputImageTexture;
 uniform mediump float shadows;
 uniform mediump float highlights;
 
 
 vec3 rgb2hsv(highp vec3 color){
     highp float r = color.r;
     highp float g = color.g;
     highp float b = color.b;
     
     highp float max = max(r, max(g, b));
     highp float min = min(r, min(g, b));
     highp float h = 0.0;
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
     
     highp float s;
     if(max == 0.0) {
         s = 0.0;
     } else {
         s = (max - min) / max;
     }
     highp float v = max;
     
     return vec3(h, s, v);
 }
 
 vec3 hsv2rgb(highp vec3 color){
     highp float h = color.r;
     highp float s = color.g;
     highp float v = color.b;
     highp float r;
     highp float g;
     highp float b;
     highp float m60 = 0.01665;
     int hi = int(mod(float(floor(h * m60)), 6.0));
     highp float f = (h * m60) - float(hi);
     highp float p = v * (1.0 - s);
     highp float q = v * (1.0 - s * f);
     highp float t = v * (1.0 - s * (1.0 - f));
     
     if(hi == 0){
         r = v;
         g = t;
         b = p;
     } else if(hi == 1){
         r = q;
         g = v;
         b = p;
     } else if(hi == 2){
         r = p;
         g = v;
         b = t;
     } else if(hi == 3){
         r = p;
         g = q;
         b = v;
     } else if(hi == 4){
         r = t;
         g = p;
         b = v;
     } else if(hi == 5){
         r = v;
         g = p;
         b = q;
     } else {
         r = v;
         g = t;
         b = p;
     }
     return vec3(r, g, b);
     
 }

 float round(float a){
     float b = floor(a);
     b = floor((a - b) * 10.0);
     if(int(b) < 5){
         return floor(a);
     }
     return ceil(a);
 }
 
 void main()
 {
     mediump vec4 pixel   = texture2D(inputImageTexture, textureCoordinate);
     
     mediump float r = pixel.r;
     mediump float g = pixel.g;
     mediump float b = pixel.b;
     mediump float lum = 0.299 * r + 0.587 * g + 0.114 * b;
     mediump vec3 hsv = rgb2hsv(vec3(r, g, b));
     mediump float weight = 1.0 - max(0.0, min(1.0, hsv.z * 2.0));

     
         hsv.z += hsv.z * weight;
         hsv.z = max(0.0, min(1.0, hsv.z));
     
     
     weight = max(0.0, min(1.0, (hsv.z - 0.7) * 3.0)) * 1.0;
     //hsv.z -= hsv.z * weight;
     
     pixel.rgb = hsv2rgb(hsv);
     
     
     // Save the result
     gl_FragColor = pixel;
 }
 );

#pragma mark -
#pragma mark Initialization and teardown

- (id)init;
{
    if (!(self = [super initWithFragmentShaderFromString:kGravyBrightnessFragmentShaderString]))
    {
        return nil;
    }
    return self;
}

@end
