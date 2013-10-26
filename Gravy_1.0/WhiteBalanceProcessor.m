//
//  whiteBalanceProcessor.m
//  Gravy_1.0
//
//  Created by SSC on 2013/10/26.
//  Copyright (c) 2013年 SSC. All rights reserved.
//

#import "WhiteBalanceProcessor.h"

@implementation WhiteBalanceProcessor

- (id)init
{
    self = [super init];
    if(self){
        self.wbBlueWeight = 0;
        self.wbRedWeight = 0;
        self.dragStarted = NO;
        self.processRunning = NO;
        self.identifier = ProcessorIdWhiteBalance;
    }
    return self;
}


- (void)calcPixel:(UInt8 *)pixel
{
    
    // RGBの値を取得する
    UInt8 r, g, b;
    r = *(pixel + 0);
    g = *(pixel + 1);
    b = *(pixel + 2);
    
    r = MAX(0, MIN(255, r + self.wbRedWeight));
    b = MAX(0, MIN(255, b + self.wbBlueWeight));
    g = MAX(0, MIN(255, g + 0));
    
    
    // 輝度の値をRGB値として設定する
    *(pixel + 0) = r;
    *(pixel + 1) = g;
    *(pixel + 2) = b;
    
}

@end
