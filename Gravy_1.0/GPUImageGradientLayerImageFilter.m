//
//  GPUImageGradientLayer.m
//  Gravy_1.0
//
//  Created by SSC on 2013/11/02.
//  Copyright (c) 2013年 SSC. All rights reserved.
//

#import "GPUImageGradientLayerImageFilter.h"

@implementation GPUImageGradientLayerImageFilter

NSString *const kGPUImageGradientLayerFragmentShaderString = SHADER_STRING
(
 precision highp float;
 varying vec2 textureCoordinate;
 uniform sampler2D inputImageTexture;
 uniform highp float locations[20];
 uniform highp float midpoints[20];
 uniform highp vec4 colors[20];
 
 float round(float a){
     float b = floor(a);
     b = floor((a - b) * 10.0);
     if(int(b) < 5){
         return floor(a);
     }
     return ceil(a);
 }
 
 int index(float x){
     highp float loc = 0.0;
     for(int i = 1;i < 20;i++){
         loc = locations[i];
         if(x < loc){
             return i - 1;
         }
     }
     return 0;
 }
 
 void main()
 {
     highp vec4 pixel   = texture2D(inputImageTexture, textureCoordinate);
     
     mediump float m60 = 0.01665;
     
     highp float x = textureCoordinate.x;
     int index = index(x);
     highp float startLocation = locations[index];
     highp float endLocation = locations[index + 1];
     highp vec4 startColor = colors[index];
     highp vec4 endColor = colors[index + 1];
     
     highp float r = startColor.r;
     highp float g = startColor.g;
     highp float b = startColor.b;
     highp float a = startColor.a;
     
     highp float rdiff = endColor.r - startColor.r;
     highp float gdiff = endColor.g - startColor.g;
     highp float bdiff = endColor.b - startColor.b;
     highp float adiff = endColor.a - startColor.a;

     highp float relativeX;
     relativeX = (x - startLocation) / (endLocation - startLocation);
     
     r += rdiff * relativeX;
     g += gdiff * relativeX;
     b += bdiff * relativeX;
     a += adiff * relativeX;
     
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


- (id)init;
{
    if (!(self = [super initWithFragmentShaderFromString:kGPUImageGradientLayerFragmentShaderString]))
    {
        return nil;
    }
    locationsUniform = [filterProgram uniformIndex:@"locations"];
    midpointUniform = [filterProgram uniformIndex:@"midpoints"];
    colorsUniform = [filterProgram uniformIndex:@"colors"];
    index = 0;
    return self;
}

- (void)addColorRed:(float)red Green:(float)green Blue:(float)blue Opacity:(float)opacity Location:(int)location Midpoint:(int)midpoint
{
    GPUVector4 vec = {red / 255.0f, green / 255.0f, blue / 255.0f, opacity / 100.0f};
    colors[index] = vec;
    locations[index] = (float)location / 4096.0f;
    midpoints[index] = (float)midpoint;
    index++;
    [self setFloatArray:locations length:20 forUniform:locationsUniform program:filterProgram];
    [self setFloatArray:midpoints length:20 forUniform:midpointUniform program:filterProgram];
    [self setVec4Array:colors length:20 forUniform:colorsUniform program:filterProgram];
}

- (UIImage*)process
{
    return nil;
}

@end
