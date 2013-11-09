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
 
 
 
 void main()
 {
     // Sample the input pixel
     highp vec4 pixel   = texture2D(inputImageTexture, textureCoordinate);
     highp float r = pixel.r;
     highp float g = pixel.g;
     highp float b = pixel.b;
     highp float ra;
     highp float ga;
     highp float ba;
     
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
     
     // Convert to XYZ
     highp float x_;
     highp float y_;
     highp float z_;
     if(r > 0.04045)
         ra = pow((r + 0.055) / 1.055, 2.4);
     else
         ra = r / 12.92;
     if(g > 0.04045)
         ga = pow((g + 0.055) / 1.055, 2.4);
     else
         ga = g / 12.92;
     if(b > 0.04045)
         ba = pow((b + 0.055) / 1.055, 2.4);
     else
         ba = b / 12.92;
     ra *= 100.0;
     ga *= 100.0;
     ba *= 100.0;
     
     x_ = ra * 0.4124 + ga * 0.3576 + ba * 0.1805;
     y_ = ra * 0.2126 + ga * 0.7152 + ba * 0.0722;
     z_ = ra * 0.0193 + ga * 0.1192 + ba * 0.9505;
     
     // Convert to CIE-L*ab
     highp float l_;
     highp float a_;
     highp float b_;
     x_ /= 95.047;
     y_ /= 100.000;
     z_ /= 108.883;
     if(x_ > 0.008856)
         x_ = pow(x_, 0.33333333333);
     else
         x_ = (7.78703703704 * x_) + 0.13793103448;
     if(y_ > 0.008856)
         y_ = pow(y_, 0.33333333333);
     else
         y_ = (7.78703703704 * y_) + 0.13793103448;
     if(z_ > 0.008856)
         z_ = pow(z_, 0.33333333333);
     else
         z_ = (7.78703703704 * z_) + 0.13793103448;
     l_ = (116.0 * y_) - 16.0;
     a_ = 500.0 * (x_ - y_);
     b_ = 200.0 * (y_ - z_);
     
     
     highp float redsWeight = r * (1.0 - g) * (1.0 - b);
     redsWeight = max(0.0, (r - abs(g - b))) * max(0.0, (r - abs(g - b))) * (1.0 - abs(g - b));
     redsWeight = max(0.0, (r - max(g, b)));
     //redsWeight = max(0.0, (r - g)) * max(0.0, (r - b)) * r * (1.0 - abs(g - b));
     //redsWeight = max(0.0, (r - g)) * max(0.0, (r - b));

     

     
     /*
     
 
     
     c += (1.0 - c) * redsCyan * redsWeight;
     m += (1.0 - m) * redsMagenta * redsWeight;
     y += (1.0 - y) * redsYellow * redsWeight;
     
     c = (c * (1.0 - k) + k);
     m = (m * (1.0 - k) + k);
     y = (y * (1.0 - k) + k);
     
     ra = (1.0 - c);
     ga = (1.0 - m);
     ba = (1.0 - y);
     
     
     ra -= (1.0 - r) * redsCyan * redsWeight;
     ga -= (1.0 - g) * redsMagenta * redsWeight;
     ba -= (1.0 - b) * redsYellow * redsWeight;
     
     ra -= (1.0 - r) * redsBlack * redsWeight;
     ga -= (1.0 - g) * redsBlack * redsWeight;
     ba -= (1.0 - b) * redsBlack * redsWeight;

    */
     
     // Convert to XYZ
     y_ = (l_ + 16.0) / 116.0;
     x_ = a_ / 500.0 + y;
     z_ = y_ - b_ / 200.0;
     if(y_ > 0.20689655172)
         y_ = y_*y_*y_;
     else
         y_ = (y_ - 0.13793103448) / 7.78703703704;
     if(x_ > 0.20689655172)
         x_ = x_*x_*x_;
     else
         x_ = (x_ - 0.13793103448) / 7.78703703704;
     if(z_ > 0.20689655172)
         z_ = z_*z_*z_;
     else
         z_ = (z_ - 0.13793103448) / 7.78703703704;
     x_ *= 95.047;
     y_ *= 100.000;
     z_ *= 108.883;
     
     // Convert to RGB
     x_ /= 100.0;
     y_ /= 100.0;
     z_ /= 100.0;
     
     ra = x_ * 3.2406 + y_ * -1.5372 + z_ * -0.4986;
     ga = x_ * -0.9689 + y_ * 1.8758 + z_ * 0.0415;
     ba = x_ * 0.0557 + y_ * -0.2040 + z_ * 1.0570;
     if(ra > 0.0031308)
         ra = 1.055 * pow(ra, 0.41666666666) - 0.055;
     else
         ra *= 12.92;
     if(ga > 0.0031308)
         ga = 1.055 * pow(ga, 0.41666666666) - 0.055;
     else
         ga *= 12.92;
     if(ba > 0.0031308)
         ba = 1.055 * pow(ba, 0.41666666666) - 0.055;
     else
         ba *= 12.92;
     
     
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
