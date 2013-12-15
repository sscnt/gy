//
//  PurchaseManager.h
//  Gravy_1.0
//
//  Created by SSC on 2013/12/07.
//  Copyright (c) 2013年 SSC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>
#import "UICKeyChainStore.h"

typedef NS_ENUM(NSInteger, PurchaseManagerError){
    PurchaseManagerErrorIAPNotAllowed = 1,
    PurchaseManagerErrorInvalidProduct,
    PurchaseManagerErrorPaymentFailed,
    PurchaseManagerErrorUnknown,
    PurchaseManagerErrorClientInvalid,
    PurchaseManagerErrorPaymentCancelled,
    PurchaseManagerErrorPaymentInvalid,
    PurchaseManagerErrorPaymentNotAllowed
};

@protocol PurchaseManagerDelegate <NSObject>
@optional
- (void)didPurchase;
- (void)didRestartPausedTransaction;
- (void)didRestoreEffect:(EffectId)effectId;
- (void)didAllRestorationsFinish;
- (void)didFailToPurchaseWithError:(PurchaseManagerError)error;
- (void)didFailToRestore;
@end



@interface PurchaseManager : NSObject <SKProductsRequestDelegate, SKPaymentTransactionObserver>
{
    EffectId targetEffectId;
    SKProductsRequest *productsRequest;
    BOOL isPausedPurchase;
}

@property (nonatomic, weak) id<PurchaseManagerDelegate> delegate;

+ (BOOL)isUntreatedTransaction;
+ (void)finishUntreatedTransaction;

+ (BOOL)didPurchaseCreamyEffect;
+ (BOOL)didPurchaseCakeEffect;
+ (BOOL)didPurchaseBloomEffect;
+ (BOOL)didPurchaseVintageEffect;
+ (BOOL)didPurchaseSunsetEffect;
+ (BOOL)didPurchaseFlareEffect;
+ (BOOL)didPurchaseVividEffect;

+ (BOOL)didPurchaseEffectId:(EffectId)effectId;
+ (EffectId)productId2EffectId:(NSString*)productId;

- (void)restore;

- (void)purchaseEffectByID:(EffectId)effectId;
- (void)purchaseProductByID:(NSString*)productId;

- (void)didPurchase;
- (void)didRestoreProductId:(NSString*)productId;
- (void)updatePurchasedFlagByEffectId:(EffectId)effectId;
- (void)updatePurchasedFlagByProductId:(NSString*)productId;

@end
