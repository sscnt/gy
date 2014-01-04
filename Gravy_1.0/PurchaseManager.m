//
//  PurchaseManager.m
//  Gravy_1.0
//
//  Created by SSC on 2013/12/07.
//  Copyright (c) 2013年 SSC. All rights reserved.
//

#import "PurchaseManager.h"

@implementation PurchaseManager

/* * 編集禁止 * */
NSString* const keyForPurchasesEffectsBloom = @"purchases.effects.bloom";
NSString* const keyForPurchasesEffectsSunset = @"purchases.effects.sunset";
NSString* const keyForPurchasesEffectsVintage = @"purchases.effects.vintage";
NSString* const keyForPurchasesEffectsFlare = @"purchases.effects.flare";
NSString* const keyForPurchasesEffectsVivid = @"purchases.effects.vivid";

/* * 編集禁止 * */
NSString* const hashForEffectBloom = @"fww0tfv0EQG75q7w";
NSString* const hashForEffectVintage = @"9r9sxQfF9xA6AH5t";
NSString* const hashForEffectSunset = @"gOfbMSNDbxxUe1ao";
NSString* const hashForEffectFlare = @"6AyXuJf5sgfKQl5c";
NSString* const hashForEffectVivid = @"UYECYa2naOHuGVGw";

/* * 編集禁止 * */
NSString* const productIdForEffectBloom = @"jp.ssctech.gravy.bloom";
NSString* const productIdForEffectVintage = @"jp.ssctech.gravy.vintage";
NSString* const productIdForEffectSunset = @"jp.ssctech.gravy.sunset";
NSString* const productIdForEffectFlare = @"jp.ssctech.gravy.flare";
NSString* const productIdForEffectVivid = @"jp.ssctech.gravy.vivid";

- (id)init
{
    self = [super init];
    if(self){
        [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
        isPausedPurchase = YES;
    }
    return self;
}

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

+ (BOOL)didPurchaseCakeEffect
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
    return true;
}

+ (BOOL)didPurchaseFlareEffect
{
    if([[UICKeyChainStore stringForKey:keyForPurchasesEffectsFlare] isEqualToString:hashForEffectFlare]){
        return true;
    }
    return false;
}

+ (BOOL)didPurchaseVividEffect
{
    if([[UICKeyChainStore stringForKey:keyForPurchasesEffectsVivid] isEqualToString:hashForEffectVivid]){
        return true;
    }
    return false;
}

