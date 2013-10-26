//
//  LevelsProcessor.h
//  Gravy_1.0
//
//  Created by SSC on 2013/10/26.
//  Copyright (c) 2013年 SSC. All rights reserved.
//

#import "ImageProcessor.h"

@interface LevelsProcessor : ImageProcessor
{
    
    float dblMid;
    float dblLow;
    float _lvMidWeight;
    int hist[256];
}

@property (nonatomic, assign) float lvLowWeight;
@property (nonatomic, assign) float lvMidWeight;
@property (nonatomic, assign) float lvHighWeight;
@property (nonatomic, assign) int histLowestValue;
@property (nonatomic, assign) int histHighestValue;

- (void)makeHistogram;

@end
