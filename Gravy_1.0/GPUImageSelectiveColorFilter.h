//
//  GPUImageSelectiveColorFilter.h
//  Gravy_1.0
//
//  Created by SSC on 2013/11/07.
//  Copyright (c) 2013年 SSC. All rights reserved.
//

#import "GPUImageFilter.h"

extern NSString *const kGPUImageSelectiveColorFilterFragmentShaderString;

@interface GPUImageSelectiveColorFilter : GPUImageFilter

- (void)setRedsCyan:(int)cyan Magenta:(int)magenta Yellow:(int)yellow Black:(int)black;
- (void)setYellowCyan:(int)cyan Magenta:(int)magenta Yellow:(int)yellow Black:(int)black;
- (void)setGreenCyan:(int)cyan Magenta:(int)magenta Yellow:(int)yellow Black:(int)black;
- (void)setCyanCyan:(int)cyan Magenta:(int)magenta Yellow:(int)yellow Black:(int)black;
- (void)setBlueCyan:(int)cyan Magenta:(int)magenta Yellow:(int)yellow Black:(int)black;
- (void)setMagentaCyan:(int)cyan Magenta:(int)magenta Yellow:(int)yellow Black:(int)black;
- (void)setWhiteCyan:(int)cyan Magenta:(int)magenta Yellow:(int)yellow Black:(int)black;
- (void)setNaturalCyan:(int)cyan Magenta:(int)magenta Yellow:(int)yellow Black:(int)black;
- (void)setBlackCyan:(int)cyan Magenta:(int)magenta Yellow:(int)yellow Black:(int)black;

@end
