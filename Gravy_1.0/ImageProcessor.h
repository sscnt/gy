//
//  EditorModel.h
//  Gravy_1.0
//
//  Created by SSC on 2013/10/26.
//  Copyright (c) 2013年 SSC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ImageProcessor : NSObject
{
    int hist[256];
    int histLowestValue;
    int histHighestValue;
    int saturationSpline[256];
    float vibranceSpline[361];
    
    CFMutableDataRef mutableData;
    UInt8* buffer;
}


@property (nonatomic, assign) BOOL processRunning;
@property (nonatomic, assign) BOOL dragStarted;

- (void)loadBytes:(UIImage*)image;
- (void)execute;

- (void)calcPixelWhiteBalance:(UInt8*)pixel;
- (void)calcPixecLevels:(UInt8*)pixel;
- (void)calcPixelSaturation:(UInt8*)pixel;

@end
