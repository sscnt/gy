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
 uniform mediump float locations[20];
 uniform mediump vec4 colors[20];
 
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
     for(int i = 0;i < 20;i++){
         loc = locations[i];
         if(x < loc){
             return i;
         }
     }
     return 0;
 }
 
 void main()
 {
     highp vec4 pixel   = texture2D(inputImageTexture, textureCoordinate);
     
     mediump float m60 = 0.01665;
     
     highp float r = pixel.r;
     highp float g = pixel.g;
     highp float b = pixel.b;
     highp float x = textureCoordinate.x;
     int index = index(x);
     highp vec4 color = colors[index];
     
     pixel.r = r;
     pixel.g = g;
     pixel.b = b;
     
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
    index = 0;
    return self;
}

- (void)addColorRed:(float)red Green:(float)green Blue:(float)blue Opacity:(float)opacity Location:(int)location
{
    GPUVector4 vec = {red / 255.0f, green / 255.0f, blue / 255.0f, opacity / 100.0f};
    colors[index] = vec;
    locations[index] = (float)location / 4096.0f;
    index++;
    [self setFloatArray:locations length:20 forUniform:locationsUniform program:filterProgram];
    [self setVec4Array:colors forUniform:colorsUniform program:filterProgram];
}

- (UIImage*)process
{
    return nil;
}

@end
