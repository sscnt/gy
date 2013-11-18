//
//  GPUImageHueSaturationFilter.m
//  Gravy_1.0
//
//  Created by SSC on 2013/11/17.
//  Copyright (c) 2013年 SSC. All rights reserved.
//

#import "GPUImageHueSaturationFilter.h"

@implementation GPUImageHueSaturationFilter

NSString *const kGPUImageHueSaturationFilterFragmentShaderString = SHADER_STRING
(
 precision highp float;
 varying vec2 textureCoordinate;
 uniform sampler2D inputImageTexture;
 
 uniform int colorize;
 uniform mediump float hue;
 uniform mediump float saturation;
 uniform mediump float lightness;
 
 vec3 rgb2hsv(vec3 color){
     mediump float r = color.r;
     mediump float g = color.g;
     mediump float b = color.b;
     
     mediump float max = max(r, max(g, b));
     mediump float min = min(r, min(g, b));
     mediump float h = 0.0;
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
     
     mediump float s;
     if(max == 0.0) {
         s = 0.0;
     } else {
         s = (max - min) / max;
     }
     mediump float v = max;
     
     return vec3(h, s, v);
 }
 
 vec3 hsv2rgb(vec3 color){
     mediump float h = color.r;
     mediump float s = color.g;
     mediump float v = color.b;
     mediump float r;
     mediump float g;
     mediump float b;
     mediump float m60 = 0.01665;
     int hi = int(mod(float(floor(h * m60)), 6.0));
     mediump float f = (h * m60) - float(hi);
     mediump float p = v * (1.0 - s);
     mediump float q = v * (1.0 - s * f);
     mediump float t = v * (1.0 - s * (1.0 - f));
     
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
     mediump vec3 inputHsv = rgb2hsv(pixel.rgb);

     if(colorize == 1){
         mediump vec3 hsv;
         hsv.x = inputHsv.x;
         hsv.y = saturation;
         if(inputHsv.y > inputHsv.z){
             hsv.z = inputHsv.z;
         } else{
             hsv.z = inputHsv.y;
         }
         hsv.z = (1.0 - hsv.z) * 0.5 + 0.5;
         hsv.z = min(1.0, max(0.0, hsv.z));
         pixel.rgb = hsv2rgb(hsv);
     }
     
     gl_FragColor = pixel;
 }
 );


- (id)init;
{
    if (!(self = [super initWithFragmentShaderFromString:kGPUImageHueSaturationFilterFragmentShaderString]))
    {
        return nil;
    }

    hueUniform = [filterProgram uniformIndex:@"hue"];
    self.hue = 0.0f;
    
    saturationUniform = [filterProgram uniformIndex:@"saturation"];
    self.saturation = 0.0f;
    
    lightnessUniform = [filterProgram uniformIndex:@"lightness"];
    self.lightness = 0.0f;
    
    colorizeUniform = [filterProgram uniformIndex:@"colorize"];
    self.colorize = NO;
    
    return self;
}

- (void)setColorize:(BOOL)colorize
{
    _colorize = colorize;
    [self setInteger:_colorize forUniform:colorizeUniform program:filterProgram];
}

- (void)setSaturation:(float)saturation
{
    _saturation = saturation / 100.0f;
    _saturation = MAX(0.0f, MIN(1.0f, _saturation));
    [self setFloat:_saturation forUniform:saturationUniform program:filterProgram];
}

- (void)setLightness:(float)lightness
{
    _lightness = lightness / 100.0f;
    _lightness = MAX(-1.0f, MIN(1.0f, _lightness));
    [self setFloat:_lightness forUniform:lightnessUniform program:filterProgram];
}

- (void)setHue:(float)hue
{
    _hue = hue;
    _hue = MAX(0.0f, MIN(360.0f, _hue));
    [self setFloat:_hue forUniform:hueUniform program:filterProgram];
}

@end
