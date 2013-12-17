#import "GPUImageLightenBlendFilter.h"

NSString *const kGPUImageLightenBlendFragmentShaderString = SHADER_STRING
(
 varying highp vec2 textureCoordinate;
 varying highp vec2 textureCoordinate2;
 
 uniform sampler2D inputImageTexture;
 uniform sampler2D inputImageTexture2;
 
 void main()
 {
     mediump vec4 textureColor = texture2D(inputImageTexture, textureCoordinate);
     mediump vec4 textureColor2 = texture2D(inputImageTexture2, textureCoordinate2);
     mediump vec3 result = max(textureColor.rgb, textureColor2.rgb);
     result = result * textureColor2.a + (1.0 - textureColor2.a) * textureColor.rgb;
     
     gl_FragColor = vec4(result, 1.0);
 }
 );


@implementation GPUImageLightenBlendFilter

- (id)init;
{
    if (!(self = [super initWithFragmentShaderFromString:kGPUImageLightenBlendFragmentShaderString]))
    {
		return nil;
    }
    
    return self;
}

@end

