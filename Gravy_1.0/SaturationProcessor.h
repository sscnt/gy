//
//  SaturationProcessor.h
//  Gravy_1.0
//
//  Created by SSC on 2013/10/26.
//  Copyright (c) 2013年 SSC. All rights reserved.
//

#import "ImageProcessor.h"

@interface SaturationProcessor : ImageProcessor
{
    int saturationSpline[256];
    float vibranceSpline[361];
    float m6, m60, m255;
}

@property (nonatomic, assign) int stVibranceWeight;
@property (nonatomic, assign) int stSaturationWeight;

@end
