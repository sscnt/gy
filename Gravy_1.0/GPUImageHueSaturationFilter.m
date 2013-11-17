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
 
 uniform mediump float hue;
 uniform mediump float saturation;
 uniform mediump float lightness;

 
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
     
     mediump float m60 = 0.01665;
     
     mediump float x = textureCoordinate.x - offsetX;
     mediump float y = textureCoordinate.y - offsetY;
     
     if(style == 1){
         gl_FragColor = linear(x, y);
     } else if(style == 2){
         gl_FragColor = radial(x, y);
     } else{
         gl_FragColor = pixel;
     }
 }
 );


- (id)init;
{
    if (!(self = [super initWithFragmentShaderFromString:kGPUImageHueSaturationFilterFragmentShaderString]))
    {
        return nil;
    }

    
    return self;
}

@end
