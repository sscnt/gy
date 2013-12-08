//
//  UIBuyButton.m
//  Gravy_1.0
//
//  Created by SSC on 2013/12/08.
//  Copyright (c) 2013年 SSC. All rights reserved.
//

#import "UIBuyButton.h"

@implementation UIBuyButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _borderColor = [UIColor colorWithRed:160.0f/255.0f green:160.0f/255.0f blue:160.0f/255.0f alpha:1.00f];
        _topColor = [UIColor colorWithRed:250.0f/255.0f green:250.0f/255.0f blue:250.0f/255.0f alpha:1.00f];
        _bottomColor = [UIColor colorWithRed:228.0f/255.0f green:227.0f/255.0f blue:223.0f/255.0f alpha:1.00f];
        _innerGlow = [UIColor colorWithWhite:1.0 alpha:1.0f];
        _textColor = [UIColor colorWithWhite:102.0f/255.0f alpha:1.0f];
        _highlightedColor = [UIColor colorWithWhite:90.0f/255.0f alpha:1.0f];
        _textShadowColor = [UIColor colorWithWhite:1.0f alpha:1.0f];

        [self setFont];
        [self.titleLabel setShadowOffset:CGSizeMake(0.0f, 1.0f)];
    }
    return self;
}

- (void)setFont
{
    [self setTitleColor:_highlightedColor forState:UIControlStateHighlighted];
    [self setTitleColor:_highlightedColor forState:UIControlStateSelected];
    [self setTitleColor:_textColor forState:UIControlStateNormal];
    [self.titleLabel setFont:[UIFont fontWithName:@"TrebuchetMS-Bold" size:14]];
    [self.titleLabel setShadowColor:[UIColor redColor]];
    [self.titleLabel setShadowOffset:CGSizeMake(0.0f, -1.0f)];
    [self setTitleShadowColor:_textShadowColor forState:UIControlStateNormal];
}


- (void)drawRect:(CGRect)rect
{
    // General Declarations
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // Gradient Declarations
    NSArray *gradientColors = (@[
                                 (id)_topColor.CGColor,
                                 (id)_bottomColor.CGColor
                                 ]);
    
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef)(gradientColors), NULL);
    
    NSArray *highlightedGradientColors = (@[
                                            (id)_bottomColor.CGColor,
                                            (id)_topColor.CGColor
                                            ]);
    
    CGGradientRef highlightedGradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef)(highlightedGradientColors), NULL);
    
    // Draw rounded rectangle bezier path
    UIBezierPath* roundedRectanglePath = [UIBezierPath bezierPathWithRoundedRect: CGRectMake(0.0f, 2.0f, rect.size.width, rect.size.height - 2.0f) cornerRadius: 4];
    [_borderColor setFill];
    [roundedRectanglePath fill];
    
    // Draw rounded rectangle bezier path
    roundedRectanglePath = [UIBezierPath bezierPathWithRoundedRect: CGRectMake(0.0f, 0.0f, rect.size.width, rect.size.height - 2.0f) cornerRadius: 4];
    
    // Use the bezier as a clipping path
    [roundedRectanglePath addClip];
    
    // Use one of the two gradients depending on the state of the button
    CGGradientRef background = self.highlighted? highlightedGradient : gradient;
    
    // Draw gradient within the path
    CGContextDrawLinearGradient(context, background, CGPointMake(rect.size.width / 2, 0), CGPointMake(rect.size.width / 2, rect.size.height - 2.0f), 0);
    
    // Draw border
    [_borderColor setStroke];
    roundedRectanglePath.lineWidth = 2;
    [roundedRectanglePath stroke];
    
    // Draw Inner Glow
    UIBezierPath *innerGlowRect = [UIBezierPath bezierPathWithRoundedRect: CGRectMake(1.5, 1.5, rect.size.width - 3.0f, rect.size.height - 4.0f) cornerRadius: 2.5];
    [_innerGlow setStroke];
    innerGlowRect.lineWidth = 1;
    [innerGlowRect stroke];
    
    // Cleanup
    CGGradientRelease(gradient);
    CGGradientRelease(highlightedGradient);
    CGColorSpaceRelease(colorSpace);
}

- (void)setHighlighted:(BOOL)highlighted
{
    [self setNeedsDisplay];
    [super setHighlighted:highlighted];
}


@end
