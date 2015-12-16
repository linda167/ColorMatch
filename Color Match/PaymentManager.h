//
//  PaymentManager.h
//  Color Match
//
//  Created by Linda Chen on 12/15/15.
//  Copyright © 2015 SunSpark Entertainment. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol PurchaseOrRestoreDelegate
- (void)transactionCompleted;
@end

@interface PaymentManager : NSObject
@property(nonatomic, assign)id transactionCompleteCallback;
+(id)instance;
- (void)BuyGame;
- (void)RestorePurchase;
@end
