//
//  WelcomeScreenViewController.m
//  Color Match
//
//  Created by Linda Chen on 12/28/14.
//  Copyright (c) 2014 SunSpark Entertainment. All rights reserved.
//

#import "WelcomeScreenViewController.h"
#import "WorldViewController.h"
#import "MainGameViewController.h"
#import "UserData.h"
#import "SoundManager.h"
#import <StoreKit/StoreKit.h>

@interface WelcomeScreenViewController() <SKProductsRequestDelegate, SKPaymentTransactionObserver>
@property UIView *logoView;
@end

@implementation WelcomeScreenViewController

#define purchaseFullGameProductIdentifier @"ColorDashFullGame"

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
    
    _divider.alpha = 0;
    _button1.alpha = 0;
    _button2.alpha = 0;
    _button3.alpha = 0;
    _button4.alpha = 0;
    
    if ([[UserData sharedUserData] getGamePurchased])
    {
        [self OnGamePurchased];
    }
    
    [self showLogo];
}

- (void)showLogo
{
    int viewportWidth = self.view.frame.size.width;
    int viewportHeight = self.view.frame.size.height;
    
    // Create logo image and scale it down to fit screen
    UIImage* image = [UIImage imageNamed:@"logo@2x.png"];
    int imageHeight = image.size.height;
    double proportion = image.size.width / viewportWidth;
    imageHeight = image.size.height / proportion;
    UIImageView *logoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, viewportWidth, imageHeight)];
    logoImageView.image = image;
    
    // Add white background to host the image
    UIView* logoView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, viewportWidth, viewportHeight)];
    logoView.backgroundColor = [UIColor colorWithRed:(255/255.0) green:(255/255.0) blue:(255/255.0) alpha:1];
    
    logoImageView.center = self.view.center;
    [logoView addSubview:logoImageView];
    self.logoView = logoView;
    
    // Center the logo
    logoView.center = self.view.center;
    [self.view addSubview:logoView];
    
    // Fade out image
    [UIView
     animateWithDuration:.5
     delay:1.5
     options:UIViewAnimationOptionCurveEaseOut
     animations:^
     {
         logoView.alpha = 0.0;
     }
     completion:^(BOOL finished)
     {
         [self.logoView removeFromSuperview];
         [self dropDownLogo];
     }];
}

- (void)dropDownLogo {
    
    // Play sound:
    [[SoundManager sharedManager] playSound:@"intro.mp3" looping:NO];
    
    // Drop down logo
    [UIView
     animateWithDuration:.80
     delay:0
     usingSpringWithDamping: .4
     initialSpringVelocity: .4
     options:UIViewAnimationOptionCurveLinear
     animations:^
     {
         _logo.center = CGPointMake(_logo.center.x, 182);
     }
     completion:^(BOOL finished)
     {
         [self fadeInDivider];
     }];
}

- (void)fadeInDivider {
    
    // Fade in divider
    [UIView
     animateWithDuration:.5
     delay:0
     options:UIViewAnimationOptionCurveEaseOut
     animations:^
     {
         _divider.alpha = 1.0;
     }
     completion:^(BOOL finished)
     {
         [self fadeInButtons];
     }];
}

- (void)fadeInButtons {
    
    [self startMusic];
    
    // Fade in divider
    [UIView
     animateWithDuration:.5
     delay:0
     options:UIViewAnimationOptionCurveEaseOut
     animations:^
     {
         _button1.alpha = 1.0;
         _button2.alpha = 1.0;
         _button3.alpha = 1.0;
         _button4.alpha = 1.0;
     }
     completion:^(BOOL finished)
     {
     }];
}

- (void)startMusic
{
    // Start music if not already playing
    if (![SoundManager sharedManager].playingMusic)
    {
        [[SoundManager sharedManager] playMusic:@"Crazy Candy Highway.mp3" looping:YES];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [super viewWillDisappear:animated];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"mainMenuToFirstLevelSegue"])
    {
        MainGameViewController *destinationController = segue.destinationViewController;
        [destinationController SetParametersForNewGame:3 worldId:1 levelId:1];
    }
}

- (IBAction)OnTapPlayGameButton:(id)sender
{
    [[SoundManager sharedManager] playSound:@"menuSelect.mp3" looping:NO];
    
    if (![[UserData sharedUserData] getTutorialComplete:1])
    {
        // If tutorial is not complete for world 1, go directly to level 1-1
        [self performSegueWithIdentifier:@"mainMenuToFirstLevelSegue" sender:self];
    }
    else
    {
        // Otherwise go to world view
        [self performSegueWithIdentifier:@"mainMenuToWorldSegue" sender:self];
    }
}

- (IBAction)OnTapBuyGameButton:(id)sender
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

- (IBAction)OnTapSettingsButton:(id)sender
{
    // TODO: add settings page
    // TODO: for now, acts as test button for purchase full game
    bool isPurchased = [[UserData sharedUserData] getGamePurchased];
    
    if (!isPurchased)
    {
        [[UserData sharedUserData] storeGamePurchased:true];
        [self OnGamePurchased];
    }
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

- (IBAction)restore
{
    [[SKPaymentQueue defaultQueue] restoreCompletedTransactions];
}

- (void)paymentQueueRestoreCompletedTransactionsFinished:(SKPaymentQueue *)queue
{
    // TODO: lindach: Implement for restore
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
            case SKPaymentTransactionStateRestored:
                [self handlePurchaseFullGameComplete];
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                break;
            case SKPaymentTransactionStateFailed:
                // Called when transaction does not finish
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                break;
        }
    }
}

- (void)handlePurchaseFullGameComplete
{
    // TODO: lindach: Replace with logic to handle unlocking
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:@"Purchase Successful"
                          message:@"You have successfully purchased the full game. Thank you"
                          delegate:self
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil];
    [alert show];
    
    [self OnGamePurchased];
}

- (void)OnGamePurchased
{
    // If game is purchased, hide Buy Full Game button and move other buttons up
    _button4.frame = _button3.frame;
    _button3.frame = _button2.frame;
    _button2.hidden = true;
}

@end
