//
//  UIEffectSelectionView.h
//  Gravy_1.0
//
//  Created by SSC on 2013/11/17.
//  Copyright (c) 2013年 SSC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+Gravy.h"
#import "UIScreen+Gravy.h"
#import "UIEffectSelectionButton.h"


@protocol UIEffectSelectionViewDelegate <NSObject>
- (void)effectSelected:(EffectId)effectId;
@end

@interface UIEffectSelectionView : UIView <UIEffectSelectionButtonDelegate>
{
    UIScrollView* scrollView;
    
    UIEffectSelectionButton* buttonNone;
    UIEffectSelectionButton* buttonCandy;
    UIEffectSelectionButton* buttonVintage;
}

@property (nonatomic, weak) id<UIEffectSelectionViewDelegate> delegate;
@property (nonatomic, weak) UIImage* effectPreviewImage;

@end
