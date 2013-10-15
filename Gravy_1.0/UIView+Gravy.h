//
//  UIView+Gravy.h
//  Gravy_1.0
//
//  Created by SSC on 2013/10/15.
//  Copyright (c) 2013年 SSC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Gravy)
- (CGFloat)bottom;
- (CGFloat)right;
- (void)setShadow;
- (void)setX:(NSInteger)x;
- (void)setY:(NSInteger)y;
- (void)setCenterX:(CGFloat)x;
- (void)setCenterY:(CGFloat)y;
- (void)setWidth:(NSInteger)width;
- (void)setHeight:(NSInteger)height;
- (void)setOrigin:(CGPoint)point;
- (void)setSize:(CGSize)size;
@end
