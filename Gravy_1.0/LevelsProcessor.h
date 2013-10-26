//
//  LevelsProcessor.h
//  Gravy_1.0
//
//  Created by SSC on 2013/10/26.
//  Copyright (c) 2013年 SSC. All rights reserved.
//

#import "ImageProcessor.h"

@interface LevelsProcessor : ImageProcessor

@property (nonatomic, assign) float lvLowWeight;
@property (nonatomic, assign) float lvMidWeight;
@property (nonatomic, assign) float lvHighWeight;

@end
