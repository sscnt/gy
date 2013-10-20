//
//  UIScrollView+Gravy.m
//  Gravy_1.0
//
//  Created by SSC on 2013/10/20.
//  Copyright (c) 2013年 SSC. All rights reserved.
//

#import "UIScrollView+Gravy.h"

@implementation UIScrollView (Gravy)

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [[self nextResponder] touchesBegan:touches withEvent:event];
}

@end
