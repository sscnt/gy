//
//  GPUColorfulCandyEffect.m
//  Gravy_1.0
//
//  Created by SSC on 2013/11/01.
//  Copyright (c) 2013年 SSC. All rights reserved.
//

#import "GPUColorfulCandyEffect.h"

@implementation GPUColorfulCandyEffect

- (UIImage*)generateGradientFill1
{
    CGFloat size = sqrt(pow(_imageToProcess.size.width, 2.0) + pow(_imageToProcess.size.height, 2.0));
    size *= 1.5f;
    
    GPUImageSolidColorGenerator* gen = [[GPUImageSolidColorGenerator alloc] init];
    [gen forceProcessingAtSize:CGSizeMake(size, size)];
    [gen setColorRed:1.0f green:1.0f blue:1.0f alpha:1.0f];
    GPUImagePicture* solidPicture = [[GPUImagePicture alloc] initWithImage:_imageToProcess];
    [solidPicture addTarget:gen];
    [solidPicture processImage];
    UIImage* solidImage = [gen imageFromCurrentlyProcessedOutput];
    
    
    GPUColorfulCandyGradientFill1ImageFilter* gFill1 = [[GPUColorfulCandyGradientFill1ImageFilter alloc] init];
    GPUImagePicture* pictureBase = [[GPUImagePicture alloc] initWithImage:solidImage];
    [pictureBase addTarget:gFill1];
    
    GPUImageTransformFilter* transformFilter = [[GPUImageTransformFilter alloc] init];
    CGAffineTransform trans;
    trans = CGAffineTransformMakeRotation(-M_PI_4);
    [transformFilter setAffineTransform:trans];
    [gFill1 addTarget:transformFilter];
    
    [pictureBase processImage];
    UIImage* gFill1Image = [transformFilter imageFromCurrentlyProcessedOutput];
    CGFloat offsetX = size * -0.226 / size;
    CGFloat offsetY = 0.0F;
    CGFloat sizeX = MAX(0.0f,MIN(1.0f,(gFill1Image.size.width - _imageToProcess.size.width) / 2.0f / gFill1Image.size.width + offsetX));
    CGFloat sizeY = MAX(0.0f,MIN(1.0f,(gFill1Image.size.height - _imageToProcess.size.height) / 2.0f / gFill1Image.size.height + offsetY));
    CGFloat sizeW = MAX(0.0f,MIN(1.0f,_imageToProcess.size.width / gFill1Image.size.width));
    CGFloat sizeH = MAX(0.0f,MIN(1.0f,_imageToProcess.size.height / gFill1Image.size.height));
    
    
    GPUImageCropFilter* crop = [[GPUImageCropFilter alloc] init];
    [crop setCropRegion:CGRectMake(sizeX, sizeY, sizeW, sizeH)];
    GPUImagePicture* resultPicture = [[GPUImagePicture alloc] initWithImage:gFill1Image];
    [resultPicture addTarget:crop];
    [resultPicture processImage];
    UIImage* resultImage = [crop imageFromCurrentlyProcessedOutput];
    return resultImage;
}

- (UIImage*)generateColorFill1
{
    GPUImageSolidColorGenerator* gen = [[GPUImageSolidColorGenerator alloc] init];
    [gen forceProcessingAtSize:CGSizeMake(_imageToProcess.size.width, _imageToProcess.size.height)];
    [gen setColorRed:122.0f/255.0f green:18.0f/255.0f blue:18.0f/255.0f alpha:1.0f];
    GPUImagePicture* solidPicture = [[GPUImagePicture alloc] initWithImage:_imageToProcess];
    [solidPicture addTarget:gen];
    [solidPicture processImage];
    return [gen imageFromCurrentlyProcessedOutput];
}


- (UIImage*)process
{
    UIImage* gFill1 = [self generateGradientFill1];
    UIImage* fill1 = [self generateColorFill1];
    UIImage* resultImage = _imageToProcess;
    GPUImageOpacityFilter* opacity;
    GPUImagePicture* pictureOriginal;
    GPUImagePicture* pictureBlend;
    
    // Channel Mixer
    GPUColorfulCandyChannelMixer1ImageFilter* mixer = [[GPUColorfulCandyChannelMixer1ImageFilter alloc] init];
    pictureOriginal = [[GPUImagePicture alloc] initWithImage:resultImage];
    [pictureOriginal addTarget:mixer];
    [pictureOriginal processImage];
    resultImage = [mixer imageFromCurrentlyProcessedOutput];


    return resultImage;
}


@end
