//
//  UIEffectSelectionView.h
//  Gravy_1.0
//
//  Created by SSC on 2013/11/17.
//  Copyright (c) 2013年 SSC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIScreen+Gravy.h"
#import "UIEffectSelectionButton.h"


@protocol UIThumbnailViewDelegate <NSObject>
- (void)effectSelected:(SelectedEffect)effect;
@end

@interface UIEffectSelectionView : UIView
{
    UIScrollView* scrollView;
    
    UIEffectSelectionButton* buttonNone;
    UIEffectSelectionButton* buttonCandy;
}

@property (nonatomic, weak) UIImage* effectPreviewImage;

@end
