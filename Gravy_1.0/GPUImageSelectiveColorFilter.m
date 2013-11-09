//
//  GPUImageSelectiveColorFilter.m
//  Gravy_1.0
//
//  Created by SSC on 2013/11/07.
//  Copyright (c) 2013年 SSC. All rights reserved.
//

#import "GPUImageSelectiveColorFilter.h"

@implementation GPUImageSelectiveColorFilter

NSString *const kGPUImageSelectiveColorFilterFragmentShaderString = SHADER_STRING
(
 precision highp float;
 varying vec2 textureCoordinate;
 uniform sampler2D inputImageTexture;
 
 uniform highp float redsCyan;
 uniform highp float redsMagenta;
 uniform highp float redsYellow;
 uniform highp float redsBlack;
 
 uniform highp float yellowsCyan;
 uniform highp float yellowsMagenta;
 uniform highp float yellowsYellow;
 uniform highp float yellowsBlack;
 
 uniform highp float greensCyan;
 uniform highp float greensMagenta;
 uniform highp float greensYellow;
 uniform highp float greensBlack;
 
 uniform highp float cyansCyan;
 uniform highp float cyansMagenta;
 uniform highp float cyansYellow;
 uniform highp float cyansBlack;
 
 uniform highp float bluesCyan;
 uniform highp float bluesMagenta;
 uniform highp float bluesYellow;
 uniform highp float bluesBlack;
 
 uniform highp float magentasCyan;
 uniform highp float magentasMagenta;
 uniform highp float magentasYellow;
 uniform highp float magentasBlack;
 
 uniform highp float whitesCyan;
 uniform highp float whitesMagenta;
 uniform highp float whitesYellow;
 uniform highp float whitesBlack;
 
 uniform highp float naturalsCyan;
 uniform highp float naturalsMagenta;
 uniform highp float naturalsYellow;
 uniform highp float naturalsBlack;
 
 uniform highp float blacksCyan;
 uniform highp float blacksMagenta;
 uniform highp float blacksYellow;
 uniform highp float blacksBlack;
 
 vec3 rgb2xyz(highp vec3 color){
     mat3 adobe;
     adobe[0] = vec3(0.576669, 0.297345, 0.027031);
     adobe[1] = vec3(0.185558, 0.627364, 0.070689);
     adobe[2] = vec3(0.188229, 0.075291, 0.991338);
     mat3 srgb;
     srgb[0] = vec3(0.412391, 0.212639, 0.019331);
     srgb[1] = vec3(0.357584, 0.715169, 0.119195);
     srgb[2] = vec3(0.180481, 0.072192, 0.950532);
     return srgb * color;
 }
 
 vec3 xyz2rgb(highp vec3 color){
     mat3 adobe;
     adobe[0] = vec3(2.041588, -0.969244, 0.013444);
     adobe[1] = vec3(-0.565007, 1.875968, -0.118362);
     adobe[2] = vec3(-0.344731, 0.041555, 1.015175);
     mat3 srgb;
     srgb[0] = vec3(3.240970 , -0.969244  , 0.055630 );
     srgb[1] = vec3(-1.537383 , 1.875968  , -0.203977  );
     srgb[2] = vec3(-0.498611, 0.041555, 1.056972);
     return srgb * color;
 }
 
 float xyz2labFt(highp float t){
     if(t > 0.00885645167){
         return 116.0 * pow(t, 0.33333333333) - 16.0;
     } else{
         return 903.296296296 * t;
     }
 }
 
 vec3 xyz2lab(highp vec3 color){
     highp float l = xyz2labFt(color.y);
     highp float a = 4.31034482759 * (xyz2labFt(color.x / 0.9642) - l);
     highp float b = 1.72413793103 * (l - xyz2labFt(color.z / 0.8249));
     return vec3(l, a, b);
 }
 
 vec3 lab2xyz(highp vec3 color){
     highp float fy = (color.x + 16.0) / 116.0;
     highp float fx = fy + (color.y / 500.0);
     highp float fz = fy - (color.z / 200.0);
     highp float x;
     highp float y;
     highp float z;
     if(fy > 0.20689655172)
         y = fy * fy * fy;
     else
         y = 0.00110705645 * (116.0 * fy - 16.0);
     if(fx > 0.20689655172)
         x = fx * fx * fx * 0.9642;
     else
         x = 0.00110705645 * (116.0 * fx - 16.0) * 0.9642;
     if(fz > 0.20689655172)
         z = fz * fz * fz * 0.8249 ;
     else
         z = 0.00110705645 * (116.0 * fz - 16.0) * 0.8249;
     return vec3(x, y, z);
 }
 
 vec3 rgb2lab(highp vec3 color){
     return xyz2lab(rgb2xyz(color));
 }
 
 vec3 lab2rgb(highp vec3 color){
     return xyz2rgb(lab2xyz(color));
 }
 
 void main()
 {
     // Sample the input pixel
     highp vec4 pixel   = texture2D(inputImageTexture, textureCoordinate);
     highp float r = pixel.r;
     highp float g = pixel.g;
     highp float b = pixel.b;
     highp float ra = r;
     highp float ga = g;
     highp float ba = b;
     
     // Convert to CMYK
     highp float c = 1.0 - r;
     highp float m = 1.0 - g;
     highp float y = 1.0 - b;
     highp float k = min(r, min(g, b));
     if(k == 1.0){
         c = 0.0;
         m = 0.0;
         y = 0.0;
     } else{
         c = (c - k) / (1.0 - k);
         m = (m - k) / (1.0 - k);
         y = (y - k) / (1.0 - k);
     }
     

     // Convert to CIE-L*ab
     highp vec3 lab = rgb2lab(vec3(r, g, b));
     highp float ll = lab.x;
     highp float al = lab.y;
     highp float bl = lab.z;
     
     highp vec3 redLab = rgb2lab(vec3(1.0, 0.0, 0.0));
     highp float redsWeight = sqrt((ll - redLab.x) * (ll - redLab.x) + (al - redLab.y) * (al - redLab.y) + (bl - redLab.z) * (bl - redLab.z)) / 176.0;
     redsWeight = 1.0 - min(redsWeight, 1.0);
     
     

     
     ra -= (1.0 - r) * redsCyan * redsWeight;
     ga -= (1.0 - g) * redsMagenta * redsWeight;
     ba -= (1.0 - b) * redsYellow * redsWeight;
     

     
     /*
     
 
     highp float redsWeight = r * (1.0 - g) * (1.0 - b);
     redsWeight = max(0.0, (r - abs(g - b))) * max(0.0, (r - abs(g - b))) * (1.0 - abs(g - b));
     redsWeight = max(0.0, (r - max(g, b)));
     //redsWeight = max(0.0, (r - g)) * max(0.0, (r - b)) * r * (1.0 - abs(g - b));
     //redsWeight = max(0.0, (r - g)) * max(0.0, (r - b));


     
     c += (1.0 - c) * redsCyan * redsWeight;
     m += (1.0 - m) * redsMagenta * redsWeight;
     y += (1.0 - y) * redsYellow * redsWeight;
     
     c = (c * (1.0 - k) + k);
     m = (m * (1.0 - k) + k);
     y = (y * (1.0 - k) + k);
     
     ra = (1.0 - c);
     ga = (1.0 - m);
     ba = (1.0 - y);
          ra -= (1.0 - r) * redsBlack * redsWeight;
     ga -= (1.0 - g) * redsBlack * redsWeight;
     ba -= (1.0 - b) * redsBlack * redsWeight;

     ra = distance;
     ga = distance;
     ba =
     distance;
    */
     
     
     // Check
     r = max(0.0, min(1.0, ra));
     g = max(0.0, min(1.0, ga));
     b = max(0.0, min(1.0, ba));
     
     pixel.r = r;
     pixel.g = g;
     pixel.b = b;
     
     // Save the result
     gl_FragColor = pixel;
 }
 );


#pragma mark Initialization and teardown

- (id)init;
{
    if (!(self = [super initWithFragmentShaderFromString:kGPUImageSelectiveColorFilterFragmentShaderString]))
    {
        return nil;
    }

    return self;
}

- (void)setRedsCyan:(int)cyan Magenta:(int)magenta Yellow:(int)yellow Black:(int)black
{
    [self setFloat:(float)cyan / 100.0f forUniform:[filterProgram uniformIndex:@"redsCyan"] program:filterProgram];
    [self setFloat:(float)magenta / 100.0f forUniform:[filterProgram uniformIndex:@"redsMagenta"] program:filterProgram];
    [self setFloat:(float)yellow / 100.0f forUniform:[filterProgram uniformIndex:@"redsYellow"] program:filterProgram];
    [self setFloat:(float)black / 100.0f forUniform:[filterProgram uniformIndex:@"redsBlack"] program:filterProgram];
}
@end
