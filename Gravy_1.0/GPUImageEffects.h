//
//  GPUImageEffects.h
//  Gravy_1.0
//
//  Created by SSC on 2013/11/04.
//  Copyright (c) 2013年 SSC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GPUImageEffects : NSObject

@property (nonatomic, weak) UIImage* imageToProcess;

- (UIImage*)process;

@end
