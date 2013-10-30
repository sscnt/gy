//
//  GPUSaturationImageFilter.m
//  Gravy_1.0
//
//  Created by SSC on 2013/10/27.
//  Copyright (c) 2013年 SSC. All rights reserved.
//

#import "GPUSaturationImageFilter.h"

@implementation GPUSaturationImageFilter

NSString *const kGravySaturationFragmentShaderString = SHADER_STRING
(
 precision highp float;
 varying vec2 textureCoordinate;
 uniform sampler2D inputImageTexture;
 uniform mediump float stVibranceWeight;
 uniform mediump float stSaturationWeight;
 
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
     highp vec4 pixel   = texture2D(inputImageTexture, textureCoordinate);
     
     mediump float m60 = 0.01665;
     
     mediump float r = pixel.r;
     mediump float g = pixel.g;
     mediump float b = pixel.b;
     mediump float y = 0.299 * r + 0.587 * g + 0.114 * b;
     
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
     
     mediump float _s;
     int index = 0;

     _s = (1.0 - cos(s * 3.1415927)) * stSaturationWeight;
     _s *= (1.0 - cos(y * 3.1415927)) * stVibranceWeight;
     _s *= 0.4 * (0.5 - cos(h * 0.0174533)) + 0.8;
     s += _s;
     //s += stSaturationWeight;
     
     s = max(0.0, min(1.0, s));
     
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
    if (!(self = [super initWithFragmentShaderFromString:kGravySaturationFragmentShaderString]))
    {
        return nil;
    }
    stSaturationWeightUniform = [filterProgram uniformIndex:@"stSaturationWeight"];
    self.stSaturationWeight = 0.0;
    stVibranceWeightUniform = [filterProgram uniformIndex:@"stVibranceWeight"];
    self.stVibranceWeight = 0.0;
    return self;
}

- (void)setStSaturationWeight:(float)stSaturationWeight
{
    _stSaturationWeight = MAX(-1.0f, MIN(1.0f, stSaturationWeight));
    [self setFloat:_stSaturationWeight forUniform:stSaturationWeightUniform program:filterProgram];
}

- (void)setStVibranceWeight:(float)stVibranceWeight
{
    _stVibranceWeight = MAX(-1.0, MIN(1.0, stVibranceWeight));
    [self setFloat:_stVibranceWeight forUniform:stVibranceWeightUniform program:filterProgram];
}

@end
