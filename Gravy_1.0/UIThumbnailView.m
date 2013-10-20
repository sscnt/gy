//
//  UIThumbnailView.m
//  Gravy_1.0
//
//  Created by SSC on 2013/10/17.
//  Copyright (c) 2013年 SSC. All rights reserved.
//

#import "UIThumbnailView.h"

@implementation UIThumbnailView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.layer.shadowColor = [UIColor blackColor].CGColor;
        self.layer.shadowOffset = CGSizeMake(0, 0);
        self.layer.shadowOpacity = 1;
        self.layer.shadowRadius = 4.0;
    }
    return self;
}

- (void)touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event
{
    // ここで、タッチが開始されたときの処理を実装します。
    [self.delegate touchesBegan:self];
    
}

- (void)touchesMoved:(NSSet*)touches withEvent:(UIEvent*)event
{
    // ここで、タッチが動かされたときの処理を実装します。
    
}

- (void)touchesEnded:(NSSet*)touches withEvent:(UIEvent*)event
{
    // ここで、タッチが離されたときの処理を実装します。
    [self.delegate touchesEnded:self];
    
}

- (void)touchesCanceled:(NSSet*)touches withEvent:(UIEvent*)event
{
    // ここで、タッチがキャンセルされたときの処理を実装します。
    [self.delegate touchesEnded:self];
}

@end
