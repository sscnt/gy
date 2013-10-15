//
//  UIView+Gravy.m
//  Gravy_1.0
//
//  Created by SSC on 2013/10/15.
//  Copyright (c) 2013年 SSC. All rights reserved.
//

#import "UIView+Gravy.h"

@implementation UIView (Gravy)

-(CGFloat)bottom
{
    return self.frame.origin.y + self.bounds.size.height;
}
-(CGFloat)right
{
    return self.frame.origin.x + self.frame.size.width;
}

-(void)setShadow
{
    UIBezierPath* roundedRectanglePath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0 + 1.0, 0 + 4.0, self.frame.size.width, self.frame.size.height) byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(6.0, 6.0)];
    [roundedRectanglePath closePath];
    
    self.layer.masksToBounds = NO;
    self.layer.shadowColor = [UIColor colorWithWhite:0.0 alpha:1.0].CGColor;
    self.layer.shadowPath = [roundedRectanglePath CGPath];
    self.layer.shadowRadius = 1.5;
    self.layer.shadowOpacity = 0.15;
}

-(void)setX:(NSInteger)x
{
    self.frame = CGRectMake( x, self.frame.origin.y, self.frame.size.width, self.frame.size.height );
}

- (void)setY:(NSInteger)y
{
    self.frame = CGRectMake( self.frame.origin.x, y, self.frame.size.width, self.frame.size.height );
}
- (void)setCenterX:(CGFloat)x
{
    self.center = CGPointMake(x, self.center.y);
}

-(void) setCenterY:(CGFloat)y
{
    self.center = CGPointMake(self.center.x, y);
}

- (void)setWidth:(NSInteger)width
{
    self.frame = CGRectMake( self.frame.origin.x, self.frame.origin.y, width, self.frame.size.height );
}

- (void)setHeight:(NSInteger)height
{
    self.frame = CGRectMake( self.frame.origin.x, self.frame.origin.y, self.frame.size.width, height );
}

- (void)setOrigin:(CGPoint)point
{
    self.frame = CGRectMake(point.x, point.y, self.frame.size.width, self.frame.size.height);
}

- (void)setSize:(CGSize)size
{
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, size.width, size.height);
}

- (void)setViewSizeHalf:(UIView*)view
{
    view.frame = CGRectMake(view.frame.origin.x, view.frame.origin.y, view.frame.size.width/2, view.frame.size.height/2);
}

@end
