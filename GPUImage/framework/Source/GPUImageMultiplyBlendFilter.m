#import "GPUImageMultiplyBlendFilter.h"

NSString *const kGPUImageMultiplyBlendFragmentShaderString = SHADER_STRING
(
 varying highp vec2 textureCoordinate;
 varying highp vec2 textureCoordinate2;

 uniform sampler2D inputImageTexture;
 uniform sampler2D inputImageTexture2;
 
 void main()
 {
     mediump vec4 base = texture2D(inputImageTexture, textureCoordinate);
     mediump vec4 overlayer = texture2D(inputImageTexture2, textureCoordinate2);
          
     //gl_FragColor = overlayer * base + overlayer * (1.0 - base.a) + base * (1.0 - overlayer.a);
     mediump vec3 rgb = base.rgb * overlayer.rgb * overlayer.a + (1.0 - overlayer.a) * base.rgb;
     gl_FragColor = vec4(rgb, 1.0);
     
 }
);

@implementation GPUImageMultiplyBlendFilter

- (id)init;
{
    if (!(self = [super initWithFragmentShaderFromString:kGPUImageMultiplyBlendFragmentShaderString]))
    {
		return nil;
    }
    
    return self;
}

@end