+ (BOOL)didPurchaseEffectId:(EffectId)effectId
{
    if(effectId == EffectIdCreamy){
        return [PurchaseManager didPurchaseCreamyEffect];
    }
    if(effectId == effectidCake){
        return [PurchaseManager didPurchaseCakeEffect];
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
    if(effectId == EffectIdFlare){
        return [PurchaseManager didPurchaseFlareEffect];
    }
    if(effectId == EffectIdVivid){
        return [PurchaseManager didPurchaseVividEffect];
    }
    return NO;
}

+ (EffectId)productId2EffectId:(NSString *)productId
{
    if([productId isEqualToString:productIdForEffectBloom]){
        return EffectIdBloom;
    }
    if([productId isEqualToString:productIdForEffectVintage]){
        return EffectIdVintage;
    }
    if([productId isEqualToString:productIdForEffectSunset]){
        return EffectIdSunset;
    }
    if([productId isEqualToString:productIdForEffectFlare]){
        return EffectIdFlare;
    }
    if([productId isEqualToString:productIdForEffectVivid]){
        return EffectIdVivid;
    }
    return 0;
}


#pragma mark restoring

- (void)restore
{
     [[SKPaymentQueue defaultQueue] restoreCompletedTransactions];
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
    if(effectId == EffectIdFlare){
        [self purchaseProductByID:productIdForEffectFlare];
        return;
    }
    if(effectId == EffectIdVivid){
        [self purchaseProductByID:productIdForEffectVivid];
        return;
    }
}

- (void)purchaseProductByID:(NSString*)productId
{
    dlog(@"購入の準備をしています.");
    isPausedPurchase = NO;
    if (![SKPaymentQueue canMakePayments]) {
        dlog(@"エラー:アプリ内課金が無効です.");
        [self.delegate didFailToPurchaseWithError:PurchaseManagerErrorIAPNotAllowed];
        return;
    }
    if([PurchaseManager isUntreatedTransaction]){
        dlog(@"未完了のトランザクションが見つかりました.");
        [self.delegate didRestartPausedTransaction];
        [PurchaseManager finishUntreatedTransaction];
        return;
    }
    
    dlog(@"プロダクト情報を取得します.");
    NSSet *set = [NSSet setWithObjects:productId, nil];
    if(productsRequest){
        productsRequest.delegate = nil;
    }
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
    for (SKProduct *product in response.products) {
        SKPayment *payment = [SKPayment paymentWithProduct:product];
        [[SKPaymentQueue defaultQueue] addPayment:payment];
    }
}
- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions
{

    for (SKPaymentTransaction *transaction in transactions) {
        dlog(@"トランザクション[%@]が更新されました.", transaction.transactionIdentifier);
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
            dlog(@"トランザクション失敗.");
            // 購入処理エラー。ユーザが購入処理をキャンセルした場合もここにくる
            [queue finishTransaction:transaction];
            switch (transaction.error.code) {
                case SKErrorUnknown:
                    dlog(@"エラー:不明なエラー.");
                    [self.delegate didFailToPurchaseWithError:PurchaseManagerErrorUnknown];
                    break;
                case SKErrorClientInvalid:
                    dlog(@"エラー:許可されていない操作です.");
                    [self.delegate didFailToPurchaseWithError:PurchaseManagerErrorClientInvalid];
                    break;
                case SKErrorPaymentCancelled:
                    dlog(@"エラー:キャンセルされました.");
                    [self.delegate didFailToPurchaseWithError:PurchaseManagerErrorPaymentCancelled];
                    break;
                case SKErrorPaymentNotAllowed:
                    dlog(@"エラー:アプリ内の購入が許可されていません.");
                    [self.delegate didFailToPurchaseWithError:PurchaseManagerErrorPaymentNotAllowed];
                    break;
                case SKErrorPaymentInvalid:
                    dlog(@"エラー:不正な購入です.");
                    [self.delegate didFailToPurchaseWithError:PurchaseManagerErrorPaymentInvalid];
                    break;
                default:
                    dlog(@"エラー:予期せぬエラー.");
                    [self.delegate didFailToPurchaseWithError:PurchaseManagerErrorUnknown];
                    break;
            }
        } else {
            // リストア処理完了
            /*
             * アイテムの再付与を行う
             */
            dlog(@"リストアしました.");
            [queue finishTransaction:transaction];
            [self didRestoreProductId:transaction.originalTransaction.payment.productIdentifier];
        }
    }
    if(isPausedPurchase){
        dlog(@"購入を再開しています");
        [self.delegate didRestartPausedTransaction];
        isPausedPurchase = NO;
    }
}
- (void)request:(SKRequest *)request didFailWithError:(NSError *)error
{
    dlog(@"接続がタイムアウトしました");
    [self.delegate didFailToPurchaseWithError:PurchaseManagerErrorNetworkError];
}

- (void)updatePurchasedFlagByEffectId:(EffectId)effectId
{
    if(effectId == EffectIdBloom){
        [UICKeyChainStore setString:hashForEffectBloom forKey:keyForPurchasesEffectsBloom];
        return;
    }
    
    if(effectId == EffectIdVintage){
        [UICKeyChainStore setString:hashForEffectVintage forKey:keyForPurchasesEffectsVintage];
        return;
    }
    
    if(effectId == EffectIdSunset){
        [UICKeyChainStore setString:hashForEffectSunset forKey:keyForPurchasesEffectsSunset];
        return;
    }
    
    if(effectId == EffectIdFlare){
        [UICKeyChainStore setString:hashForEffectFlare forKey:keyForPurchasesEffectsFlare];
        return;
    }
    
    if(effectId == EffectIdVivid){
        [UICKeyChainStore setString:hashForEffectVivid forKey:keyForPurchasesEffectsVivid];
        return;
    }
}

- (void)updatePurchasedFlagByProductId:(NSString *)productId
{
    [self updatePurchasedFlagByEffectId:[PurchaseManager productId2EffectId:productId]];
}

- (void)didPurchase
{
    [self updatePurchasedFlagByEffectId:targetEffectId];
    [self.delegate didPurchase];
}

- (void)didRestoreProductId:(NSString *)productId
{
    [self updatePurchasedFlagByProductId:productId];
    
}
- (void)paymentQueue:(SKPaymentQueue *)queue removedTransactions:(NSArray *)transactions
{
    
}

- (void)paymentQueue:(SKPaymentQueue *)queue restoreCompletedTransactionsFailedWithError:(NSError *)error
{
    [self.delegate didFailToRestore];
}

- (void)paymentQueueRestoreCompletedTransactionsFinished:(SKPaymentQueue *)queue
{
    [self.delegate didAllRestorationsFinish];
}

- (void)dealloc
{
    [[SKPaymentQueue defaultQueue] removeTransactionObserver:self];
    productsRequest.delegate = nil;
}
@end
