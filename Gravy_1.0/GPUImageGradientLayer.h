//
//  GPUImageGradientLayer.h
//  Gravy_1.0
//
//  Created by SSC on 2013/11/02.
//  Copyright (c) 2013年 SSC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GPUImageGradientLayer : NSObject

/*
 * red      0.0 - 255.0
 * green    0.0 - 255.0
 * blue     0.0 - 255.0
 * location 0   - 4096
 */
- (void)addColorRed:(float)red Green:(float)green Blue:(float)blue Location:(int)location;
- (UIImage*)process;

@end
