//
//  GPUWhitebalanceImageFilter.h
//  Gravy_1.0
//
//  Created by SSC on 2013/10/27.
//  Copyright (c) 2013年 SSC. All rights reserved.
//

#import "GPUImageFilter.h"

extern NSString *const kGPUImageWhitebalanceFragmentShaderString;

@interface GPUWhitebalanceImageFilter : GPUImageFilter
{
    int redWeightUniform;
    int blueWeightUniform;
}

@property (nonatomic, readwrite) int redWeight;
@property (nonatomic, readwrite) int blueWeight;

@end
