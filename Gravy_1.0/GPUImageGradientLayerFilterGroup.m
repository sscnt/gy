//
//  GPUImageGradientLayer.m
//  Gravy_1.0
//
//  Created by SSC on 2013/11/02.
//  Copyright (c) 2013年 SSC. All rights reserved.
//

#import "GPUImageGradientLayerFilterGroup.h"

@implementation GPUImageGradientLayerFilterGroup

- (id)initWithImageToProcess:(UIImage *)image
{
    self = [super init];
    if(self){
        _filter = [[GPUImageGradientLayerImageFilter alloc] init];
        _imageToProcess = image;
    }
    return self;
}

- (void)addColorRed:(float)red Green:(float)green Blue:(float)blue Opacity:(float)opacity Location:(int)location Midpoint:(int)midpoint
{
    if(_filter){
        [_filter addColorRed:red Green:green Blue:blue Opacity:opacity Location:location Midpoint:midpoint];
    }
}

- (void)setScale:(CGFloat)scale Angle:(CGFloat)angle
{
    _scale = scale / 100.0f;
    if(_scale < 1.0){
        _scale = 1.0f;
    }
    _angle = -angle / 180.0f * M_PI;
}

- (void)setOffsetX:(CGFloat)x Y:(CGFloat)y
{
    _offsetX = -x / 100.0f;
    _offsetY = -y / 100.0f;
}

- (GPUImageFilterGroup *)filterGroup
{
    CGFloat g = floorf(_angle / M_PI_2);
    CGFloat angle = _angle - g * M_PI_2;
    CGFloat a, b, coverWidth, coverHeight;
    a = cosf(angle) * _imageToProcess.size.width;
    b = sinf(angle) * _imageToProcess.size.height;
    coverWidth = a + b;
    
    a = sinf(angle) * _imageToProcess.size.width;
    b = cosf(angle) * _imageToProcess.size.height;
    coverHeight = a + b;
    
    coverWidth *= _scale;
    coverHeight *= _scale;
    
    CGSize coverSize = CGSizeMake(coverWidth, coverHeight);
    
    GPUImageFilterGroup* filterGroup = [[GPUImageFilterGroup alloc] init];
    
    // make base
    GPUImageSolidColorGenerator* solidGenerator = [[GPUImageSolidColorGenerator alloc] init];
    [solidGenerator forceProcessingAtSize:coverSize];
    [solidGenerator setColorRed:1.0f green:1.0f blue:1.0f alpha:1.0f];
    [filterGroup addFilter:solidGenerator];

    // fill gradient
    [filterGroup addFilter:_filter];
    
    // rotate
    GPUImageTransformFilter* transformFilter = [[GPUImageTransformFilter alloc] init];
    CGAffineTransform trans;
    trans = CGAffineTransformMakeRotation(_angle);
    [transformFilter setAffineTransform:trans];
    [filterGroup addFilter:transformFilter];
    
    // crop
    CGFloat offsetX = coverWidth * _offsetX / coverWidth;
    CGFloat offsetY = coverHeight * _offsetY / coverHeight;
    CGFloat sizeX = MAX(0.0f,MIN(1.0f, (coverWidth - _imageToProcess.size.width) / 2.0f / coverWidth + offsetX));
    CGFloat sizeY = MAX(0.0f,MIN(1.0f, (coverHeight - _imageToProcess.size.height) / 2.0f / coverHeight + offsetY));
    CGFloat sizeW = MAX(0.0f,MIN(1.0f, _imageToProcess.size.width / coverWidth));
    CGFloat sizeH = MAX(0.0f,MIN(1.0f, _imageToProcess.size.height / coverHeight));
    GPUImageCropFilter* cropFilter = [[GPUImageCropFilter alloc] init];
    [cropFilter setCropRegion:CGRectMake(sizeX, sizeY, sizeW, sizeH)];
    [filterGroup addFilter:cropFilter];
    
    
    // filter settings
    [filterGroup setInitialFilters:@[solidGenerator]];
    [filterGroup setTerminalFilter:cropFilter];
    [solidGenerator addTarget:_filter];
    [_filter addTarget:transformFilter];
    [transformFilter addTarget:cropFilter];
    
    return filterGroup;
}

@end
