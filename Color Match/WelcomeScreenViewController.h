//
//  WelcomeScreenViewController.h
//  Color Match
//
//  Created by Linda Chen on 12/28/14.
//  Copyright (c) 2014 SunSpark Entertainment. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PaymentManager.h"

@interface WelcomeScreenViewController : UIViewController <PurchaseOrRestoreDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *logo;
@property (weak, nonatomic) IBOutlet UIImageView *divider;
@property (weak, nonatomic) IBOutlet UIButton *button1;
@property (weak, nonatomic) IBOutlet UIButton *button2;
@property (weak, nonatomic) IBOutlet UIButton *button3;
@property (weak, nonatomic) IBOutlet UIButton *button4;
@property (weak, nonatomic) IBOutlet UIButton *debugButton;

- (void)transactionCompleted;

@end
