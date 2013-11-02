//
//  GPUImageGradientLayer.m
//  Gravy_1.0
//
//  Created by SSC on 2013/11/02.
//  Copyright (c) 2013年 SSC. All rights reserved.
//

#import "GPUImageGradientLayer.h"

@implementation GPUImageGradientLayer

- (id)initWithImageToProcess:(UIImage *)image
{
    self = [super init];
    if(self){
        _filter = [[GPUImageGradientLayerImageFilter alloc] init];
        _imageToProcess = image;
    }
    return self;
}

- (void)addColorRed:(float)red Green:(float)green Blue:(float)blue Opacity:(float)opacity Location:(int)location
{
    if(_filter){
        [_filter addColorRed:red Green:green Blue:blue Opacity:opacity Location:location];
    }
}

- (void)setScale:(CGFloat)scale Angle:(CGFloat)angle
{
    _scale = scale;
    _angle = angle;
}

- (UIImage *)process
{
    GPUImagePicture* picture = [[GPUImagePicture alloc] initWithImage:_imageToProcess];
    [picture addTarget:_filter];
    return nil;
}

@end
