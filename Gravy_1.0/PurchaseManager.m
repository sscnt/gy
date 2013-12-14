//
//  PurchaseManager.m
//  Gravy_1.0
//
//  Created by SSC on 2013/12/07.
//  Copyright (c) 2013年 SSC. All rights reserved.
//

#import "PurchaseManager.h"

@implementation PurchaseManager

NSString* const keyForPurchasesEffectsBloom = @"purchases.effects.bloom";
NSString* const keyForPurchasesEffectsSunset = @"purchases.effects.sunset";
NSString* const keyForPurchasesEffectsVintage = @"purchases.effects.vintage";

NSString* const hashForEffectBloom = @"Qx2aVnJnJq8JoVYJ";
NSString* const hashForEffectVintage = @"PZCHkoEHOUDMMoZ6";
NSString* const hashForEffectSunset = @"GYDAllwCr7ScGuR3";

NSString* const productIdForEffectBloom = @"jp.ssctech.gravy.bloom";
NSString* const productIdForEffectVintage = @"jp.ssctech.gravy.vintage";
NSString* const productIdForEffectSunset = @"jp.ssctech.gravy.sunset";


+ (BOOL)isUntreatedTransaction
{
    return [SKPaymentQueue defaultQueue].transactions.count > 0 ? YES : NO;
}

+ (void)finishUntreatedTransaction
{
    NSArray *transactions = [SKPaymentQueue defaultQueue].transactions;
    for (SKPaymentTransaction *t in transactions) {
        dlog(@"%@ %@ %@ %@ %d", t, t.transactionIdentifier, t.transactionReceipt, t.transactionDate, t.transactionState);
        [[SKPaymentQueue defaultQueue] finishTransaction:t];
    }
}

#pragma  mark checking
+ (BOOL)didPurchaseCreamyEffect
{
    return true;
}

+ (BOOL)didPurchaseBloomEffect
{
    if([[UICKeyChainStore stringForKey:keyForPurchasesEffectsBloom] isEqualToString:hashForEffectBloom]){
        return true;
    }
    return false;
}

+ (BOOL)didPurchaseVintageEffect
{
    if([[UICKeyChainStore stringForKey:keyForPurchasesEffectsVintage] isEqualToString:hashForEffectVintage]){
        return true;
    }
    return false;
}

+ (BOOL)didPurchaseSunsetEffect
{
    if([[UICKeyChainStore stringForKey:keyForPurchasesEffectsSunset] isEqualToString:hashForEffectSunset]){
        return true;
    }
    return false;
}

+ (BOOL)didPurchaseEffectId:(EffectId)effectId
{
    if(effectId == EffectIdCreamy){
        return [PurchaseManager didPurchaseCreamyEffect];
    }
    if(effectId == EffectIdBloom){
        return [PurchaseManager didPurchaseBloomEffect];
    }
    if(effectId == EffectIdVintage){
        return [PurchaseManager didPurchaseVintageEffect];
    }
    if(effectId == EffectIdSunset){
        return [PurchaseManager didPurchaseSunsetEffect];
    }
    return NO;
}

#pragma mark purchasing

- (void)purchaseEffectByID:(EffectId)effectId
{
    targetEffectId = effectId;
    if(effectId == EffectIdBloom){
        [self purchaseProductByID:productIdForEffectBloom];
        return;
    }
    if(effectId == EffectIdVintage){
        [self purchaseProductByID:productIdForEffectVintage];
        return;
    }
    if(effectId == EffectIdSunset){
        [self purchaseProductByID:productIdForEffectSunset];
        return;
    }
}

- (void)purchaseProductByID:(NSString*)productId
{
    dlog(@"購入の準備をしています.");
    if (![SKPaymentQueue canMakePayments]) {
        dlog(@"エラー:アプリ内課金が無効です.");
        [self.delegate didFailToPurchaseWithError:PurchaseManagerErrorIAPNotAllowed];
        return;
    }
    if([PurchaseManager isUntreatedTransaction]){
        dlog(@"未完了のトランザクションが見つかりました.");
        [PurchaseManager finishUntreatedTransaction];
    }
    
    dlog(@"プロダクト情報を取得します.");
    NSSet *set = [NSSet setWithObjects:productId, nil];
    productsRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:set];
    productsRequest.delegate = self;
    [productsRequest start];
}

#pragma mark delegates

- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response
{
    // 無効なアイテムがないかチェック
    dlog(@"無効なアイテムを確認しています.");
    if ([response.invalidProductIdentifiers count] > 0) {
        dlog(@"エラー:無効なアイテムが見つかりました.");
        [self.delegate didFailToPurchaseWithError:PurchaseManagerErrorInvalidProduct];
        return;
    }
    // 購入処理開始
    dlog(@"購入処理を開始しました.");
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    for (SKProduct *product in response.products) {
        SKPayment *payment = [SKPayment paymentWithProduct:product];
        [[SKPaymentQueue defaultQueue] addPayment:payment];
    }
}
- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions
{
    dlog(@"トランザクションが更新されました.");
    for (SKPaymentTransaction *transaction in transactions) {
        if (transaction.transactionState == SKPaymentTransactionStatePurchasing) {
            // 購入処理中
            /*
             * 基本何もしなくてよい。処理中であることがわかるようにインジケータをだすなど。
             */
            dlog(@"購入処理中です.");
        } else if (transaction.transactionState == SKPaymentTransactionStatePurchased) {
            // 購入処理成功
            /*
             * ここでレシートの確認やアイテムの付与を行う。
             */
            dlog(@"購入しました.");
            [queue finishTransaction:transaction];
            [self didPurchase];
        } else if (transaction.transactionState == SKPaymentTransactionStateFailed) {
            // 購入処理エラー。ユーザが購入処理をキャンセルした場合もここにくる
            switch (transaction.error.code) {
                case SKErrorUnknown:
                    dlog(@"エラー:不明なエラー.");
                    break;
                case SKErrorClientInvalid:
                    dlog(@"エラー:許可されていない操作です.");
                    break;
                case SKErrorPaymentCancelled:
                    dlog(@"エラー:");
                    break;
                case SKErrorPaymentNotAllowed:
                    dlog(@"エラー:");
                    break;
                case SKErrorPaymentInvalid:
                    dlog(@"エラー:");
                    break;
                default:
                    break;
            }
            [queue finishTransaction:transaction];
            [self.delegate didFailToPurchaseWithError:PurchaseManagerErrorPaymentFailed];
        } else {
            // リストア処理完了
            /*
             * アイテムの再付与を行う
             */
            dlog(@"リストアしました.");
            [queue finishTransaction:transaction];
            [self didPurchase];
        }
    }		
}

- (void)updatePurchasedFlag
{
    if(targetEffectId == EffectIdBloom){
        [UICKeyChainStore setString:hashForEffectBloom forKey:keyForPurchasesEffectsBloom];
        return;
    }
    
    if(targetEffectId == EffectIdVintage){
        [UICKeyChainStore setString:hashForEffectVintage forKey:keyForPurchasesEffectsVintage];
        return;
    }
    
    if(targetEffectId == EffectIdSunset){
        [UICKeyChainStore setString:hashForEffectSunset forKey:keyForPurchasesEffectsSunset];
        return;
    }
}

- (void)didPurchase
{
    [self updatePurchasedFlag];
    [self.delegate didPurchase];
}

- (void)paymentQueue:(SKPaymentQueue *)queue removedTransactions:(NSArray *)transactions
{
    [[SKPaymentQueue defaultQueue] removeTransactionObserver:self];
}

- (void)dealloc
{
    productsRequest.delegate = nil;
}
@end
