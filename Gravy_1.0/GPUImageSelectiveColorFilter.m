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
     
     ra = g;
     ga = b;
     ba = g;
     
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
