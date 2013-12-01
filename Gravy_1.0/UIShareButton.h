//
//  UIShareButton.h
//  Gravy_1.0
//
//  Created by SSC on 2013/12/01.
//  Copyright (c) 2013年 SSC. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, ButtonType){
    ButtonTypeTwitter = 1,
    ButtonTypeFacebook,
    ButtonTypeLine,
    ButtonTypeInstagram
};

@interface UIShareButton : UIButton
{
    UIColor* _borderColor;
    UIColor* _topColor;
    UIColor* _bottomColor;
    UIColor* _innerGlow;
    UIColor* _highlightedColor;
    UIColor* _textColor;
    UIColor* _textShadowColor;
}

@property (nonatomic, assign) ButtonType type;

+ (UIShareButton*)twitter:(CGRect)frame;
- (void)setTwitterColor;

+ (UIShareButton*)facebook:(CGRect)frame;
- (void)setFacebookColor;

+ (UIShareButton*)instagram:(CGRect)frame;
- (void)setInstagramColor;

+ (UIShareButton*)line:(CGRect)frame;
- (void)setLineColor;


- (void)setFont;



@end