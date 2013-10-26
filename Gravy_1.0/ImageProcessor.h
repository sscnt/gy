//
//  EditorModel.h
//  Gravy_1.0
//
//  Created by SSC on 2013/10/26.
//  Copyright (c) 2013年 SSC. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, ProcessorId){
    ProcessorIdWhiteBalance = 1,
    ProcessorIdLevels,
    ProcessorIdSaturation
};

@protocol ImageProcessorDelegate <NSObject>

- (void)didFinishedExecute:(BOOL)success sender:(ProcessorId)identifier;

@end


@interface ImageProcessor : NSObject
{   
    size_t width;
    size_t height;
    size_t bitsPerComponent;
    size_t bitsPerPixel;
    size_t bytesPerRow;
    CGColorSpaceRef colorSpace;
    CGBitmapInfo bitmapInfo;
    bool shouldInterpolate;
    CGColorRenderingIntent intent;
    
    CFMutableDataRef mutableDataOriginal;
    CFMutableDataRef mutableDataProcessing;
    UInt8* buffer;
    
    CFIndex length;
    
}


@property (nonatomic, assign) BOOL processRunning;
@property (nonatomic, assign) BOOL dragStarted;
@property (nonatomic, assign) id<ImageProcessorDelegate> delegate;
@property (nonatomic, assign) ProcessorId identifier;

- (void)before;
- (BOOL)execute;
- (void)after;
- (void)copy;
- (void)executeAsync:(dispatch_queue_t)queue;
- (BOOL)calc;
- (void)calcPixel:(UInt8*)pixel;

- (UIImage*)appliedImage;
- (void)loadBytes:(UIImage*)image;
- (void)setBuffer:(UInt8*)buffer;

@end
