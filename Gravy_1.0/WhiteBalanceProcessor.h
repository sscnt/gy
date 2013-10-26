//
//  whiteBalanceProcessor.h
//  Gravy_1.0
//
//  Created by SSC on 2013/10/26.
//  Copyright (c) 2013年 SSC. All rights reserved.
//

#import "ImageProcessor.h"

@interface WhiteBalanceProcessor : ImageProcessor

@property (nonatomic, assign) NSInteger wbRedWeight;
@property (nonatomic, assign) NSInteger wbBlueWeight;

@end
