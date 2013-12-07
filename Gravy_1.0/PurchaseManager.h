//
//  PurchaseManager.h
//  Gravy_1.0
//
//  Created by SSC on 2013/12/07.
//  Copyright (c) 2013年 SSC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UICKeyChainStore.h"

@interface PurchaseManager : NSObject
{
    NSString* keyForPurchasesEffectsCandy;
    NSString* keyForPurchasesEffectsVintage;
    NSString* keyForPurchasesEffectsSunset;
    
    NSString* candyEffectCheckingStr;
    NSString* vintageEffectCheckingStr;
    NSString* sunsetEffectCheckingStr;
}

+ (BOOL)didPurchaseCreamyEffect;
+ (BOOL)didPurchaseCandyEffect;
+ (BOOL)didPurchaseVintageEffect;
+ (BOOL)didPurchaseSunsetEffect;

+ (BOOL)didPurchaseEffectId:(EffectId)effectId;

@end
