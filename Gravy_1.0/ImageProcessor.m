//
//  EditorModel.m
//  Gravy_1.0
//
//  Created by SSC on 2013/10/26.
//  Copyright (c) 2013年 SSC. All rights reserved.
//

#import "ImageProcessor.h"

@implementation ImageProcessor

- (void)loadBytes:(UIImage *)image
{
    
    // 画像情報を取得する
    width = CGImageGetWidth(image.CGImage);
    height = CGImageGetHeight(image.CGImage);
    bitsPerComponent = CGImageGetBitsPerComponent(image.CGImage);
    bitsPerPixel = CGImageGetBitsPerPixel(image.CGImage);
    bytesPerRow = CGImageGetBytesPerRow(image.CGImage);
    colorSpace = CGImageGetColorSpace(image.CGImage);
    bitmapInfo = CGImageGetBitmapInfo(image.CGImage);
    shouldInterpolate = CGImageGetShouldInterpolate(image.CGImage);
    intent = CGImageGetRenderingIntent(image.CGImage);
    
    // データプロバイダを取得する
    CGDataProviderRef dataProvider = CGImageGetDataProvider(image.CGImage);
    
    // ビットマップデータを取得する
    CFDataRef data = CGDataProviderCopyData(dataProvider);
    mutableDataOriginal = CFDataCreateMutableCopy(0, 0, CGDataProviderCopyData(dataProvider));
    length = CFDataGetLength(mutableDataOriginal);
    CFRelease(data);
}

- (UIImage*)appliedImage
{
    if(!mutableDataProcessing){
        dlog(@"Error!");
    }
    // 効果を与えたデータを作成する
    CFDataRef effectedData;
    effectedData = CFDataCreate(NULL, buffer, length);
    
    // 効果を与えたデータプロバイダを作成する
    CGDataProviderRef effectedDataProvider;
    effectedDataProvider = CGDataProviderCreateWithCFData(effectedData);
    
    // 画像を作成する
    CGImageRef effectedCgImage = CGImageCreate(
                                               width, height,
                                               bitsPerComponent, bitsPerPixel, bytesPerRow,
                                               colorSpace, bitmapInfo, effectedDataProvider,
                                               NULL, shouldInterpolate, intent);
    
    
    UIImage* image = [[UIImage alloc] initWithCGImage:effectedCgImage];
    
    // 作成したデータを解放する
    CGImageRelease(effectedCgImage);
    CFRelease(effectedDataProvider);
    CFRelease(effectedData);
    
    return image;
}

- (void)setBuffer:(UInt8 *)_buffer
{
    buffer = _buffer;
}

- (void)copy
{
    if(mutableDataProcessing){
        CFRelease(mutableDataProcessing);
    }
    mutableDataProcessing = CFDataCreateMutableCopy(0, 0, mutableDataOriginal);
}

- (BOOL)execute
{
    [self before];
    BOOL success = [self calc];
    [self after];
    return success;
}

- (BOOL)calc
{
    NSUInteger i, j;
    for (j = 0 ; j < height; j++)
    {
        for (i = 0; i < width; i++)
        {
            if(self.dragStarted){
                self.processRunning = NO;
                [self after];
                return NO;
            }
            
            // ピクセルのポインタを取得する
            UInt8* pixel = buffer + j * bytesPerRow + i * 4;
            [self calcPixel:pixel];
        }
    }
    return YES;
}

- (void)before
{
    [self copy];
    [self setBuffer:(UInt8*)CFDataGetMutableBytePtr(mutableDataProcessing)];
}

- (void)after
{
}

- (void)executeAsync:(dispatch_queue_t)queue
{
    if(self.processRunning){
        return;
    }
    self.processRunning = YES;
    self.dragStarted = NO;
    __block BOOL success = NO;
    __weak ImageProcessor* _self = self;
    dispatch_async(queue, ^{
        success = [_self execute];
        //メインスレッド
        dispatch_async(dispatch_get_main_queue(), ^{
            self.processRunning = NO;
            [_self.delegate didFinishedExecute:success sender:self.identifier];
        });
    });
    
}

- (void)dealloc
{
    CFRelease(mutableDataOriginal);
    if(mutableDataProcessing){
        CFRelease(mutableDataProcessing);
    }
    CGColorSpaceRelease(colorSpace);
}

@end
