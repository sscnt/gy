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
     return adobe * color;
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
     return adobe * color;
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
 
 float labDiff(highp vec3 dest, highp vec3 src){
     highp float deltaL = dest.x - src.x;
     highp float deltaA = dest.y - src.y;
     highp float deltaB = dest.z - src.z;
     highp float deltaE = sqrt(deltaL * deltaL + deltaA * deltaA + deltaB * deltaB);
     highp float c1 = sqrt(dest.y * dest.y + dest.z * dest.z);
     highp float c2 = sqrt(src.y * src.y + src.z * src.z);
     highp float deltaCab = c1 - c2;
     highp float deltaHab = sqrt(deltaA * deltaA + deltaB * deltaB - deltaCab * deltaCab);
     return deltaHab;
     
     highp float kL = 1.0;
     highp float kC = kL;
     highp float kH = kL;
     highp float k1 = 0.045;
     highp float k2 = 0.015;
     highp float sL = 1.0;
     highp float sC = 1.0 + k1 * c1;
     highp float sH = 1.0 + k2 * c1;
     
     highp float a = deltaL / (kL * sL);
     highp float b = deltaCab / (kC * sC);
     highp float c = deltaHab / (kH * sH);
     
     return sqrt(a * a + b * b + c * c);
     
 }
 
 vec3 rgb2hsv(highp vec3 color){
     highp float r = color.r;
     highp float g = color.g;
     highp float b = color.b;
     
     highp float max = max(r, max(g, b));
     highp float min = min(r, min(g, b));
     highp float h = 0.0;
     if(max < min){
         max = 0.0;
         min = 0.0;
     }
     
     if(max == min){
         
     } else if(max == r){
         h = 60.0 * (g - b) / (max - min);
     } else if(max == g){
         h = 60.0 * (b - r) / (max - min) + 120.0;
     } else if(max == b){
         h = 60.0 * (r - g) / (max - min) + 240.0;
     }
     if(h < 0.0){
         h += 360.0;
     }
     h = mod(h, 360.0);
     
     highp float s;
     if(max == 0.0) {
         s = 0.0;
     } else {
         s = (max - min) / max;
     }
     highp float v = max;
     
     return vec3(h, s, v);
 }
 
 vec3 hsv2rgb(highp vec3 color){
     highp float h = color.r;
     highp float s = color.g;
     highp float v = color.b;
     highp float r;
     highp float g;
     highp float b;
     highp float m60 = 0.01665;
     int hi = int(mod(float(floor(h * m60)), 6.0));
     highp float f = (h * m60) - float(hi);
     highp float p = v * (1.0 - s);
     highp float q = v * (1.0 - s * f);
     highp float t = v * (1.0 - s * (1.0 - f));
     
     if(hi == 0){
         r = v;
         g = t;
         b = p;
     } else if(hi == 1){
         r = q;
         g = v;
         b = p;
     } else if(hi == 2){
         r = p;
         g = v;
         b = t;
     } else if(hi == 3){
         r = p;
         g = q;
         b = v;
     } else if(hi == 4){
         r = t;
         g = p;
         b = v;
     } else if(hi == 5){
         r = v;
         g = p;
         b = q;
     } else {
         r = v;
         g = t;
         b = p;
     }
     return vec3(r, g, b);

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
     highp float k = min(c, min(m, y));
     if(k == 1.0){
         c = 0.0;
         m = 0.0;
         y = 0.0;
     } else{
         c = (c - k) / (1.0 - k);
         m = (m - k) / (1.0 - k);
         y = (y - k) / (1.0 - k);
     }
     
     // Convert to HSV
     highp vec3 hsv = rgb2hsv(vec3(r, g, b));
     
     
     
     // Adjustment
     highp float ca = c;
     highp float ma = m;
     highp float ya = y;
     highp float ka = k;
     
     // Reds
     highp vec3 redHsv = rgb2hsv(vec3(1.0, 0.0, 0.0));
     highp float diff = abs(hsv.x - redHsv.x);
     if(diff > 180.0){
         diff = 360.0 - diff;
     }
     highp float redsWeight = (1.0 - max(0.0, min(1.0, diff / 60.0))) * hsv.y;
     if(redsCyan > 0.0)
         ca += c * redsCyan * redsWeight;
     else
         ca -= c * abs(redsCyan) * redsWeight;
     if(redsMagenta > 0.0)
         ma += m * redsMagenta * redsWeight;
     else
         ma -= m * abs(redsMagenta) * redsWeight;
     if(redsYellow > 0.0)
         ya += y * redsYellow * redsWeight;
     else
         ya -= y * abs(redsYellow) * redsWeight;

     // Yellows
     highp vec3 yellowHsv = rgb2hsv(vec3(1.0, 1.0, 0.0));
     diff = abs(hsv.x - yellowHsv.x);
     highp float yellowsWeight = (1.0 - max(0.0, min(1.0, diff / 60.0))) * hsv.y;
     if(yellowsCyan > 0.0)
         ca += c * yellowsCyan * yellowsWeight;
     else
         ca -= c * abs(yellowsCyan) * yellowsWeight;
     if(yellowsMagenta > 0.0)
         ma += m * yellowsMagenta * yellowsWeight;
     else
         ma -= m * abs(yellowsMagenta) * yellowsWeight;
     if(yellowsYellow > 0.0)
         ya += y * yellowsYellow * yellowsWeight;
     else
         ya -= y * abs(yellowsYellow) * yellowsWeight;
     
     // Greens
     highp vec3 greenHsv = rgb2hsv(vec3(0.0, 1.0, 0.0));
     diff = abs(hsv.x - greenHsv.x);
     highp float greensWeight = (1.0 - max(0.0, min(1.0, diff / 60.0))) * hsv.y;
     if(greensCyan > 0.0)
         ca += c * greensCyan * greensWeight;
     else
         ca -= c * abs(greensCyan) * greensWeight;
     if(greensMagenta > 0.0)
         ma += m * greensMagenta * greensWeight;
     else
         ma -= m * abs(greensMagenta) * greensWeight;
     if(greensYellow > 0.0)
         ya += y * greensYellow * greensWeight;
     else
         ya -= y * abs(greensYellow) * greensWeight;
     
     // Cyan
     highp vec3 cyanHsv = rgb2hsv(vec3(0.0, 1.0, 1.0));
     diff = abs(hsv.x - cyanHsv.x);
     highp float cyansWeight = (1.0 - max(0.0, min(1.0, diff / 60.0))) * hsv.y;
     if(cyansCyan > 0.0)
         ca += c * cyansCyan * cyansWeight;
     else
         ca -= c * abs(cyansCyan) * cyansWeight;
     if(cyansMagenta > 0.0)
         ma += m * cyansMagenta * cyansWeight;
     else
         ma -= m * abs(cyansMagenta) * cyansWeight;
     if(cyansYellow > 0.0)
         ya += y * cyansYellow * cyansWeight;
     else
         ya -= y * abs(cyansYellow) * cyansWeight;
     
     // Blue
     highp vec3 blueHsv = rgb2hsv(vec3(0.0, 0.0, 1.0));
     diff = abs(hsv.x - blueHsv.x);
     highp float bluesWeight = (1.0 - max(0.0, min(1.0, diff / 60.0))) * hsv.y;
     if(bluesCyan > 0.0)
         ca += c * bluesCyan * bluesWeight;
     else
         ca -= c * abs(bluesCyan) * bluesWeight;
     if(bluesMagenta > 0.0)
         ma += m * bluesMagenta * bluesWeight;
     else
         ma -= m * abs(bluesMagenta) * bluesWeight;
     if(bluesYellow > 0.0)
         ya += y * bluesYellow * bluesWeight;
     else
         ya -= y * abs(bluesYellow) * bluesWeight;
     
     // Magentas
     highp vec3 magentaHsv = rgb2hsv(vec3(1.0, 0.0, 1.0));
     diff = abs(hsv.x - magentaHsv.x);
     highp float magentasWeight = (1.0 - max(0.0, min(1.0, diff / 60.0))) * hsv.y;
     if(magentasCyan > 0.0)
         ca += c * magentasCyan * magentasWeight;
     else
         ca -= c * abs(magentasCyan) * magentasWeight;
     if(magentasMagenta > 0.0)
         ma += m * magentasMagenta * magentasWeight;
     else
         ma -= m * abs(magentasMagenta) * magentasWeight;
     if(magentasYellow > 0.0)
         ya += y * magentasYellow * magentasWeight;
     else
         ya -= y * abs(magentasYellow) * magentasWeight;
     
     // Wthies
     highp float whitesWeight = 1.0 - max(0.0, min(hsv.y * 3.0, 1.0));
     if(whitesCyan > 0.0)
         ca += c * whitesCyan * whitesWeight;
     else
         ca -= c * abs(whitesCyan) * whitesWeight;
     if(whitesMagenta > 0.0)
         ma += m * whitesMagenta * whitesWeight;
     else
         ma -= m * abs(whitesMagenta) * whitesWeight;
     if(whitesYellow > 0.0)
         ya += y * whitesYellow * whitesWeight;
     else
         ya -= y * abs(whitesYellow) * whitesWeight;
     
     
     c = (ca * (1.0 - ka) + ka);
     m = (ma* (1.0 - ka) + ka);
     y = (ya * (1.0 - ka) + ka);
     
     
     c = max(0.0, min(1.0, c));
     m = max(0.0, min(1.0, m));
     y = max(0.0, min(1.0, y));
     
     // Reds
     if(redsBlack > 0.0){
         c -= c * abs(redsBlack) * redsWeight;
         m += m * redsBlack * redsWeight;
         y += y * redsBlack * redsWeight;
     } else{
         c -= c * abs(redsBlack) * redsWeight;
         m -= m * abs(redsBlack) * redsWeight;
         y -= y * abs(redsBlack) * redsWeight;
     }
     
     // Yellows
     if(yellowsBlack > 0.0){
         c -= c * yellowsBlack * yellowsWeight;
         m -= m * yellowsBlack * yellowsWeight;
         y += y * yellowsBlack * yellowsWeight;
     } else{
         c -= c * abs(yellowsBlack) * yellowsWeight;
         m -= m * abs(yellowsBlack) * yellowsWeight;
         y -= y * abs(yellowsBlack) * yellowsWeight;
     }
     
     // Greens
     if(greensBlack > 0.0){
         c += c * abs(greensBlack) * greensWeight;
         m -= m * greensBlack * greensWeight;
         y += y * greensBlack * greensWeight;
     } else{
         c -= c * abs(greensBlack) * greensWeight;
         m -= m * abs(greensBlack) * greensWeight;
         y -= y * abs(greensBlack) * greensWeight;
     }
     
     // Cyans
     if(cyansBlack > 0.0){
         c += c * abs(cyansBlack) * cyansWeight;
         m -= m * cyansBlack * cyansWeight;
         y -= y * cyansBlack * cyansWeight;
     } else{
         c -= c * abs(cyansBlack) * cyansWeight;
         m -= m * abs(cyansBlack) * cyansWeight;
         y -= y * abs(cyansBlack) * cyansWeight;
     }
     
     // Blues
     if(bluesBlack > 0.0){
         c += c * abs(bluesBlack) * bluesWeight;
         m += m * bluesBlack * bluesWeight;
         y -= y * bluesBlack * bluesWeight;
     } else{
         c -= c * abs(bluesBlack) * bluesWeight;
         m -= m * abs(bluesBlack) * bluesWeight;
         y -= y * abs(bluesBlack) * bluesWeight;
     }
     
     // Magentas
     if(magentasBlack > 0.0){
         c -= c * abs(magentasBlack) * magentasWeight;
         m += m * magentasBlack * magentasWeight;
         y -= y * magentasBlack * magentasWeight;
     } else{
         c -= c * abs(magentasBlack) * magentasWeight;
         m -= m * abs(magentasBlack) * magentasWeight;
         y -= y * abs(magentasBlack) * magentasWeight;
     }
     
     
     // Whites
     if(magentasBlack > 0.0){
         c += c * abs(magentasBlack) * magentasWeight;
         m += m * magentasBlack * magentasWeight;
         y += y * magentasBlack * magentasWeight;
     } else{
         c -= c * abs(magentasBlack) * magentasWeight;
         m -= m * abs(magentasBlack) * magentasWeight;
         y -= y * abs(magentasBlack) * magentasWeight;
     }
     
     
     
     c = max(0.0, min(1.0, c));
     m = max(0.0, min(1.0, m));
     y = max(0.0, min(1.0, y));
     
     ra = (1.0 - c);
     ga = (1.0 - m);
     ba = (1.0 - y);
     
     
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
    
    [self setFloat:0.0f forUniform:[filterProgram uniformIndex:@"redsCyan"] program:filterProgram];
    [self setFloat:0.0f forUniform:[filterProgram uniformIndex:@"redsMagenta"] program:filterProgram];
    [self setFloat:0.0f forUniform:[filterProgram uniformIndex:@"redsYellow"] program:filterProgram];
    [self setFloat:0.0f forUniform:[filterProgram uniformIndex:@"redsBlack"] program:filterProgram];
    
    [self setFloat:0.0f forUniform:[filterProgram uniformIndex:@"yellowsCyan"] program:filterProgram];
    [self setFloat:0.0f forUniform:[filterProgram uniformIndex:@"yellowsMagenta"] program:filterProgram];
    [self setFloat:0.0f forUniform:[filterProgram uniformIndex:@"yellowsYellow"] program:filterProgram];
    [self setFloat:0.0f forUniform:[filterProgram uniformIndex:@"yellowsBlack"] program:filterProgram];
    
    [self setFloat:0.0f forUniform:[filterProgram uniformIndex:@"greensCyan"] program:filterProgram];
    [self setFloat:0.0f forUniform:[filterProgram uniformIndex:@"greensMagenta"] program:filterProgram];
    [self setFloat:0.0f forUniform:[filterProgram uniformIndex:@"greensYellow"] program:filterProgram];
    [self setFloat:0.0f forUniform:[filterProgram uniformIndex:@"greensBlack"] program:filterProgram];
    
    [self setFloat:0.0f forUniform:[filterProgram uniformIndex:@"cyansCyan"] program:filterProgram];
    [self setFloat:0.0f forUniform:[filterProgram uniformIndex:@"cyansMagenta"] program:filterProgram];
    [self setFloat:0.0f forUniform:[filterProgram uniformIndex:@"cyansYellow"] program:filterProgram];
    [self setFloat:0.0f forUniform:[filterProgram uniformIndex:@"cyansBlack"] program:filterProgram];
    
    [self setFloat:0.0f forUniform:[filterProgram uniformIndex:@"bluesCyan"] program:filterProgram];
    [self setFloat:0.0f forUniform:[filterProgram uniformIndex:@"bluesMagenta"] program:filterProgram];
    [self setFloat:0.0f forUniform:[filterProgram uniformIndex:@"bluesYellow"] program:filterProgram];
    [self setFloat:0.0f forUniform:[filterProgram uniformIndex:@"bluesBlack"] program:filterProgram];
    return self;
}

