//
//  GPUColorfulCandyEffect.h
//  Gravy_1.0
//
//  Created by SSC on 2013/11/01.
//  Copyright (c) 2013年 SSC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GPUImage.h"
#import "GPUColorfulCandyChannelMixer1ImageFilter.h"
#import "GPUColorfulCandyGradientFill1ImageFilter.h"


@interface GPUColorfulCandyEffect : NSObject

@property (nonatomic, weak) UIImage* imageToProcess;

- (UIImage*)generateGradientFill1;
- (UIImage*)generateColorFill1;

- (UIImage*)process;

@end
