//
//  SaturationProcessor.m
//  Gravy_1.0
//
//  Created by SSC on 2013/10/26.
//  Copyright (c) 2013年 SSC. All rights reserved.
//

#import "SaturationProcessor.h"

@implementation SaturationProcessor

- (id)init
{
    self = [super init];
    if(self){
        self.dragStarted = NO;
        self.processRunning = NO;
        self.identifier = ProcessorIdSaturation;
        self.stSaturationWeight = 0;
        self.stVibranceWeight = 0;
    }
    return self;
}

- (void)before
{
    [super before];

    float m6, m60, m255, t, spx, spy, b1, b2, b3, b4,x0, x1, x2, x3, x4, x5, y0, y1, y2, y3, y4, y5;
    m6 = 1.0f/ 6.0f;
    m60 = 1.0f / 60.0f;
    m255 =  1.0f / 255.0f;
    
    
    for(int i = 0;i < 361;i++){
        vibranceSpline[i] = 1.0f;
    }
    
    for(int i = 0;i < 1000;i++){
        if(self.dragStarted){
            self.processRunning = NO;
            [self after];
            return;
        }
        t = (float)i * 0.001;
        b1 = (-1.0f * t * t * t + 3.0f * t * t - 3.0f * t + 1.0f) * m6;
        b2 = (3.0f * t * t * t - 6.0f * t * t + 4.0f) * m6;
        b3 = (-3.0f * t * t * t + 3.0f * t * t + 3.0f * t + 1.0f) * m6;
        b4 = (t * t * t) * m6;
        x2 = 10.0f;
        x3 = 20.0f;
        x0 = -x2;
        x5 = 45.0f;
        x1 = 0;
        x4 = 30.0f;
        y2 = 0.85f;
        y3 = 0.95f;
        y1 = 0.8f;
        y0 = 0.8f;
        y3 = y4 = y5 = 1.0f;
        
        spx = x1 * b1 + x2 * b2 + x3 * b3 + x4 * b4;
        spy = y1 * b1 + y2 * b2 + y3 * b3 + y4 * b4;
        if(spx < 0.0f || spx > 30.0f) continue;
        if(spy < 0.0f || spy > 1.0f) continue;
        vibranceSpline[(int)roundf(spx)] = spy;
        spx = x0 * b1 + x1 * b2 + x2 * b3 + x3 * b4;
        spy = y0 * b1 + y1 * b2 + y2 * b3 + y3 * b4;
        if(spx < 0.0f || spx > 30.0f) continue;
        if(spy < 0.0f || spy > 1.0f) continue;
        vibranceSpline[(int)roundf(spx)] = spy;
        spx = x2 * b1 + x3 * b2 + x4 * b3 + x5 * b4;
        spy = y2 * b1 + y3 * b2 + y4 * b3 + y5 * b4;
        if(spx < 0.0f || spx > 30.0f) continue;
        if(spy < 0.0f || spy > 1.0f) continue;
        vibranceSpline[(int)roundf(spx)] = spy;
    }
    
    
    for(int i = 0;i < 30;i++){
        vibranceSpline[360 - i] = vibranceSpline[i];
    }
    
    self.stVibranceWeight = MAX(24, MIN(127, abs(self.stVibranceWeight / 2)));
    
    for(int i = 0;i < 1000;i++){
        if(self.dragStarted){
            self.processRunning = NO;
            [self after];
            return;
        }
        if(self.stVibranceWeight < 0){
            t = (float)i * 0.001;
            spx = 2.0f * t * (1.0f - t) * 200.0f + t * t * 255.0f;
            spy = 2.0f * t * (1.0f - t) * (float)abs(self.stSaturationWeight) + t * t * MAX(0.0f, (float)abs(self.stVibranceWeight));
            if(spx < 0.0f || spx > 255.0f) continue;
            if(spy < 0.0f || spy > 255.0f) continue;
            saturationSpline[(int)roundf(spx)] = spy;
        } else {
            t = (float)i * 0.001;
            b1 = (-1.0f * t * t * t + 3.0f * t * t - 3.0f * t + 1.0f) * m6;
            b2 = (3.0f * t * t * t - 6.0f * t * t + 4.0f) * m6;
            b3 = (-3.0f * t * t * t + 3.0f * t * t + 3.0f * t + 1.0f) * m6;
            b4 = (t * t * t) * m6;
            x2 = 127.0f - (float)self.stVibranceWeight;
            x3 = 127.0f + (float)self.stVibranceWeight;
            x0 = -x2;
            x5 = 510.0f - x3;
            x1 = 0;
            x4 = 255.0f;
            y2 = y3 = (float)abs(self.stSaturationWeight);
            y1 = y4 = 0;
            y0 = y5 = -y2;
            
            spx = x1 * b1 + x2 * b2 + x3 * b3 + x4 * b4;
            spy = y1 * b1 + y2 * b2 + y3 * b3 + y4 * b4;
            if(spx < 0.0f || spx > 255.0f) continue;
            if(spy < 0.0f || spy > 255.0f) continue;
            saturationSpline[(int)roundf(spx)] = spy;
            spx = x0 * b1 + x1 * b2 + x2 * b3 + x3 * b4;
            spy = y0 * b1 + y1 * b2 + y2 * b3 + y3 * b4;
            if(spx < 0.0f || spx > 255.0f) continue;
            if(spy < 0.0f || spy > 255.0f) continue;
            saturationSpline[(int)roundf(spx)] = spy;
            spx = x2 * b1 + x3 * b2 + x4 * b3 + x5 * b4;
            spy = y2 * b1 + y3 * b2 + y4 * b3 + y5 * b4;
            if(spx < 0.0f || spx > 255.0f) continue;
            if(spy < 0.0f || spy > 255.0f) continue;
            saturationSpline[(int)roundf(spx)] = spy;
        }
        
    }

}

