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

- (void)addColorRed:(float)red Green:(float)green Blue:(float)blue Opacity:(float)opacity Location:(int)location Midpoint:(int)midpoint
{
    if(_filter){
        [_filter addColorRed:red Green:green Blue:blue Opacity:opacity Location:location];
    }
}

- (void)setScale:(CGFloat)scale Angle:(CGFloat)angle
{
    _scale = scale;
    if(_scale < 1.0){
        _scale = 1.0f;
    }
    _angle = -angle / 180.0f * M_PI;
}

- (void)setOffsetX:(CGFloat)x Y:(CGFloat)y
{
    _offsetX = x;
    _offsetY = y;
}

- (UIImage *)process
{
    
    CGFloat size = sqrt(pow(_imageToProcess.size.width, 2.0) + pow(_imageToProcess.size.height, 2.0));
    size *= _scale;
    
    // make base
    GPUImageSolidColorGenerator* gen = [[GPUImageSolidColorGenerator alloc] init];
    [gen forceProcessingAtSize:CGSizeMake(size, size)];
    [gen setColorRed:1.0f green:1.0f blue:1.0f alpha:1.0f];
    GPUImagePicture* solidPicture = [[GPUImagePicture alloc] initWithImage:_imageToProcess];
    [solidPicture addTarget:gen];
    [solidPicture processImage];
    UIImage* solidImage = [gen imageFromCurrentlyProcessedOutput];
    
    // set gradient
    GPUImagePicture* picture = [[GPUImagePicture alloc] initWithImage:solidImage];
    [picture addTarget:_filter];
    
    // rotate
    GPUImageTransformFilter* transformFilter = [[GPUImageTransformFilter alloc] init];
    CGAffineTransform trans;
    trans = CGAffineTransformMakeRotation(_angle);
    [transformFilter setAffineTransform:trans];
    [_filter addTarget:transformFilter];
    
    // fill gradient
    [picture processImage];
    
    // crop
    UIImage* filledImage = [transformFilter imageFromCurrentlyProcessedOutput];
    CGFloat offsetX = size * _offsetX / size;
    CGFloat offsetY = size * _offsetY / size;
    CGFloat sizeX = MAX(0.0f,MIN(1.0f,(filledImage.size.width - _imageToProcess.size.width) / 2.0f / filledImage.size.width + offsetX));
    CGFloat sizeY = MAX(0.0f,MIN(1.0f,(filledImage.size.height - _imageToProcess.size.height) / 2.0f / filledImage.size.height + offsetY));
    CGFloat sizeW = MAX(0.0f,MIN(1.0f,_imageToProcess.size.width / filledImage.size.width));
    CGFloat sizeH = MAX(0.0f,MIN(1.0f,_imageToProcess.size.height / filledImage.size.height));
    GPUImageCropFilter* cropFilter = [[GPUImageCropFilter alloc] init];
    [cropFilter setCropRegion:CGRectMake(sizeX, sizeY, sizeW, sizeH)];
    GPUImagePicture* resultPicture = [[GPUImagePicture alloc] initWithImage:filledImage];
    [resultPicture addTarget:cropFilter];
    [resultPicture processImage];
    UIImage* resultImage = [cropFilter imageFromCurrentlyProcessedOutput];

    
    return resultImage;
}

@end
