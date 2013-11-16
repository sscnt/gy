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
 uniform mediump float shadowsAmount;
 uniform mediump float shadowsRadius;
 uniform mediump float highlightsAmount;
 
 
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
 
 vec3 rgb2yuv(vec3 rgb){
     mediump float r = rgb.r * 0.8588 + 0.0625;
     mediump float g = rgb.g * 0.8588 + 0.0625;
     mediump float b = rgb.b * 0.8588 + 0.0625;
     
     mediump float y = 0.299 * r + 0.587 * g + 0.114 * b;
     mediump float u = -0.169 * r - 0.331 * g + 0.500 * b;
     mediump float v = 0.500 * r - 0.419 * g - 0.081 * b;
     return vec3(y, u, v);
 }
 
 vec3 yuv2rgb(vec3 yuv){
     mediump float r = yuv.x + 1.402 * yuv.z - 0.0625;
     mediump float g = yuv.x - 0.344 * yuv.y - 0.714 * yuv.z - 0.0625;
     mediump float b = yuv.x + 1.772 * yuv.y - 0.0625;
     
     r *= 1.164;
     g *= 1.164;
     b *= 1.164;
     
     r = max(0.0, min(1.0, r));
     g = max(0.0, min(1.0, g));
     b = max(0.0, min(1.0, b));
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
 
 vec3 adjustLevels(mediump vec3 rgb){
     mediump vec3 yuv = rgb2yuv(rgb);
     mediump vec3 hsv = rgb2hsv(rgb);
     mediump float saturation = hsv.y;
     mediump float y = yuv.x;
     mediump float _y;
     
     if(y > shadowsRadius){
         _y = (y - shadowsRadius) * 0.500 / (1.0 - shadowsRadius) + 0.500;
     } else {
         _y = y * 0.500 / shadowsRadius;
     }

     yuv.x = max(0.0 , min(1.0, _y));
     
     hsv = rgb2hsv(yuv2rgb(yuv));
     hsv.y = saturation;
     return hsv2rgb(hsv);
 }
 
 void main()
 {
     mediump vec4 pixel   = texture2D(inputImageTexture, textureCoordinate);
     
     mediump float r = pixel.r;
     mediump float g = pixel.g;
     mediump float b = pixel.b;
     mediump float lum = 0.299 * r + 0.587 * g + 0.114 * b;
     mediump vec3 hsv = rgb2hsv(vec3(r, g, b));
     mediump float increment;
     
     /*
      * shadows 1.5 - 3.0
      */
     mediump float weight = 1.0 - max(0.0, min(1.0, hsv.z * shadowsAmount));

     increment = hsv.z * weight;
     increment = sin((1.0 - hsv.z) * 3.14159265359) * 0.3 * weight;
     //increment = sqrt(increment);
     hsv.z += increment;
     hsv.z = max(0.0, min(1.0, hsv.z));
     
     /*
      * highlights 0.0 - 0.5
      */
     weight = max(0.0, min(1.0, (hsv.z - 0.7) * 3.333)) * 0.1;
     //hsv.z -= hsv.z * weight;
     
     // Contrast
     mediump vec3 rgb = hsv2rgb(hsv);
     mediump float contrast = 1.0 + 0.5 * 0.0;
     contrast *= contrast;
     
     mediump float value;
     value = rgb.r;
     value -= 0.5;
     value *= contrast;
     value += 0.5;
     rgb.r = min(1.0, max(0.0, value));
     
     value = rgb.b;
     value -= 0.5;
     value *= contrast;
     value += 0.5;
     rgb.b = min(1.0, max(0.0, value));
     
     value = rgb.g;
     value -= 0.5;
     value *= contrast;
     value += 0.5;
     rgb.g = min(1.0, max(0.0, value));
     
     // Levels
     rgb = adjustLevels(rgb);
     
     pixel.rgb = rgb;
     
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
    shadowsAmountUniform = [filterProgram uniformIndex:@"shadowsAmount"];
    self.shadowsAmount = 0.0f;
    shadowsRadiusUniform = [filterProgram uniformIndex:@"shadowsRadius"];
    self.shadowsRadius = 0.0f;
    highlightsAmountUniform = [filterProgram uniformIndex:@"highlightsAmount"];
    self.highlightsAmount = 0.0f;
    return self;
}

- (void)setShadowsAmount:(CGFloat)shadows
{
    _shadowsAmount = (1.0f - shadows) * 1.5f + 1.5f;
    _shadowsAmount = MIN(3.0f, MAX(1.5f, _shadowsAmount));
    [self setFloat:_shadowsAmount forUniform:shadowsAmountUniform program:filterProgram];
}

- (void)setShadowsRadius:(float)shadowsRadius
{
    _shadowsRadius = 0.5 + 0.25 * shadowsRadius;
    _shadowsRadius = MIN(1.0f, MAX(0.0f, _shadowsRadius));
    [self setFloat:_shadowsRadius forUniform:shadowsRadiusUniform program:filterProgram];
}

- (void)setHighlightsAmount:(CGFloat)highlights
{
    _highlightsAmount = 50.0f * highlights;
}

@end
