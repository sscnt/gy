//
//  UIEffectSelectionButton.h
//  Gravy_1.0
//
//  Created by SSC on 2013/11/17.
//  Copyright (c) 2013年 SSC. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "GPUEffectColorfulCandy.h"


typedef NS_ENUM(NSInteger, EffectId){
    EffectIdNone = 1,
    EffectIdCandy
};
@class UIEffectSelectionButton;
@protocol UIEffectSelectionButtonDelegate <NSObject>
- (void)buttonPressed:(UIEffectSelectionButton*)button;
@end

@interface UIEffectSelectionButton : UIButton
{
    UIImageView* previewImageView;
    UILabel* titleLabel;
    BOOL _selected;
}

@property (nonatomic, weak) id<UIEffectSelectionButtonDelegate> delegate;
@property (nonatomic, assign) EffectId effectId;
@property (nonatomic, assign) BOOL selected;
@property (nonatomic, strong) NSString* title;

- (id)initWithEffectId:(EffectId)effectId previewImageBase:(UIImage*)baseImage;
- (void)initPreviewImageView:(UIImage*)baseImage;
- (void)didPress;
- (NSString*)titleFromEffectId:(EffectId)effectId;

@end