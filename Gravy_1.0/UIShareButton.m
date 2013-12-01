//
//  UIShareButton.m
//  Gravy_1.0
//
//  Created by SSC on 2013/12/01.
//  Copyright (c) 2013年 SSC. All rights reserved.
//

#import "UIShareButton.h"

@implementation UIShareButton

+ (UIShareButton*)twitter:(CGRect)frame
{
    UIShareButton* button = [[UIShareButton alloc] initWithFrame:frame];
    [button setTwitterColor];
    [button setFont];
    [button.titleLabel setShadowOffset:CGSizeMake(0.0f, 1.0f)];
    return button;
}

- (void)setTwitterColor
{
    _borderColor = [UIColor colorWithRed:21.0f/255.0f green:84.0f/255.0f blue:134.0f/255.0f alpha:1.00f];
    _topColor = [UIColor colorWithRed:85.0f/255.0f green:172.0f/255.0f blue:239.0f/255.0f alpha:1.00f];
    _bottomColor = [UIColor colorWithRed:60.0f/255.0f green:136.0f/255.0f blue:196.0f/255.0f alpha:1.00f];
    _innerGlow = [UIColor colorWithWhite:1.0 alpha:0.2];
    _textColor = [UIColor colorWithWhite:1.0f alpha:1.0f];
    _highlightedColor = [UIColor colorWithWhite:1.0f alpha:1.0f];
    _textShadowColor = [UIColor colorWithWhite:0.1f alpha:0.40f];
}

+ (UIShareButton*)facebook:(CGRect)frame
{
    UIShareButton* button = [[UIShareButton alloc] initWithFrame:frame];
    [button setFacebookColor];
    [button setFont];
    [button.titleLabel setShadowOffset:CGSizeMake(0.0f, 1.0f)];
    return button;
}

- (void)setFacebookColor
{
    _borderColor = [UIColor colorWithRed:47.0f/255.0f green:70.0f/255.0f blue:146.0f/255.0f alpha:1.00f];
    _topColor = [UIColor colorWithRed:98.0f/255.0f green:134.0f/255.0f blue:210.0f/255.0f alpha:1.00f];
    _bottomColor = [UIColor colorWithRed:45.0f/255.0f green:74.0f/255.0f blue:134.0f/255.0f alpha:1.00f];
    _innerGlow = [UIColor colorWithWhite:1.0 alpha:0.2];
    _textColor = [UIColor colorWithWhite:1.0f alpha:1.0f];
    _highlightedColor = [UIColor colorWithWhite:0.90f alpha:1.0f];
    _textShadowColor = [UIColor colorWithWhite:0.1f alpha:0.40f];
}


+ (UIShareButton*)instagram:(CGRect)frame
{
    UIShareButton* button = [[UIShareButton alloc] initWithFrame:frame];
    [button setInstagramColor];
    [button setFont];
    [button.titleLabel setShadowOffset:CGSizeMake(0.0f, 1.0f)];
    return button;
}

- (void)setInstagramColor
{
    _borderColor = [UIColor colorWithRed:82.0f/255.0f green:44.0f/255.0f blue:29.0f/255.0f alpha:1.00f];
    _topColor = [UIColor colorWithRed:188.0f/255.0f green:154.0f/255.0f blue:126.0f/255.0f alpha:1.00f];
    _bottomColor = [UIColor colorWithRed:136.0f/255.0f green:81.0f/255.0f blue:61.0f/255.0f alpha:1.00f];
    _innerGlow = [UIColor colorWithWhite:1.0 alpha:0.2];
    _textColor = [UIColor colorWithWhite:1.0f alpha:1.0f];
    _highlightedColor = [UIColor colorWithWhite:0.90f alpha:1.0f];
    _textShadowColor = [UIColor colorWithWhite:0.1f alpha:0.40f];
}

+ (UIShareButton*)line:(CGRect)frame
{
    UIShareButton* button = [[UIShareButton alloc] initWithFrame:frame];
    [button setLineColor];
    [button setFont];
    [button.titleLabel setShadowOffset:CGSizeMake(0.0f, 1.0f)];
    return button;
}

- (void)setLineColor
{
    _borderColor = [UIColor colorWithRed:7.0f/255.0f green:129.0f/255.0f blue:0.0f/255.0f alpha:1.00f];
    _topColor = [UIColor colorWithRed:188.0f/255.0f green:246.0f/255.0f blue:48.0f/255.0f alpha:1.00f];
    _bottomColor = [UIColor colorWithRed:27.0f/255.0f green:179.0f/255.0f blue:9.0f/255.0f alpha:1.00f];
    _innerGlow = [UIColor colorWithWhite:1.0 alpha:0.4];
    _textColor = [UIColor colorWithWhite:1.0f alpha:1.0f];
    _highlightedColor = [UIColor colorWithWhite:0.90f alpha:1.0f];
    _textShadowColor = [UIColor colorWithWhite:0.1f alpha:0.40f];
}

- (void)setFont
{
    [self setTitleColor:_highlightedColor forState:UIControlStateHighlighted];
    [self setTitleColor:_highlightedColor forState:UIControlStateSelected];
    [self setTitleColor:_textColor forState:UIControlStateNormal];
    [self.titleLabel setFont:[UIFont fontWithName:@"TrebuchetMS-Bold" size:20]];
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
    UIBezierPath* roundedRectanglePath = [UIBezierPath bezierPathWithRoundedRect: CGRectMake(0, 0, rect.size.width, rect.size.height) cornerRadius: 4];
    
    // Use the bezier as a clipping path
    [roundedRectanglePath addClip];
    
    // Use one of the two gradients depending on the state of the button
    CGGradientRef background = self.highlighted? highlightedGradient : gradient;
    
    // Draw gradient within the path
    CGContextDrawLinearGradient(context, background, CGPointMake(rect.size.width / 2, 0), CGPointMake(rect.size.width / 2, rect.size.height), 0);
    
    // Draw border
    [_borderColor setStroke];
    roundedRectanglePath.lineWidth = 2;
    [roundedRectanglePath stroke];
    
    // Draw Inner Glow
    UIBezierPath *innerGlowRect = [UIBezierPath bezierPathWithRoundedRect: CGRectMake(1.5, 1.5, rect.size.width - 3, rect.size.height - 3) cornerRadius: 2.5];
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
