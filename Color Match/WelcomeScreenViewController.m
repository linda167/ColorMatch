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

@interface WelcomeScreenViewController()
@property UIView *logoView;
@end

@implementation WelcomeScreenViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
    
    _divider.alpha = 0;
    _button1.alpha = 0;
    _button2.alpha = 0;
    _button3.alpha = 0;
    _button4.alpha = 0;
    
    PaymentManager *paymentManager = [PaymentManager instance];
    paymentManager.transactionCompleteCallback = self;
    
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
    
    // Start music if not already playing
    if (![SoundManager sharedManager].playingMusic)
    {
        [[UserData sharedUserData] startMusic];
    }
    
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
    [[SoundManager sharedManager] playSound:@"menuSelect.mp3" looping:NO];
    [[PaymentManager instance] BuyGame];
}

- (IBAction)OnTapSettingsButton:(id)sender
{
    [[SoundManager sharedManager] playSound:@"menuSelect.mp3" looping:NO];
}

- (void)transactionCompleted
{
    // Called when purchase or restore is completed
    bool isPurchased = [[UserData sharedUserData] getGamePurchased];
    if (!isPurchased)
    {
        [[UserData sharedUserData] storeGamePurchased:true];
        [self OnGamePurchased];
    }
}

- (void)OnGamePurchased
{
    // If game is purchased, hide Buy Full Game button and move other buttons up
    _button4.frame = _button3.frame;
    _button3.frame = _button2.frame;
    _button2.hidden = true;
}

@end
