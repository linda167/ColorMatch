//
//  PurchaseGameViewController.m
//  Color Match
//
//  Created by Linda Chen on 12/22/15.
//  Copyright © 2015 SunSpark Entertainment. All rights reserved.
//

#import "PurchaseGameViewController.h"
#import "SoundManager.h"
#import "PaymentManager.h"
#import <QuartzCore/QuartzCore.h>

@interface PurchaseGameViewController ()

@end

@implementation PurchaseGameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    int centerWidth = self.view.frame.size.width / 2;
    self.buyButton.center = CGPointMake(centerWidth, self.buyButton.center.y);
    self.titleLabel.center = CGPointMake(centerWidth, self.titleLabel.center.y);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)OnTapBuyGameButton:(id)sender
{
    [[SoundManager sharedManager] playSound:@"menuSelect.mp3" looping:NO];
    [[PaymentManager instance] BuyGame];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end