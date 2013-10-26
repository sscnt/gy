//
//  SaturationProcessor.h
//  Gravy_1.0
//
//  Created by SSC on 2013/10/26.
//  Copyright (c) 2013年 SSC. All rights reserved.
//

#import "ImageProcessor.h"

@interface SaturationProcessor : ImageProcessor

@property (nonatomic, assign) int stVibranceWeight;
@property (nonatomic, assign) int stSaturationWeight;

@end
