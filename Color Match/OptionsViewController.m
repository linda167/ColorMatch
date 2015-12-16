//
//  OptionsViewController.m
//  Color Match
//
//  Created by Linda Chen on 8/23/15.
//  Copyright (c) 2015 SunSpark Entertainment. All rights reserved.
//

#import "OptionsViewController.h"
#import "ViewControllerUtils.h"
#import "UserData.h"
#import "SoundManager.h"
#import "PaymentManager.h"

@interface OptionsViewController ()
@property UIButton *soundCheckButton;
@property UIButton *musicCheckButton;
@end

@implementation OptionsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Create title
    int titleOffset = 100;
    UILabel *optionsTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 50)];
    optionsTitle.font = [UIFont fontWithName:@"Futura-Medium" size:20.0];
    optionsTitle.textColor = [UIColor blackColor];
    optionsTitle.text = [NSString stringWithFormat: @"Settings"];
    [optionsTitle sizeToFit];
    [optionsTitle setCenter:CGPointMake(self.view.frame.size.width / 2 - 10, titleOffset)];
    [self.view addSubview:optionsTitle];
    
    // Add sound option
    int xOffset = 30;
    int yOffset = titleOffset+50;
    self.soundCheckButton = [self
        addButtonWithText:@"Enable sound effects"
        xOffset:xOffset
        yOffset:yOffset
        checked:[[UserData sharedUserData] getIsSoundEnabled]];
    [self.soundCheckButton addTarget:self action:@selector(soundCheckBoxPressed:) forControlEvents:UIControlEventTouchUpInside];

    // Add music option
    yOffset = yOffset+55;
    self.musicCheckButton = [self
        addButtonWithText:@"Enable background music"
        xOffset:xOffset
        yOffset:yOffset
        checked:[[UserData sharedUserData] getIsMusicEnabled]];
    [self.musicCheckButton addTarget:self action:@selector(musicCheckBoxPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    // Add restore purchases option
    bool isPurchased = [[UserData sharedUserData] getGamePurchased];
    if (!isPurchased)
    {
        yOffset = yOffset+55;
        UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [button setFrame:CGRectMake(22, yOffset, 160, 40)];
        [button addTarget:self action:@selector(restorePurchase:) forControlEvents:UIControlEventTouchUpInside];
        button.titleLabel.font = [UIFont fontWithName:@"Futura-Medium" size:18.0];
        [button setTitle:@"Restore purchase" forState:UIControlStateNormal];
        [self.view addSubview:button];
    }
}

- (UIButton*)addButtonWithText:(NSString*)text xOffset:(int)xOffset yOffset:(int)yOffset checked:(bool)checked
{
    // Add button
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(xOffset, yOffset, 40, 40)];
    UIImage *buttonImage = [self getCheckBoxImageBasedOnState:checked];
    [button setImage:buttonImage forState:UIControlStateNormal];
    [self.view addSubview:button];
    
    // Add text
    xOffset += 60;
    yOffset += 9;
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(xOffset, yOffset, 100, 50)];
    title.font = [UIFont fontWithName:@"Futura-Medium" size:16.0];
    title.textColor = [UIColor blackColor];
    title.text = text;
    [title sizeToFit];
    [self.view addSubview:title];

    return button;
}

- (UIImage*)getCheckBoxImageBasedOnState:(bool)checked
{
    return checked ?
        [UIImage imageNamed:@"checkedBox@2x.png"] :
        [UIImage imageNamed:@"uncheckedBox@2x.png"];
}

- (IBAction)soundCheckBoxPressed:(id)sender
{
    bool isSoundEnabled = [[UserData sharedUserData] getIsSoundEnabled];
    
    // Toggle sound enabled
    isSoundEnabled = !isSoundEnabled;
    
    UIImage *checkboxImage = [self getCheckBoxImageBasedOnState:isSoundEnabled];
    
    [self.soundCheckButton setImage:checkboxImage forState:UIControlStateNormal];
    
    [[UserData sharedUserData] storeIsSoundEnabled:isSoundEnabled];
    
    [[SoundManager sharedManager] playSound:@"menuSelect.mp3" looping:NO forcePlay:true];
}

- (IBAction)musicCheckBoxPressed:(id)sender
{
    bool isMusicEnabled = [[UserData sharedUserData] getIsMusicEnabled];
    
    // Toggle music enabled
    isMusicEnabled = !isMusicEnabled;
    
    UIImage *checkboxImage = [self getCheckBoxImageBasedOnState:isMusicEnabled];
    
    [self.musicCheckButton setImage:checkboxImage forState:UIControlStateNormal];
    
    [[UserData sharedUserData] storeIsMusicEnabled:isMusicEnabled];
    
    [[SoundManager sharedManager] playSound:@"menuSelect.mp3" looping:NO];
    
    if (isMusicEnabled)
    {
        // TODO: lindach
        [[SoundManager sharedManager] playMusic:@"Crazy Candy Highway.mp3" looping:YES];
    }
    else
    {
        [[SoundManager sharedManager] stopMusic];
    }
}

- (IBAction)restorePurchase:(id)sender
{
    [[PaymentManager instance] RestorePurchase];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
