//
//  GPUImageVividLightBlendFIlter.m
//  Gravy_1.0
//
//  Created by SSC on 2013/12/01.
//  Copyright (c) 2013年 SSC. All rights reserved.
//

#import "GPUImageVividLightBlendFilter.h"


#if TARGET_IPHONE_SIMULATOR || TARGET_OS_IPHONE
NSString *const kGPUImageVividLightBlendFragmentShaderString = SHADER_STRING
(
 varying highp vec2 textureCoordinate;
 varying highp vec2 textureCoordinate2;
 
 uniform sampler2D inputImageTexture;
 uniform sampler2D inputImageTexture2;
 
 const highp vec3 W = vec3(0.2125, 0.7154, 0.0721);
 
 void main()
 {
     mediump vec4 base = texture2D(inputImageTexture, textureCoordinate);
     mediump vec4 overlay = texture2D(inputImageTexture2, textureCoordinate2);
     
     
     mediump float ra;
     if (overlay.r < 0.5) {
         ra = 1.0 - (1.0 - base.r) / (2.0 * overlay.r);
     } else {
         ra = base.r / (1.0 - 2.0 * (overlay.r - 0.5));
     }
     mediump float ga;
     if (overlay.g < 0.5) {
         ga = 1.0 - (1.0 - base.g) / (2.0 * overlay.g);
     } else {
         ga = base.g / (1.0 - 2.0 * (overlay.g - 0.5));
     }
     mediump float ba;
     if (overlay.b < 0.5) {
         ba = 1.0 - (1.0 - base.b) / (2.0 * overlay.b);
     } else {
         ba = base.b / (1.0 - 2.0 * (overlay.b - 0.5));
     }
     
     ra = ra * overlay.a + (1.0 - overlay.a) * base.r;
     ga = ga * overlay.a + (1.0 - overlay.a) * base.g;
     ba = ba * overlay.a + (1.0 - overlay.a) * base.b;
     
     gl_FragColor = vec4(ra, ga, ba, 1.0);
 }
 );
#else
NSString *const kGPUImageVividLightBlendFragmentShaderString = SHADER_STRING
(
 varying vec2 textureCoordinate;
 varying vec2 textureCoordinate2;
 
 uniform sampler2D inputImageTexture;
 uniform sampler2D inputImageTexture2;
 
 const vec3 W = vec3(0.2125, 0.7154, 0.0721);
 
 void main()
 {
     vec4 base = texture2D(inputImageTexture, textureCoordinate);
     vec4 overlay = texture2D(inputImageTexture2, textureCoordinate2);
     
     float ra;
     if (2.0 * overlay.r < overlay.a) {
         ra = 2.0 * overlay.r * base.r + overlay.r * (1.0 - base.a) + base.r * (1.0 - overlay.a);
     } else {
         ra = overlay.a * base.a - 2.0 * (base.a - base.r) * (overlay.a - overlay.r) + overlay.r * (1.0 - base.a) + base.r * (1.0 - overlay.a);
     }
     
     float ga;
     if (2.0 * overlay.g < overlay.a) {
         ga = 2.0 * overlay.g * base.g + overlay.g * (1.0 - base.a) + base.g * (1.0 - overlay.a);
     } else {
         ga = overlay.a * base.a - 2.0 * (base.a - base.g) * (overlay.a - overlay.g) + overlay.g * (1.0 - base.a) + base.g * (1.0 - overlay.a);
     }
     
     float ba;
     if (2.0 * overlay.b < overlay.a) {
         ba = 2.0 * overlay.b * base.b + overlay.b * (1.0 - base.a) + base.b * (1.0 - overlay.a);
     } else {
         ba = overlay.a * base.a - 2.0 * (base.a - base.b) * (overlay.a - overlay.b) + overlay.b * (1.0 - base.a) + base.b * (1.0 - overlay.a);
     }
     
     gl_FragColor = vec4(ra, ga, ba, 1.0);
 }
 );
#endif



@implementation GPUImageVividLightBlendFilter

- (id)init;
{
    if (!(self = [super initWithFragmentShaderFromString:kGPUImageVividLightBlendFragmentShaderString]))
    {
		return nil;
    }
    
    return self;
}

@end

