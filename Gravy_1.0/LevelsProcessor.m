//
//  LevelsProcessor.m
//  Gravy_1.0
//
//  Created by SSC on 2013/10/26.
//  Copyright (c) 2013年 SSC. All rights reserved.
//

#import "LevelsProcessor.h"

@implementation LevelsProcessor

- (id)init
{
    self = [super init];
    if(self){
        self.lvHighWeight = 255;
        self.lvMidWeight = 127;
        self.lvLowWeight = 0;
        self.dragStarted = NO;
        self.processRunning = NO;
        self.identifier = ProcessorIdLevels;
        self.histHighestValue = 255;
        self.histLowestValue = 0;
    }
    return self;
}

- (void)before
{
    [super before];
    int diffHighAndMid = self.lvHighWeight - self.lvMidWeight;
    int diffMidAndLow = self.lvMidWeight - self.lvLowWeight;

    dblMid = 1.0f / (float)diffHighAndMid;
    dblLow = 1.0f / (float)diffMidAndLow;
    _lvMidWeight = (float)self.lvMidWeight;
}

- (void)calcPixel:(UInt8 *)pixel
{
    UInt8 r, g, b;
    float _r, _g, _b, y, u, v, _y;
    r = *(pixel + 0);
    g = *(pixel + 1);
    b = *(pixel + 2);
    
    _r = (float)r * 0.8588f + 16.0f;
    _g = (float)g * 0.8588f + 16.0f;
    _b = (float)b * 0.8588f + 16.0f;
    
    
    
    y = 0.299 * _r + 0.587 * _g + 0.114 * _b;
    u = -0.169 * _r - 0.331 * _g + 0.500 * _b;
    v = 0.500 * _r - 0.419 * _g - 0.081 * _b;
    
    
    if(y >= _lvMidWeight){
        _y = (y - _lvMidWeight) * 127.0f * dblMid + 127.0f;
    } else {
        _y = (y - self.lvLowWeight) * 127.0f * dblLow;
    }
    _y = MAX(0.0f, MIN(255.0f, _y));
    
    
    _r = 1.000f * _y + 1.402f * v - 16.0f;
    _g = 1.000f * _y - 0.344f * u - 0.714f * v - 16.0f;
    _b = 1.000f * _y + 1.772f * u - 16.0f;
    
    _r *= 1.164;
    _g *= 1.164;
    _b *= 1.164;
    
    
    _r = MAX(0.0f, MIN(255.0f, _r));
    _g = MAX(0.0f, MIN(255.0f, _g));
    _b = MAX(0.0f, MIN(255.0f, _b));
    
    r = (UInt8)roundf(_r);
    g = (UInt8)roundf(_g);
    b = (UInt8)roundf(_b);
    
    
    // 輝度の値をRGB値として設定する
    *(pixel + 0) = r;
    *(pixel + 1) = g;
    *(pixel + 2) = b;

    
}

- (void)makeHistogram
{
    
    buffer = (UInt8*)CFDataGetMutableBytePtr(mutableDataOriginal);
    UInt8 r, g, b;
    int _y;
    float y, _r, _g, _b;
    
    NSUInteger i, j;
    for (j = 0 ; j < height; j++)
    {
        for (i = 0; i < width; i++)
        {
            // ピクセルのポインタを取得する
            UInt8* pixel = buffer + j * bytesPerRow + i * 4;
            
            // RGBの値を取得する
            r = *(pixel + 0);
            g = *(pixel + 1);
            b = *(pixel + 2);
            
            _r = (float)r * 0.8588f + 16.0f;
            _g = (float)g * 0.8588f + 16.0f;
            _b = (float)b * 0.8588f + 16.0f;
            y = 0.299 * _r + 0.587 * _g + 0.114 * _b;
            
            y = MAX(0.0f, MIN(255.0f, y));
            _y = (int)y;
            
            hist[_y] += 1;
        }
    }
    
    BOOL rev = NO;
    
    for(int i = 0;i  < 256;i++){
        if(rev){
            if(hist[i] != 0){
                self.histLowestValue = i;
                rev = YES;
                i = 0;
            }
        } else {
            if(hist[255 - i] == 0){
                self.histHighestValue = 255 - i;
                break;
            }
        }
    }
    
    self.lvHighWeight = self.histHighestValue;
    self.lvLowWeight = self.histLowestValue;
    
}

@end
