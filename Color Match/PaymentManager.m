//
//  PaymentManager.m
//  Color Match
//
//  Created by Linda Chen on 12/15/15.
//  Copyright © 2015 SunSpark Entertainment. All rights reserved.
//

#import "PaymentManager.h"
#import "UserData.h"
#import <StoreKit/StoreKit.h>
#import <Google/Analytics.h>

@interface PaymentManager() <SKProductsRequestDelegate, SKPaymentTransactionObserver>
@end

@implementation PaymentManager

#define purchaseFullGameProductIdentifier @"ColorDashFullGame"

-(id)init:(int)cellType
{
    self = [super init];
    return self;
}

+(id)instance
{
    static PaymentManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (void)BuyGame
{
    if ([SKPaymentQueue canMakePayments])
    {
        SKProductsRequest *productsRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:[NSSet setWithObject:purchaseFullGameProductIdentifier]];
        productsRequest.delegate = self;
        [productsRequest start];
    }
    else
    {
        NSLog(@"User cannot make payments due to parental control");
    }
}

- (void)RestorePurchase
{
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    [[SKPaymentQueue defaultQueue] restoreCompletedTransactions];
}

- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response
{
    SKProduct *validProduct = nil;
    int count = (int)[response.products count];
    if (count > 0)
    {
        validProduct = [response.products objectAtIndex:0];
        NSLog(@"Products Available!");
        [self purchase:validProduct];
    }
    else
    {
        // Called if product id is not valid, should not be called otherwise
        NSLog(@"No products available!");
    }
}

- (IBAction)purchase:(SKProduct*)product
{
    SKPayment *payment = [SKPayment paymentWithProduct:product];
    
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    [[SKPaymentQueue defaultQueue] addPayment:payment];
}

- (void)paymentQueueRestoreCompletedTransactionsFinished:(SKPaymentQueue *)queue
{
    int purchasesRestoredCount = queue.transactions.count;
    if (purchasesRestoredCount == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"Restore failed"
                              message:@"No purchases found to restore"
                              delegate:self
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        [alert show];
    }
    else
    {
        for (SKPaymentTransaction *transaction in queue.transactions)
        {
            if (transaction.transactionState == SKPaymentTransactionStateRestored)
            {
                [self handleRestoreComplete];
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
            }
        }
    }
}

- (void)paymentQueue:(SKPaymentQueue*)queue updatedTransactions:(NSArray*)transactions
{
    for (SKPaymentTransaction *transaction in transactions)
    {
        switch (transaction.transactionState)
        {
            case SKPaymentTransactionStatePurchasing:
                // Called when user is in the process of purchasing. Do not add code here
                break;
            case SKPaymentTransactionStatePurchased:
                [self handlePurchaseComplete];
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                break;
            case SKPaymentTransactionStateRestored:
                [self handleRestoreComplete];
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                break;
            case SKPaymentTransactionStateFailed:
                // Called when transaction does not finish
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                break;
        }
    }
}

- (void)handlePurchaseComplete
{
    [self handlePurchaseOrRestoreComplete];
    
    // Instrument
    NSString *name = @"Remove ads successful";
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName value:name];
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
}

- (void)handleRestoreComplete
{
    bool isPurchased = [[UserData sharedUserData] getGamePurchased];
    if (!isPurchased)
    {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"Remove Ads Successful"
                              message:@"Ads have been fully removed."
                              delegate:self
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        [alert show];
        [self handlePurchaseOrRestoreComplete];
        
        // Instrument
        NSString *name = @"Remove ads successful";
        id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
        [tracker set:kGAIScreenName value:name];
        [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
    }
}

- (void)handlePurchaseOrRestoreComplete
{
    if ([self.transactionCompleteCallback respondsToSelector:@selector(transactionCompleted)])
    {
        [self.transactionCompleteCallback transactionCompleted];
    }
}


@end
