//
//  UIKnobView.m
//  Gravy_1.0
//
//  Created by SSC on 2013/10/18.
//  Copyright (c) 2013年 SSC. All rights reserved.
//

#import "UISliderView.h"

@implementation UISliderView

- (id)init
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 60.0f, 60.0f);
    return [self initWithFrame:rect];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        UIImageView* sliderView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"slider.png"]];
        sliderView.center = self.center;
        [self addSubview:sliderView];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
