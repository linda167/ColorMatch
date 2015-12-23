//
//  CMViewController.m
//  Color Match
//
//  Created by Linda Chen on 1/1/14.
//  Copyright (c) 2014 SunSpark Entertainment. All rights reserved.
//

#import "MainGameViewController.h"
#import "GridColorButton.h"
#import "GoalBoard.h"
#import "UserColorBoard.h"
#import "BoardCells.h"
#import "UserData.h"
#import "LevelsManager.h"
#import "HelpScreenViewController.h"
#import "MainGameManager.h"
#import "TutorialGameManager.h"
#import "SoundManager.h"

@interface MainGameViewController ()
@property int worldId;
@property int levelId;
@property int size;
@property bool isAdPresenting;
@end

@implementation MainGameViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    [self initUIElements];
    [self createGameManagerAndStartNewGame];
    
    // Change navigation bar appearance
    [self.navigationController.navigationBar setTintColor:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    if (self.isMovingFromParentViewController)
    {
        [[SoundManager sharedManager] playSound:@"backSelect.mp3" looping:NO];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    if (self.isAdPresenting)
    {
        self.isAdPresenting = false;
        [self.mainGameManager resumeGameAfterAd];
    }
}

- (void)initUIElements
{
    // Adjust UI element sizes to be proportional to phone size
    CGRect frame = self.topSectionContainer.frame;
    frame.size.width = self.view.frame.size.width;
    self.topSectionContainer.frame = frame;
    
    frame = self.GoalContainerView.frame;
    frame.origin.x = self.view.frame.size.width - frame.size.width;
    self.GoalContainerView.frame = frame;
    
    frame = self.ColorButtonBarContainer.frame;
    frame.size.width = self.view.frame.size.width;
    self.ColorButtonBarContainer.frame = frame;
    
    frame = self.GridContainerView.frame;
    frame.size.width = self.view.frame.size.width;
    frame.size.height = self.view.frame.size.height - self.topSectionContainer.frame.origin.y - self.topSectionContainer.frame.size.height - self.ColorButtonBarContainer.frame.size.height;
    self.GridContainerView.frame = frame;
    
    int colorButtonsCenter = (self.blueButton.frame.origin.x + self.blueButton.frame.size.width + self.redButton.frame.origin.x) / 2;
    int buttonOffset = self.view.frame.size.width / 2 - colorButtonsCenter;
    self.whiteButton.frame = CGRectOffset(self.whiteButton.frame, buttonOffset, 0);
    self.blueButton.frame = CGRectOffset(self.blueButton.frame, buttonOffset, 0);
    self.redButton.frame = CGRectOffset(self.redButton.frame, buttonOffset, 0);
    self.yellowButton.frame = CGRectOffset(self.yellowButton.frame, buttonOffset, 0);
}

- (void)createGameManagerAndStartNewGame
{
    if ([self isTutorialLevel:self.worldId levelId:self.levelId])
    {
        self.mainGameManager = [[TutorialGameManager alloc] initWithParameters:self size:self.size worldId:self.worldId levelId:self.levelId];
    }
    else
    {
        self.mainGameManager = [[MainGameManager alloc] initWithParameters:self size:self.size worldId:self.worldId levelId:self.levelId];
    }
    
    // Start new game
    [self.mainGameManager StartNewGame];
}

- (bool)isTutorialLevel:(int)worldId levelId:(int)levelId
{
    return levelId == 1 &&
        ![[UserData sharedUserData] getTutorialComplete:self.worldId];
}

- (void)SetParametersForNewGame:(int)size worldId:(int)worldId levelId:(int)levelId
{
    self.size = size;
    self.worldId = worldId;
    self.levelId = levelId;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)ColorButtonPressed:(id)sender
{
    [self.mainGameManager OnColorButtonPressed:sender];
}

- (IBAction)GridButtonPressed:(id)sender
{
    [self.mainGameManager OnGridButtonPressed:sender];
}

-(void)OnUserActionTaken
{
    [self.mainGameManager OnUserActionTaken];
}

- (IBAction)showHelpMenu:(id)sender
{
    [self.mainGameManager OnShowHelpMenu:sender];
}

- (void)CloseHelpMenu
{
    [self.mainGameManager CloseHelpMenu];
}

- (void)PresentAd
{
    self.interstitialPresentationPolicy = ADInterstitialPresentationPolicyManual;
    self.isAdPresenting = [self requestInterstitialAdPresentation];
    
    if (!self.isAdPresenting)
    {
        [self.mainGameManager resumeGameAfterAd];
    }
}

@end
