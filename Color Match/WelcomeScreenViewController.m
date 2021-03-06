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
#import "Appirater.h"
#import "WorldViewController.h"
#import "PurchaseGameViewController.h"
#import <StoreKit/StoreKit.h>
#import <Google/Analytics.h>

@interface WelcomeScreenViewController()
@property UIView *logoView;
@end

@implementation WelcomeScreenViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
    
    [self initUIElements];
    [self initPaymentManager];
    [self showLogo];
}

- (void)initUIElements
{
    [CommonUtils determineIphone4S:self.view];
    [CommonUtils determineIphone6Plus:self.view];
    
    // Hide elements to be animated in
    _divider.alpha = 0;
    _button1.alpha = 0;
    _button2.alpha = 0;
    _button3.alpha = 0;
    _button4.alpha = 0;
    
    // Turn off debug menu
    _debugButton.alpha = 0;
    
    // Center UI elements
    int centerWidth = self.view.frame.size.width / 2;
    _logo.center = CGPointMake(centerWidth, _logo.center.y);
    _divider.center = CGPointMake(centerWidth, _divider.center.y);
    _button1.center = CGPointMake(centerWidth, _button1.center.y);
    _button2.center = CGPointMake(centerWidth, _button2.center.y);
    _button3.center = CGPointMake(centerWidth, _button3.center.y);
    _button4.center = CGPointMake(centerWidth, _button4.center.y);
    
    // Adjust button Y location
    int dividerBottom = _divider.frame.origin.y + _divider.frame.size.height;
    int remainderSpace = self.view.frame.size.height - dividerBottom;
    int remainderSpaceMiddle = remainderSpace / 2 + dividerBottom;
    int button1Location = remainderSpaceMiddle - 120;
    int buttonAdjustment = button1Location - _button1.frame.origin.y;
    _button1.frame = CGRectOffset(_button1.frame, 0, buttonAdjustment);
    _button2.frame = CGRectOffset(_button2.frame, 0, buttonAdjustment);
    _button3.frame = CGRectOffset(_button3.frame, 0, buttonAdjustment);
    _button4.frame = CGRectOffset(_button4.frame, 0, buttonAdjustment);
    
    // Adjust debug button location
    CGRect frame = _debugButton.frame;
    frame.origin.x = self.view.frame.size.width - frame.size.width;
    frame.origin.y = self.view.frame.size.height - frame.size.height;
    _debugButton.frame = frame;
    
    // Update UI based on purchase state
    if ([[UserData sharedUserData] getGamePurchased])
    {
        [self OnGamePurchased];
    }
}

- (void)initPaymentManager
{
    PaymentManager *paymentManager = [PaymentManager instance];
    paymentManager.transactionCompleteCallback = self;
}

- (void)showLogo
{
    int viewportWidth = self.view.frame.size.width;
    int viewportHeight = self.view.frame.size.height;
    
    // Create logo image and scale it down to fit screen
    int logoWidth = viewportWidth - 34;
    UIImage* image = [UIImage imageNamed:@"logo@2x.png"];
    int imageHeight = image.size.height;
    double proportion = image.size.width / logoWidth;
    imageHeight = image.size.height / proportion;
    UIImageView *logoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, logoWidth, imageHeight)];
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
    
    int logoCenterY = [CommonUtils IsIphone6Plus] ? 200 : 162;
    
    // Drop down logo
    [UIView
     animateWithDuration:.80
     delay:0
     usingSpringWithDamping: .4
     initialSpringVelocity: .4
     options:UIViewAnimationOptionCurveLinear
     animations:^
     {
         _logo.center = CGPointMake(_logo.center.x, logoCenterY);
     }
     completion:^(BOOL finished)
     {
         [self fadeInDivider];
     }];
}

- (void)fadeInDivider {
    
    _divider.center = CGPointMake(_divider.center.x, _logo.center.y + _divider.frame.size.height / 2 +  66);
    
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
         [Appirater appLaunched:YES];
     }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    // Instrument
    NSString *name = @"Welcome screen";
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName value:name];
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
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
        
        UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
        WorldViewController *worldView = (WorldViewController*)[storyBoard instantiateViewControllerWithIdentifier:@"worldViewScreen"];
        NSMutableArray *backStack = [[NSMutableArray alloc] initWithArray:self.navigationController.viewControllers];
        [backStack insertObject:worldView atIndex:1];
        self.navigationController.viewControllers = backStack;
    }
    else
    {
        // Otherwise go to world view
        [self performSegueWithIdentifier:@"mainMenuToWorldSegue" sender:self];
    }
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
    
    // Pop buy game screen as needed
    UIViewController *topView = (UIViewController*)[self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count -1];
    if ([topView isKindOfClass:[PurchaseGameViewController class]])
    {
        [self.navigationController popViewControllerAnimated:true];
    }
}

@end
