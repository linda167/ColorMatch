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
@end

@implementation MainGameViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
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

@end
