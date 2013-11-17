//
//  UIEffectSelectionButton.h
//  Gravy_1.0
//
//  Created by SSC on 2013/11/17.
//  Copyright (c) 2013年 SSC. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, SelectedEffect){
    SelectedEffectCandy = 1
};

@interface UIEffectSelectionButton : UIView
{
    UIImageView* previewImageView;
    UILabel* titleLabel;
}

@property (nonatomic, assign) SelectedEffect selectedEffect;
@property (nonatomic, assign) BOOL selected;
@property (nonatomic, weak) UIImage* previewImage;
@property (nonatomic, strong) NSString* title;

@end
