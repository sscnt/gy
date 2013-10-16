//
//  bottomButtons.h
//  Gravy_1.0
//
//  Created by SSC on 2013/10/15.
//  Copyright (c) 2013年 SSC. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, UIDockViewType){
    UIDockViewTypeLight = 1,
    UIDockViewTypeDark
};

@interface UIDockView : UIView

- (id) init:(UIDockViewType)type;

@end
