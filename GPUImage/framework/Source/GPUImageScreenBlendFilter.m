#import "GPUImageScreenBlendFilter.h"

#if TARGET_IPHONE_SIMULATOR || TARGET_OS_IPHONE
NSString *const kGPUImageScreenBlendFragmentShaderString = SHADER_STRING
(
 varying highp vec2 textureCoordinate;
 varying highp vec2 textureCoordinate2;

 uniform sampler2D inputImageTexture;
 uniform sampler2D inputImageTexture2;
 
 void main()
 {
     mediump vec4 base = texture2D(inputImageTexture, textureCoordinate);
     mediump vec4 overlay = texture2D(inputImageTexture2, textureCoordinate2);
     highp float r = (1.0 - ((1.0 - base.r) * (1.0 - overlay.r))) * overlay.a + base.r * (1.0 - overlay.a);
     highp float g = (1.0 - ((1.0 - base.g) * (1.0 - overlay.g))) * overlay.a + base.g * (1.0 - overlay.a);
     highp float b = (1.0 - ((1.0 - base.b) * (1.0 - overlay.b))) * overlay.a + base.b * (1.0 - overlay.a);
     gl_FragColor = vec4(r, g, b, 1.0);
     
     /*
     mediump vec4 whiteColor = vec4(1.0);
     gl_FragColor = whiteColor - ((whiteColor - textureColor2) * (whiteColor - textureColor));
      */
 }
);
#else
NSString *const kGPUImageScreenBlendFragmentShaderString = SHADER_STRING
(
 varying vec2 textureCoordinate;
 varying vec2 textureCoordinate2;
 
 uniform sampler2D inputImageTexture;
 uniform sampler2D inputImageTexture2;
 
 void main()
 {
     vec4 textureColor = texture2D(inputImageTexture, textureCoordinate);
     vec4 textureColor2 = texture2D(inputImageTexture2, textureCoordinate2);
     vec4 whiteColor = vec4(1.0);
     gl_FragColor = whiteColor - ((whiteColor - textureColor2) * (whiteColor - textureColor));
 }
);
#endif

@implementation GPUImageScreenBlendFilter

- (id)init;
{
    if (!(self = [super initWithFragmentShaderFromString:kGPUImageScreenBlendFragmentShaderString]))
    {
		return nil;
    }
    
    return self;
}

@end

