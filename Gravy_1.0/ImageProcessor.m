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
    // データプロバイダを取得する
    CGDataProviderRef dataProvider = CGImageGetDataProvider(image.CGImage);
    
    // ビットマップデータを取得する
    CFDataRef data = CGDataProviderCopyData(dataProvider);
    mutableData = CFDataCreateMutableCopy(0, 0, CGDataProviderCopyData(dataProvider));
    CFRelease(data);
    buffer = (UInt8*)CFDataGetMutableBytePtr(mutableData);
}

- (void)dealloc
{
    CFRelease(mutableData);
}

@end
