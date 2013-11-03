//
//  GPUColorfulCandyEffect.h
//  Gravy_1.0
//
//  Created by SSC on 2013/11/01.
//  Copyright (c) 2013年 SSC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GPUImage.h"
#import "GPUImageGradientLayerFilterGroup.h"
#import "GPUImageChannelMixerFilter.h"

@interface GPUColorfulCandyEffect : NSObject

@property (nonatomic, weak) UIImage* imageToProcess;

- (UIImage*)process;

@end
