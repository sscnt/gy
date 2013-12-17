//  Created by Jorge Garcia on 9/5/12.

#import "GPUImageNormalBlendFilter.h"
/*
 This equation is a simplification of the general blending equation. It assumes the destination color is opaque, and therefore drops the destination color's alpha term.
 
 D = C1 * C1a + C2 * C2a * (1 - C1a)
 where D is the resultant color, C1 is the color of the first element, C1a is the alpha of the first element, C2 is the second element color, C2a is the alpha of the second element. The destination alpha is calculated with:
 
 Da = C1a + C2a * (1 - C1a)
 The resultant color is premultiplied with the alpha. To restore the color to the unmultiplied values, just divide by Da, the resultant alpha.
 
 http://stackoverflow.com/questions/1724946/blend-mode-on-a-transparent-and-semi-transparent-background
 
 For some reason Photoshop behaves 
 D = C1 + C2 * C2a * (1 - C1a)
 */

NSString *const kGPUImageNormalBlendFragmentShaderString = SHADER_STRING
(
 varying highp vec2 textureCoordinate;
 varying highp vec2 textureCoordinate2;
 
 uniform sampler2D inputImageTexture;
 uniform sampler2D inputImageTexture2;
 
 void main()
 {
     mediump vec4 base = texture2D(inputImageTexture, textureCoordinate);
     mediump vec4 overlay = texture2D(inputImageTexture2, textureCoordinate2);

     mediump float r = base.r * base.a * (1.0 - overlay.a) + overlay.r * overlay.a;
     mediump float g = base.g * base.a * (1.0 - overlay.a) + overlay.g * overlay.a;
     mediump float b = base.b * base.a * (1.0 - overlay.a) + overlay.b * overlay.a;
     
     
     gl_FragColor = vec4(r, g, b, base.a);
 }
);

@implementation GPUImageNormalBlendFilter

- (id)init;
{
    if (!(self = [super initWithFragmentShaderFromString:kGPUImageNormalBlendFragmentShaderString]))
    {
		return nil;
    }
    
    return self;
}

@end