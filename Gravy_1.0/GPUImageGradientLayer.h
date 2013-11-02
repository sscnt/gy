//
//  GPUImageGradientLayer.h
//  Gravy_1.0
//
//  Created by SSC on 2013/11/02.
//  Copyright (c) 2013年 SSC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GPUImage.h"
#import "GPUImageGradientLayerImageFilter.h"

@interface GPUImageGradientLayer : NSObject
{
    GPUImageGradientLayerImageFilter* _filter;
    __weak UIImage* _imageToProcess;
    CGFloat _scale;
    CGFloat _angle;
    CGFloat _offsetX;
    CGFloat _offsetY;
}

- (id)initWithImageToProcess:(UIImage *)image;
- (void)addColorRed:(float)red Green:(float)green Blue:(float)blue Opacity:(float)opacity Location:(int)location Midpoint:(int)midpoint;

/*
 * scale 100.0 - 150.0
 * angle -360.0 - 360.0 degree
 */
- (void)setScale:(CGFloat)scale Angle:(CGFloat)angle;

/*
 * x 0.0 - 100.0
 * y 0.0 - 100.0
 */
- (void)setOffsetX:(CGFloat)x Y:(CGFloat)y;
- (UIImage *)process;
- (GPUImageFilterGroup *)filterGroup;

@end