- (void)calcPixel:(UInt8 *)pixel
{
    
    UInt8 r, g, b;
    int hi;
    float h, s, v, _r, _g, _b, max, min,m6, m60, m255, f, p, q, t, _s;
    m6 = 1.0f/ 6.0f;
    m60 = 1.0f / 60.0f;
    m255 =  1.0f / 255.0f;
    
    // RGBの値を取得する
    r = *(pixel + 0);
    g = *(pixel + 1);
    b = *(pixel + 2);
    
    _r = (float)r;
    _g = (float)g;
    _b = (float)b;
    
    max = MAX(_r, MAX(_g, _b));
    min = MIN(_r, MIN(_g, _b));
    
    h = 0.0f;
    if(max == min){
        h = 0.0f;
    } else if(max == _r){
        h = 60.0f * (_g - _b) / (max - min);
    } else if (max == _g){
        h = 60.0f * (_b - _r) / (max - min) + 120.0f;
    } else if (max == _b){
        h = 60.0f * (_r - _g) / (max - min) + 240.0f;
    }
    
    if(h < 0.0f) h += 360.0f;
    
    s =  255.0f * (max - min) / max;
    if(max == 0.0f) s = 0.0f;
    v = max;
    
    
    
    
    _s = saturationSpline[(int)roundf(s)];
    _s *= saturationSpline[(int)roundf(v)];
    _s *= m255 * 3.0f;
    _s *= vibranceSpline[(int)round(h)];
    s += _s;
    
    
    s = MAX(0.0f, MIN(255.0f, s));
    
    
    hi = (int)(h * m60) % 6;
    f = (h * m60) - floorf(h * m60);
    p = roundf(v * (1.0f - (s * m255)));
    q = roundf(v * (1.0f - (s * m255) * f));
    t = roundf(v * (1.0f - (s * m255) * (1.0f - f)));
    
    switch (hi) {
        case 0:
            _r = v;
            _g = t;
            _b = p;
            break;
        case 1:
            _r = q;
            _g = v;
            _b = p;
            break;
        case 2:
            _r = p;
            _g = v;
            _b = t;
            break;
        case 3:
            _r = p;
            _g = q;
            _b = v;
            break;
        case 4:
            _r = t;
            _g = p;
            _b = v;
            break;
        case 5:
            _r = v;
            _g = p;
            _b = q;
            break;
        default:
            break;
    }
    
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


@end