- (void)setRedsCyan:(int)cyan Magenta:(int)magenta Yellow:(int)yellow Black:(int)black
{
    [self setFloat:(float)cyan / 100.0f forUniform:[filterProgram uniformIndex:@"redsCyan"] program:filterProgram];
    [self setFloat:(float)magenta / 100.0f forUniform:[filterProgram uniformIndex:@"redsMagenta"] program:filterProgram];
    [self setFloat:(float)yellow / 100.0f forUniform:[filterProgram uniformIndex:@"redsYellow"] program:filterProgram];
    [self setFloat:(float)black / 100.0f forUniform:[filterProgram uniformIndex:@"redsBlack"] program:filterProgram];
}
- (void)setYellowCyan:(int)cyan Magenta:(int)magenta Yellow:(int)yellow Black:(int)black
{
    [self setFloat:(float)cyan / 100.0f forUniform:[filterProgram uniformIndex:@"yellowsCyan"] program:filterProgram];
    [self setFloat:(float)magenta / 100.0f forUniform:[filterProgram uniformIndex:@"yellowsMagenta"] program:filterProgram];
    [self setFloat:(float)yellow / 100.0f forUniform:[filterProgram uniformIndex:@"yellowsYellow"] program:filterProgram];
    [self setFloat:(float)black / 100.0f forUniform:[filterProgram uniformIndex:@"yellowsBlack"] program:filterProgram];
}
- (void)setGreenCyan:(int)cyan Magenta:(int)magenta Yellow:(int)yellow Black:(int)black
{
    [self setFloat:(float)cyan / 100.0f forUniform:[filterProgram uniformIndex:@"greensCyan"] program:filterProgram];
    [self setFloat:(float)magenta / 100.0f forUniform:[filterProgram uniformIndex:@"greensMagenta"] program:filterProgram];
    [self setFloat:(float)yellow / 100.0f forUniform:[filterProgram uniformIndex:@"greensYellow"] program:filterProgram];
    [self setFloat:(float)black / 100.0f forUniform:[filterProgram uniformIndex:@"greensBlack"] program:filterProgram];
}
- (void)setCyanCyan:(int)cyan Magenta:(int)magenta Yellow:(int)yellow Black:(int)black
{
    [self setFloat:(float)cyan / 100.0f forUniform:[filterProgram uniformIndex:@"cyansCyan"] program:filterProgram];
    [self setFloat:(float)magenta / 100.0f forUniform:[filterProgram uniformIndex:@"cyansMagenta"] program:filterProgram];
    [self setFloat:(float)yellow / 100.0f forUniform:[filterProgram uniformIndex:@"cyansYellow"] program:filterProgram];
    [self setFloat:(float)black / 100.0f forUniform:[filterProgram uniformIndex:@"cyansBlack"] program:filterProgram];
}
- (void)setBlueCyan:(int)cyan Magenta:(int)magenta Yellow:(int)yellow Black:(int)black
{
    [self setFloat:(float)cyan / 100.0f forUniform:[filterProgram uniformIndex:@"bluesCyan"] program:filterProgram];
    [self setFloat:(float)magenta / 100.0f forUniform:[filterProgram uniformIndex:@"bluesMagenta"] program:filterProgram];
    [self setFloat:(float)yellow / 100.0f forUniform:[filterProgram uniformIndex:@"bluesYellow"] program:filterProgram];
    [self setFloat:(float)black / 100.0f forUniform:[filterProgram uniformIndex:@"bluesBlack"] program:filterProgram];
}
- (void)setMagentaCyan:(int)cyan Magenta:(int)magenta Yellow:(int)yellow Black:(int)black
{
    [self setFloat:(float)cyan / 100.0f forUniform:[filterProgram uniformIndex:@"magentasCyan"] program:filterProgram];
    [self setFloat:(float)magenta / 100.0f forUniform:[filterProgram uniformIndex:@"magentasMagenta"] program:filterProgram];
    [self setFloat:(float)yellow / 100.0f forUniform:[filterProgram uniformIndex:@"magentasYellow"] program:filterProgram];
    [self setFloat:(float)black / 100.0f forUniform:[filterProgram uniformIndex:@"magentasBlack"] program:filterProgram];
}
- (void)setWhiteCyan:(int)cyan Magenta:(int)magenta Yellow:(int)yellow Black:(int)black
{
    [self setFloat:(float)cyan / 100.0f forUniform:[filterProgram uniformIndex:@"whitesCyan"] program:filterProgram];
    [self setFloat:(float)magenta / 100.0f forUniform:[filterProgram uniformIndex:@"whitesMagenta"] program:filterProgram];
    [self setFloat:(float)yellow / 100.0f forUniform:[filterProgram uniformIndex:@"whitesYellow"] program:filterProgram];
    [self setFloat:(float)black / 100.0f forUniform:[filterProgram uniformIndex:@"whitesBlack"] program:filterProgram];
}
@end
