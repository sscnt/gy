#import "GPUImageOverlayBlendFilter.h"

NSString *const kGPUImageOverlayBlendFragmentShaderString = SHADER_STRING
(
 varying highp vec2 textureCoordinate;
 varying highp vec2 textureCoordinate2;

 uniform sampler2D inputImageTexture;
 uniform sampler2D inputImageTexture2;
 
 void main()
 {
     mediump vec4 base = texture2D(inputImageTexture, textureCoordinate);
     mediump vec4 overlay = texture2D(inputImageTexture2, textureCoordinate2);
     mediump float ra;
     if(base.r < 0.5){
         ra = (base.r * overlay.r * 2.0) * overlay.a + (1.0 - overlay.a) * base.r;
     } else{
         ra = (2.0 * (base.r + overlay.r - base.r * overlay.r) - 1.0) * overlay.a + (1.0 - overlay.a) * base.r;
     }
     mediump float ga;
     if(base.g < 0.5){
         ga = (base.g * overlay.g * 2.0) * overlay.a + (1.0 - overlay.a) * base.g;
     } else{
         ga = (2.0 * (base.g + overlay.g - base.g * overlay.g) - 1.0) * overlay.a + (1.0 - overlay.a) * base.g;
     }
     mediump float ba;
     if(base.b < 0.5){
         ba = (base.b * overlay.b * 2.0) * overlay.a + (1.0 - overlay.a) * base.b;
     } else{
         ba = (2.0 * (base.b + overlay.b - base.b * overlay.b) - 1.0) * overlay.a + (1.0 - overlay.a) * base.b;
     }
     
     /*
     mediump float ra;
     if (2.0 * base.r < base.a) {
         ra = 2.0 * overlay.r * base.r + overlay.r * (1.0 - base.a) + base.r * (1.0 - overlay.a);
     } else {
         ra = overlay.a * base.a - 2.0 * (base.a - base.r) * (overlay.a - overlay.r) + overlay.r * (1.0 - base.a) + base.r * (1.0 - overlay.a);
     }
     
     mediump float ga;
     if (2.0 * base.g < base.a) {
         ga = 2.0 * overlay.g * base.g + overlay.g * (1.0 - base.a) + base.g * (1.0 - overlay.a);
     } else {
         ga = overlay.a * base.a - 2.0 * (base.a - base.g) * (overlay.a - overlay.g) + overlay.g * (1.0 - base.a) + base.g * (1.0 - overlay.a);
     }
     
     mediump float ba;
     if (2.0 * base.b < base.a) {
         ba = 2.0 * overlay.b * base.b + overlay.b * (1.0 - base.a) + base.b * (1.0 - overlay.a);
     } else {
         ba = overlay.a * base.a - 2.0 * (base.a - base.b) * (overlay.a - overlay.b) + overlay.b * (1.0 - base.a) + base.b * (1.0 - overlay.a);
     }
      */
     
     gl_FragColor = vec4(ra, ga, ba, 1.0);
 }
);

@implementation GPUImageOverlayBlendFilter

- (id)init;
{
  if (!(self = [super initWithFragmentShaderFromString:kGPUImageOverlayBlendFragmentShaderString]))
  {
		return nil;
  }
  
  return self;
}

@end

