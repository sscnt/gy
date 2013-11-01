//
//  UIThumbnailView.h
//  Gravy_1.0
//
//  Created by SSC on 2013/10/17.
//  Copyright (c) 2013年 SSC. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef NS_ENUM(NSInteger, ThumbnailViewId){
    ThumbnailViewIdWhiteBalance = 1,
    ThumbnailViewIdLevels,
    ThumbnailViewIdSaturation,
    ThumbnailViewIdEffect
};


@class UIThumbnailView;

@protocol UIThumbnailViewDelegate <NSObject>
- (void)touchesBegan:(UIThumbnailView*)view;
- (void)touchesEnded:(UIThumbnailView*)view;
@end

@interface UIThumbnailView : UIImageView
@property (nonatomic, assign) id<UIThumbnailViewDelegate> delegate;
@property (nonatomic, assign) ThumbnailViewId thumbnailId;
@end
