//
//  PurchaseManager.m
//  Gravy_1.0
//
//  Created by SSC on 2013/12/07.
//  Copyright (c) 2013年 SSC. All rights reserved.
//

#import "PurchaseManager.h"

@implementation PurchaseManager

NSString* const keyForPurchasesEffectsCandy = @"purchases.effects.candy";
NSString* const keyForPurchasesEffectsSunset = @"purchases.effects.sunset";
NSString* const keyForPurchasesEffectsVintage = @"purchases.effects.vintage";

NSString* const  candyEffectCheckingStr = @"Qx2aVnJnJq8JoVYJ";
NSString* const vintageEffectCheckingStr = @"PZCHkoEHOUDMMoZ6";
NSString* const sunsetEffectCheckingStr = @"GYDAllwCr7ScGuR3";

#pragma  mark checking
+ (BOOL)didPurchaseCreamyEffect
{
    return true;
}

+ (BOOL)didPurchaseCandyEffect
{
    if([[UICKeyChainStore stringForKey:keyForPurchasesEffectsCandy] isEqualToString:candyEffectCheckingStr]){
        return true;
    }
    return false;
}

+ (BOOL)didPurchaseVintageEffect
{
    if([[UICKeyChainStore stringForKey:keyForPurchasesEffectsVintage] isEqualToString:vintageEffectCheckingStr]){
        return true;
    }
    return false;
}

+ (BOOL)didPurchaseSunsetEffect
{
    if([[UICKeyChainStore stringForKey:keyForPurchasesEffectsSunset] isEqualToString:sunsetEffectCheckingStr]){
        return true;
    }
    return false;
}

+ (BOOL)didPurchaseEffectId:(EffectId)effectId
{
    if(effectId == EffectIdCreamy){
        return [PurchaseManager didPurchaseCreamyEffect];
    }
    if(effectId == EffectIdCandy){
        return [PurchaseManager didPurchaseCandyEffect];
    }
    if(effectId == EffectIdVintage){
        return [PurchaseManager didPurchaseVintageEffect];
    }
    if(effectId == EffectIdSunset){
        return [PurchaseManager didPurchaseSunsetEffect];
    }
    return NO;
}

@end
