#import "GPUImageSoftLightBlendFilter.h"

#if TARGET_IPHONE_SIMULATOR || TARGET_OS_IPHONE
NSString *const kGPUImageSoftLightBlendFragmentShaderString = SHADER_STRING
(
 varying highp vec2 textureCoordinate;
 varying highp vec2 textureCoordinate2;

 uniform sampler2D inputImageTexture;
 uniform sampler2D inputImageTexture2;
 
 void main()
 {
     mediump vec4 base = texture2D(inputImageTexture, textureCoordinate);
     mediump vec4 overlay = texture2D(inputImageTexture2, textureCoordinate2);
     
     mediump float r;
     mediump float g;
     mediump float b;
     
     if(overlay.r  < 0.5){
         r = 2.0 * overlay.r * base.r + base.r * base.r * (1.0 - 2.0 * overlay.r);
     } else{
         r = 2.0 * base.r * (1.0 - overlay.r) + sqrt(base.r) * (2.0 * overlay.r - 1.0);
     }
     
     if(overlay.g  < 0.5){
         g = 2.0 * overlay.g * base.g + base.g * base.g * (1.0 - 2.0 * overlay.g);
     } else{
         g = 2.0 * base.g * (1.0 - overlay.g) + sqrt(base.g) * (2.0 * overlay.g - 1.0);
     }
     
     if(overlay.b  < 0.5){
         b = 2.0 * overlay.b * base.b + base.b * base.b * (1.0 - 2.0 * overlay.b);
     } else{
         b = 2.0 * base.b * (1.0 - overlay.b) + sqrt(base.b) * (2.0 * overlay.b - 1.0);
     }
     
     r = r * overlay.a + base.r * (1.0 - overlay.a);
     g = g * overlay.a + base.g * (1.0 - overlay.a);
     b = b * overlay.a + base.b * (1.0 - overlay.a);
     
     gl_FragColor = vec4(r, g, b, 1.0);
     
     //gl_FragColor = base * (overlay.a * (base / base.a) + (2.0 * overlay * (1.0 - (base / base.a)))) + overlay * (1.0 - base.a) + base * (1.0 - overlay.a);
 }
);
#else
NSString *const kGPUImageSoftLightBlendFragmentShaderString = SHADER_STRING
(
 varying vec2 textureCoordinate;
 varying vec2 textureCoordinate2;
 
 uniform sampler2D inputImageTexture;
 uniform sampler2D inputImageTexture2;
 
 void main()
 {
     vec4 base = texture2D(inputImageTexture, textureCoordinate);
     vec4 overlay = texture2D(inputImageTexture2, textureCoordinate2);
     
     gl_FragColor = base * (overlay.a * (base / base.a) + (2.0 * overlay * (1.0 - (base / base.a)))) + overlay * (1.0 - base.a) + base * (1.0 - overlay.a);
 }
);
#endif

@implementation GPUImageSoftLightBlendFilter

- (id)init;
{
    if (!(self = [super initWithFragmentShaderFromString:kGPUImageSoftLightBlendFragmentShaderString]))
    {
		return nil;
    }
    
    return self;
}

@end

