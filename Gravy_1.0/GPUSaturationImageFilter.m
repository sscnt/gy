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
 uniform mediump float splineTableSaturation[1001];
 uniform mediump float splineTableVibrance[361];
 
 void main()
 {
     highp vec4 pixel   = texture2D(inputImageTexture, textureCoordinate);
     
     mediump float m60 = 0.0166667;
     
     mediump float r = pixel.r;
     mediump float g = pixel.g;
     mediump float b = pixel.b;
     
     mediump float max = max(r, max(g, b));
     mediump float min = min(r, min(g, b));
     mediump float h = 0.0;
     
     if(max == r){
         h = 60.0 * (g - b) / (max - min);
     } else if(max == g){
         h = 60.0 * (b - r) / (max - min) + 120.0;
     } else if(max == b){
         h = 60.0 * (r - g) / (max - min) + 240.0;
     }
     if(h < 0.0){
         h += 360.0;
     }
     
     mediump float s;
     if(max == 0.0) {
         s = 0.0;
     } else {
         s = (max - min) / max;
     }
     mediump float v = max;
     mediump float _s;
     int index = 0;
     
     index = int(max(0.0, min(1000.0, float(floor(s * 1000.0)))));
     _s = splineTableSaturation[index];
     index = int(max(0.0, min(1000.0, float(floor(v * 1000.0)))));
     _s *= splineTableSaturation[index];
     s += _s;
     
     s = max(0.0, min(1.0, s));
     int hi = int(floor(mod(h * m60, 6.0)));
     mediump float f = (h * m60) - float(floor(h * m60));
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
     } else if(hi == 2){
         r = p;
         g = q;
         b = v;
     } else if(hi == 2){
         r = t;
         g = p;
         b = v;
     } else if(hi == 2){
         r = v;
         g = p;
         b = q;
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
    splineTableSaturationUniform = [filterProgram uniformIndex:@"splineTableSaturation"];
    splineTableVibranceUniform = [filterProgram uniformIndex:@"splineTableVibrance"];
    return self;
}


- (void)initSaturationSpline
{
    float splineTableSaturation[1001] = {0.1};
    
    
    float t, spx, spy, b1, b2, b3, b4,x0, x1, x2, x3, x4, x5, y0, y1, y2, y3, y4, y5;
    float m6 = 1.0f / 6.0f;
    
    float stWeight = (_stSaturationWeight < 0.0f) ? -_stSaturationWeight : _stSaturationWeight;
    float vbWeight = (_stVibranceWeight < 0.0f) ? -_stVibranceWeight : _stVibranceWeight;

    
    for(int i = 0;i < 1000;i++){
        if(_stVibranceWeight < 0){
            t = (float)i * 0.001;
            spx = 2.0f * t * (1.0f - t) * 0.70f + t * t * 1.0f;
            spy = 2.0f * t * (1.0f - t) * stWeight + t * t * vbWeight;
            if(spx < 0.0f || spx > 1.0f) continue;
            if(spy < 0.0f || spy > 1.0f) continue;
            splineTableSaturation[(int)roundf(spx)] = spy;
        } else {
            t = (float)i * 0.001;
            b1 = (-1.0f * t * t * t + 3.0f * t * t - 3.0f * t + 1.0f) * m6;
            b2 = (3.0f * t * t * t - 6.0f * t * t + 4.0f) * m6;
            b3 = (-3.0f * t * t * t + 3.0f * t * t + 3.0f * t + 1.0f) * m6;
            b4 = (t * t * t) * m6;
            x2 = 0.50f - vbWeight;
            x3 = 0.50f + vbWeight;
            x0 = -x2;
            x5 = 2.0f - x3;
            x1 = 0;
            x4 = 1.0f;
            y2 = y3 = stWeight;
            y1 = y4 = 0.0f;
            y0 = y5 = -y2;
            
            spx = x1 * b1 + x2 * b2 + x3 * b3 + x4 * b4;
            spy = y1 * b1 + y2 * b2 + y3 * b3 + y4 * b4;
            if(spx < 0.0f || spx > 1.0f) continue;
            if(spy < 0.0f || spy > 1.0f) continue;
            splineTableSaturation[(int)roundf(spx * 1000.0f)] = spy;
            spx = x0 * b1 + x1 * b2 + x2 * b3 + x3 * b4;
            spy = y0 * b1 + y1 * b2 + y2 * b3 + y3 * b4;
            if(spx < 0.0f || spx > 1.0f) continue;
            if(spy < 0.0f || spy > 1.0f) continue;
            splineTableSaturation[(int)roundf(spx * 1000.0f)] = spy;
            spx = x2 * b1 + x3 * b2 + x4 * b3 + x5 * b4;
            spy = y2 * b1 + y3 * b2 + y4 * b3 + y5 * b4;
            if(spx < 0.0f || spx > 1.0f) continue;
            if(spy < 0.0f || spy > 1.0f) continue;
            splineTableSaturation[(int)roundf(spx * 1000.0f)] = spy;
        }
        
    }
    
    [self setFloatArray:splineTableSaturation length:1001 forUniform:splineTableSaturationUniform program:filterProgram];
}

- (void)initVibranceSpline
{
    
}

- (void)setStSaturationWeight:(float)stSaturationWeight
{
    _stSaturationWeight = MAX(-0.5f, MIN(0.5f, stSaturationWeight));
}

- (void)setStVibranceWeight:(float)stVibranceWeight
{
    _stVibranceWeight = MAX(-0.5f, MIN(0.5f, stVibranceWeight));
}

@end
