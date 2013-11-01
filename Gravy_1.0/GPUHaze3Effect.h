//
//  GPUHaze3Effect.h
//  Gravy_1.0
//
//  Created by SSC on 2013/11/01.
//  Copyright (c) 2013年 SSC. All rights reserved.
//

#import "GPUImage.h"
#import "GPUImageFilterGroup.h"

@interface GPUHaze3Effect : GPUImageFilterGroup

@property (nonatomic, weak) UIImage* imageToProcess;

- (UIImage*)process;

@end
