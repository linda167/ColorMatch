//
//  MainGameManager.m
//  Color Match
//
//  Created by Linda Chen on 7/3/15.
//  Copyright (c) 2015 SunSpark Entertainment. All rights reserved.
//

#import "MainGameManager.h"
#import "MainGameViewController.h"
#import "GoalBoard.h"
#import "UserColorBoard.h"
#import "BoardCells.h"
#import "UserData.h"
#import "LevelsManager.h"
#import "HelpScreenViewController.h"
#import "SoundManager.h"
#import "FullLevelId.h"
#import "CommonUtils.h"
#import <Google/Analytics.h>
#import "SCLAlertView.h"
#import "CreditsViewController.h"
@import GoogleMobileAds;

@interface MainGameManager () <GADInterstitialDelegate>

@property NSTimer *stopWatchTimer;
@property NSDate *startTime;
@property NSInteger movesCount;
@property GoalBoard *goalBoard;
@property NSTimeInterval timeInterval;
@property HelpScreenViewController *helpScreenViewController;
@property bool timerPaused;
@property(nonatomic, strong) GADInterstitial *interstitial;
@property AdPendingState adPendingState;
@end

@implementation MainGameManager

- (id)initWithParameters:(MainGameViewController*)viewController size:(int)size worldId:(int)worldId levelId:(int)levelId
{
    self = [super init];
    if (self)
    {
        self.viewController = viewController;
        self.boardParameters = [self getBoardParametersForSize:size];
        self.worldId = worldId;
        self.levelId = levelId;
        
        // Ad initialization
        [self cycleInterstitial];
    }
    
    return self;
}

- (void)StartNewGame
{
    // Render new game board
    [self renderNewBoard];
    
    // Generate new random goal state
    [self.goalBoard generateNewGoalBoardStates:self.worldId levelId:self.levelId];
    
    // Start the timer
    [self startTimer];
    
    // Init moves count
    [self initMovesCount];
    
    // Reset ad state
    self.adPendingState = None;
    
    // Mark this world as the one to auto scroll to in the world view
    [[UserData sharedUserData] storeLastLevelCompletedInWorld:self.worldId];
    
    // Instrument
    NSMutableString *levelString = [UserData getLevelString:self.worldId levelId:self.levelId];
    NSString *name = [NSString stringWithFormat:@"Game level %@", levelString];
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName value:name];
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
}

// Render new board to view given current parameters
- (void)renderNewBoard
{
    // Init board cell types
    [self loadBoardCellTypes];
    
    // Init goal color cells
    self.goalBoard = [[GoalBoard alloc] initWithParameters:(_boardParameters) containerView:self.viewController.GoalContainerView boardCells:_boardCells];
    
    // Init color cell sections
    self.userColorBoard = [[UserColorBoard alloc] initWithParameters:(_boardParameters) containerView:self.viewController.GridContainerView viewController:self.viewController boardCells:_boardCells];
    
    // Set the level name
    if ([LevelsManager IsRandomLevel:self.worldId levelId:self.levelId])
    {
        [self.viewController.LevelNumberLabel removeFromSuperview];
        [self.viewController.LevelLabel removeFromSuperview];
    }
    else
    {
        NSMutableString *levelString = [UserData getLevelString:self.worldId levelId:self.levelId];
        self.viewController.LevelNumberLabel.text = levelString;
    }
}

-(void)loadBoardCellTypes
{
    _boardCells = [LevelsManager LoadBoardCellTypes:self.worldId levelId:self.levelId boardParameters:_boardParameters];
}

-(BoardParameters)getBoardParametersForSize:(int)size
{
    struct BoardParameters boardParameters;
    boardParameters.gridSize = size;
    
    bool isIphone4S = [CommonUtils IsIphone4S];
    bool isIphone6Plus = [CommonUtils IsIphone6Plus];
    
    switch (size)
    {
        case 3:
            boardParameters.colorCellSize = isIphone4S ? 40 : 50;
            
            if (isIphone4S)
            {
                boardParameters.colorCellSpacing = 5;
            }
            else if (isIphone6Plus)
            {
                boardParameters.colorCellSpacing = 25;
            }
            else
            {
                boardParameters.colorCellSpacing = 14;
            }
            
            boardParameters.yOffsetForFirstTopGridButton= 4;
            boardParameters.xOffsetForFirstLeftGridButton = 31;
            boardParameters.emptyPaddingInGridButton = 13;
            boardParameters.goalColorCellSize = 46;
            boardParameters.goalColorCellSpacing = 8;
            boardParameters.xAdjustmentForColorCells = -4;
            boardParameters.reflectorArrowCellSize = isIphone4S ? 39: 49;
            boardParameters.reflectorLeftToDownArrowXAdjustment = 2;
            boardParameters.reflectorLeftToDownArrowYAdjustment = 6;
            boardParameters.reflectorTopToRightArrowXAdjustment = 6;
            boardParameters.reflectorTopToRightArrowYAdjustment = 2;
            boardParameters.reflectorMechanicLowerBound = 1;
            boardParameters.reflectorMechanicUpperBound = 1;
            boardParameters.zonerMechanicLowerBound = 1;
            boardParameters.zonerMechanicUpperBound = 1;
            boardParameters.connectorMechanicLowerBound = 2;
            boardParameters.connectorMechanicUpperBound = 2;
            boardParameters.diverterMechanicLowerBound = 1;
            boardParameters.diverterMechanicUpperBound = 1;
            boardParameters.splitterMechanicLowerBound = 1;
            boardParameters.splitterMechanicUpperBound = 1;
            boardParameters.transporterMechanicLowerBound = 1;
            boardParameters.transporterMechanicUpperBound = 1;
            boardParameters.transporterPerGroupLowerBound = 1;
            boardParameters.transporterPerGroupUpperBound = 1;
            boardParameters.transporterArrowSize = isIphone4S ? 33 : 43;
            boardParameters.transporterArrowDownXAdjustment = 4;
            boardParameters.transporterArrowDownYAdjustment = isIphone4S ? -18 : -16;
            boardParameters.transporterArrowDownYAdjustment2 = 7;
            boardParameters.transporterArrowRightXAdjustment = 7;
            boardParameters.transporterArrowRightXAdjustment2 = isIphone4S ? -18 : -16;
            boardParameters.transporterArrowRightYAdjustment = 4;
            break;
        case 4:
            boardParameters.colorCellSize = isIphone4S ? 32 : 40;
            
            if (isIphone4S)
            {
                boardParameters.colorCellSpacing = 5;
            }
            else if (isIphone6Plus)
            {
                boardParameters.colorCellSpacing = 20;
            }
            else
            {
                boardParameters.colorCellSpacing = 10;
            }
            
            boardParameters.yOffsetForFirstTopGridButton= 6;
            boardParameters.xOffsetForFirstLeftGridButton = 27;
            boardParameters.emptyPaddingInGridButton = 11;
            boardParameters.goalColorCellSize = 34;
            boardParameters.goalColorCellSpacing = 6;
            boardParameters.xAdjustmentForColorCells = -6;
            boardParameters.reflectorArrowCellSize = isIphone4S ? 31 : 39;
            boardParameters.reflectorLeftToDownArrowXAdjustment = 2;
            boardParameters.reflectorLeftToDownArrowYAdjustment = isIphone4S ? 5 : 8;
            boardParameters.reflectorTopToRightArrowXAdjustment = isIphone4S ? 5 : 8;
            boardParameters.reflectorTopToRightArrowYAdjustment = 2;
            boardParameters.reflectorMechanicLowerBound = 1;
            boardParameters.reflectorMechanicUpperBound = 2;
            boardParameters.zonerMechanicLowerBound = 1;
            boardParameters.zonerMechanicUpperBound = 2;
            boardParameters.connectorMechanicLowerBound = 2;
            boardParameters.connectorMechanicUpperBound = 3;
            boardParameters.diverterMechanicLowerBound = 1;
            boardParameters.diverterMechanicUpperBound = 2;
            boardParameters.splitterMechanicLowerBound = 1;
            boardParameters.splitterMechanicUpperBound = 2;
            boardParameters.transporterMechanicLowerBound = 1;
            boardParameters.transporterMechanicUpperBound = 1;
            boardParameters.transporterPerGroupLowerBound = 1;
            boardParameters.transporterPerGroupUpperBound = 2;
            boardParameters.transporterArrowSize = isIphone4S ? 27 : 35;
            boardParameters.transporterArrowDownXAdjustment = 3;
            boardParameters.transporterArrowDownYAdjustment = -14;
            boardParameters.transporterArrowDownYAdjustment2 = 7;
            boardParameters.transporterArrowRightXAdjustment = 7;
            boardParameters.transporterArrowRightXAdjustment2 = -16;
            boardParameters.transporterArrowRightYAdjustment = 3;
            break;
        case 5:
            boardParameters.colorCellSize = isIphone4S ? 26 : 35;
            
            if (isIphone4S)
            {
                boardParameters.colorCellSpacing = 3;
            }
            else if (isIphone6Plus)
            {
                boardParameters.colorCellSpacing = 16;
            }
            else
            {
                boardParameters.colorCellSpacing = 8;
            }
            
            boardParameters.yOffsetForFirstTopGridButton= isIphone4S ? 2 : 0;
            boardParameters.xOffsetForFirstLeftGridButton = 20;
            boardParameters.emptyPaddingInGridButton = 9;
            boardParameters.goalColorCellSize = 27;
            boardParameters.goalColorCellSpacing = 4;
            boardParameters.xAdjustmentForColorCells = 0;
            boardParameters.reflectorArrowCellSize = isIphone4S ? 27 : 35;
            boardParameters.reflectorLeftToDownArrowXAdjustment = isIphone4S ? 1 : 1;
            boardParameters.reflectorLeftToDownArrowYAdjustment = isIphone4S ? 3 : 5;
            boardParameters.reflectorTopToRightArrowXAdjustment = isIphone4S ? 3 : 5;
            boardParameters.reflectorTopToRightArrowYAdjustment = isIphone4S ? 1 : 1;
            boardParameters.reflectorMechanicLowerBound = 2;
            boardParameters.reflectorMechanicUpperBound = 4;
            boardParameters.zonerMechanicLowerBound = 2;
            boardParameters.zonerMechanicUpperBound = 3;
            boardParameters.connectorMechanicLowerBound = 3;
            boardParameters.connectorMechanicUpperBound = 5;
            boardParameters.diverterMechanicLowerBound = 2;
            boardParameters.diverterMechanicUpperBound = 4;
            boardParameters.splitterMechanicLowerBound = 2;
            boardParameters.splitterMechanicUpperBound = 3;
            boardParameters.transporterMechanicLowerBound = 1;
            boardParameters.transporterMechanicUpperBound = 1;
            boardParameters.transporterPerGroupLowerBound = 1;
            boardParameters.transporterPerGroupUpperBound = 2;
            boardParameters.transporterArrowSize = isIphone4S ? 23 : 29;
            boardParameters.transporterArrowDownXAdjustment = isIphone4S ? 2 : 4;
            boardParameters.transporterArrowDownYAdjustment = -12;
            boardParameters.transporterArrowDownYAdjustment2 = 7;
            boardParameters.transporterArrowRightXAdjustment = 7;
            boardParameters.transporterArrowRightXAdjustment2 = -10;
            boardParameters.transporterArrowRightYAdjustment = isIphone4S ? 2 : 4;
            break;
        default:
            [NSException raise:@"Invalid input" format:@"Invalid board size"];
            break;
    }
    
    // Adjust initial x and y for the board
    int cellSizePlusSpace = boardParameters.colorCellSize + boardParameters.colorCellSpacing;
    int gridTotalWidth = cellSizePlusSpace * (boardParameters.gridSize + 1) + boardParameters.xAdjustmentForColorCells;
    int currentGridMiddlePoint =
        boardParameters.xOffsetForFirstLeftGridButton +
        (gridTotalWidth / 2);
    int targetGridMiddlePoint = self.viewController.view.frame.size.width / 2;
    int xOffset = targetGridMiddlePoint - currentGridMiddlePoint;
    boardParameters.xOffsetForFirstLeftGridButton += xOffset;
    
    int gridTotalHeight = cellSizePlusSpace * (boardParameters.gridSize + 1);
    currentGridMiddlePoint = gridTotalHeight / 2;
    targetGridMiddlePoint = (self.viewController.GridContainerView.frame.size.height - 12) / 2;
    int yOffset = targetGridMiddlePoint - currentGridMiddlePoint;
    boardParameters.yOffsetForFirstTopGridButton += yOffset;
    
    return boardParameters;
}

- (void)initMovesCount
{
    self.movesCount = 0;
    [self updateMovesCountLabel];
}

- (void)updateMovesCountLabel
{
    self.viewController.MovesLabel.text = [NSString stringWithFormat:@"%ld", (long)self.movesCount];
}

- (void)startTimer
{
    self.timerPaused = false;
    self.timeInterval = 0;
    self.startTime = [NSDate date];
    self.stopWatchTimer = [NSTimer
                           scheduledTimerWithTimeInterval:1.0
                           target:self
                           selector:@selector(updateTimer)
                           userInfo:nil
                           repeats:YES];
    [self updateTimer];
}

- (void)updateTimer
{
    if (self.timerPaused)
        return;
    
    // Max time capped at 59:59
    int MAXTIME = 59*60 + 59;
    
    self.timeInterval += 1;
    
    // Check for max time
    if (self.timeInterval > MAXTIME)
    {
        self.timeInterval = MAXTIME;
    }
    
    NSDate *timerDate = [NSDate dateWithTimeIntervalSince1970:self.timeInterval];
    
    // Create date formatter
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc ] init];
    [dateFormatter setDateFormat:@"mm:ss"];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0.0]];
    
    // Format the elapsed time
    NSString *timeString = [dateFormatter stringFromDate:timerDate];
    
    // Trim off extra 0 at start if necessary
    NSString *firstChar = [timeString substringWithRange:NSMakeRange(0, 1)];
    if ([firstChar isEqualToString:@"0"])
    {
        timeString = [timeString substringFromIndex:1];
    }
    
    self.viewController.TimerLabel.text = timeString;
}

- (void)pauseTimer
{
    self.timerPaused = true;
}

- (void)resumeTimer
{
    self.timerPaused = false;
}

- (NSArray*)getColorButtons
{
    return [NSArray arrayWithObjects:self.viewController.whiteButton,self.viewController.blueButton,self.viewController.redButton, self.viewController.yellowButton, nil];
}

- (void)OnColorButtonPressed:(id)sender
{
    NSArray* buttons = [self getColorButtons];
    
    for (UIButton* button in buttons)
    {
        if (button == sender)
        {
            if (button == self.viewController.whiteButton)
            {
                if (!button.selected)
                {
                    self.selectedColor = 0;
                    UIImage *btnImage = [UIImage imageNamed:@"WhiteSelected.png"];
                    [button setImage:btnImage forState:UIControlStateNormal];
                    
                    // Play sound:
                    [[SoundManager sharedManager] playSound:@"whiteSelect.mp3" looping:NO];
                }
            }
            else if (button == self.viewController.blueButton)
            {
                if (!button.selected)
                {
                    self.selectedColor = 1;
                    UIImage *btnImage = [UIImage imageNamed:@"BlueSelected.png"];
                    [button setImage:btnImage forState:UIControlStateNormal];
                    
                    // Play sound:
                    [[SoundManager sharedManager] playSound:@"blueSelect.mp3" looping:NO];
                }
            }
            else if (button == self.viewController.redButton)
            {
                if (!button.selected)
                {
                    self.selectedColor = 2;
                    UIImage *btnImage = [UIImage imageNamed:@"RedSelected.png"];
                    [button setImage:btnImage forState:UIControlStateNormal];
                    
                    // Play sound:
                    [[SoundManager sharedManager] playSound:@"redSelect.mp3" looping:NO];
                }
            }
            else if (button == self.viewController.yellowButton)
            {
                if (!button.selected)
                {
                    self.selectedColor = 3;
                    UIImage *btnImage = [UIImage imageNamed:@"YellowSelected.png"];
                    [button setImage:btnImage forState:UIControlStateNormal];
                    
                    // Play sound:
                    [[SoundManager sharedManager] playSound:@"yellowSelect.mp3" looping:NO];
                }
            }
            
            button.selected = YES;
        }
        else
        {
            [self deselectColorButton:button];
        }
    }
}

-(void)deselectColorButton:(UIButton *)button
{
    button.selected = NO;
    
    if (button == self.viewController.whiteButton)
    {
        UIImage *btnImage = [UIImage imageNamed:@"White.png"];
        [button setImage:btnImage forState:UIControlStateNormal];
    }
    if (button == self.viewController.blueButton)
    {
        UIImage *btnImage = [UIImage imageNamed:@"Blue.png"];
        [button setImage:btnImage forState:UIControlStateNormal];
    }
    else if (button == self.viewController.redButton)
    {
        UIImage *btnImage = [UIImage imageNamed:@"Red.png"];
        [button setImage:btnImage forState:UIControlStateNormal];
    }
    else if (button == self.viewController.yellowButton)
    {
        UIImage *btnImage = [UIImage imageNamed:@"Yellow.png"];
        [button setImage:btnImage forState:UIControlStateNormal];
    }
}

-(void)DoVictory
{
    // Play sound
    [[SoundManager sharedManager] playSound:@"levelFinish.mp3" looping:NO];
    
    // Stop the timer
    [self.stopWatchTimer invalidate];
    
    int stars = 0;
    if (![LevelsManager IsRandomLevel:self.worldId levelId:self.levelId])
    {
        // Store level complete progress
        stars = [self storeLevelCompleteProgress];
    }
    
    // Show dialog after delay
    void (^showDialog)(void) = ^(void)
    {
        [self showVictoryDialog:stars];
    };
    [CommonUtils runBlockAfterDelay:0.2 block:showDialog];
    
    // Instrument
    NSString *levelString = [UserData getLevelString:self.worldId levelId:self.levelId];
    if (![LevelsManager IsRandomLevel:self.worldId levelId:self.levelId])
    {
        levelString = [UserData getLevelString:self.worldId levelId:self.levelId];
    }
    
    NSString *name = [@"Complete level " stringByAppendingString:levelString];
    NSString *moveCount = [NSString stringWithFormat:@"%ld moves", (long)self.movesCount];
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    NSDate *timerDate = [NSDate dateWithTimeIntervalSince1970:self.timeInterval];
    NSString *timeInSeconds = [NSString stringWithFormat:@"%d seconds", (int)[timerDate timeIntervalSince1970]];
    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:name
                                                          action:timeInSeconds
                                                           label:moveCount
                                                           value:[NSNumber numberWithInt:stars]] build]];
}

-(void)showVictoryDialog:(int)stars
{
    FullLevelId *nextLevelId = [self getNextLevelId];
    
    if (nextLevelId.worldId > 11)
    {
        [self showLastLevelVictoryDialog:stars];
    }
    else
    {
        [self showNormalVictoryDialog:stars];
    }
}

-(void)showLastLevelVictoryDialog:(int)stars
{
    NSString *titleMessage = @"Level Complete!";
    NSString *congratMessage = [CommonUtils GetRandomWinMessage:stars];
    NSString *tipMessage = @"\n\nYou have completed the game!";
    NSString *victoryMessage = [NSString stringWithFormat:@"%@ %@",
                                congratMessage,
                                tipMessage];
    
    // Set up alert view
    SCLAlertView *alert = [[SCLAlertView alloc] init];
    alert.hideAnimationType = SlideOutToBottom;
    
    [alert alertIsDismissed:^{
        FullLevelId *nextLevelId = [self getNextLevelId];
        
        // This is the last world. Go to credits
        UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
        CreditsViewController *creditsView = (CreditsViewController*)[storyBoard instantiateViewControllerWithIdentifier:@"creditsScreen"];
        [self.viewController.navigationController pushViewController:creditsView animated:YES];
        
        // Fix backstack
        UIViewController *firstView = (UIViewController*)[self.viewController.navigationController.viewControllers objectAtIndex:0];
        NSArray *newStack = [[NSArray alloc] initWithObjects:firstView,creditsView,nil];
        self.viewController.navigationController.viewControllers = newStack;
    }];
    
    UIImage *starsImage = [self getStarsImageForWinDialog:stars];
    UIColor *viewColor = UIColorFromHEX(0x22B573);
    [alert showCustom:self.viewController image:starsImage color:viewColor title:titleMessage subTitle:victoryMessage closeButtonTitle:@"View Credits" duration:0.0f];
}

-(UIImage*)getStarsImageForWinDialog:(int)stars
{
    UIImage *starsImage;
    if (stars == 3)
    {
        starsImage = [UIImage imageNamed:@"_3stars@2x.png"];
    }
    else if (stars == 2)
    {
        starsImage = [UIImage imageNamed:@"_2stars@2x.png"];
    }
    else
    {
        starsImage = [UIImage imageNamed:@"_1stars@2x.png"];
    }
    return starsImage;
}

-(void)showNormalVictoryDialog:(int)stars
{
    NSString *titleMessage = @"Level Complete!";
    NSString *congratMessage = [CommonUtils GetRandomWinMessage:stars];
    NSString *tipMessage = [CommonUtils GetRandomTip];
    NSString *victoryMessage = [NSString stringWithFormat:@"%@ %@",
                                congratMessage,
                                tipMessage];
    
    // Set up alert view
    SCLAlertView *alert = [[SCLAlertView alloc] init];
    alert.hideAnimationType = SlideOutToBottom;
    
    [alert addButton:@"Next Level" actionBlock:^(void)
     {
         [self nextLevelButtonPressed];
     }];
    
    [alert addButton:@"Retry Level" actionBlock:^(void)
     {
         [self retryLevelButtonPressed:stars];
     }];
    
    UIImage *starsImage = [self getStarsImageForWinDialog:stars];
    
    UIColor *viewColor = UIColorFromHEX(0x22B573);
    [alert showCustom:self.viewController image:starsImage color:viewColor title:titleMessage subTitle:victoryMessage closeButtonTitle:nil duration:0.0f];
}

-(int)storeLevelCompleteProgress
{
    int stars = [LevelsManager CalculateStarsEarned:_boardParameters.gridSize time:self.timeInterval worldId:self.worldId levelId:self.levelId];
    
    if (stars > 3)
        stars = 3;
    
    [[UserData sharedUserData] storeLevelComplete:self.worldId levelId:self.levelId stars:stars];
    
    return stars;
}

- (void)OnGridButtonPressed:(id)sender
{
    // Update moves count
    NSNumber* currentColorForButton = [_userColorBoard getCurrentColorForButton:sender];
    
    if ([currentColorForButton intValue] == self.selectedColor)
    {
        // Do nothing if color didn't change
        return;
    }
    
    // Handle selecting color
    int selectedColor = (int)self.selectedColor;
    [_userColorBoard pressGridButtonWithColor:sender :selectedColor doAnimate:true doSound:true];
    
    [self OnUserActionTaken];
}

- (IBAction)splitterButtonPressed:(id)sender
{
    [self.userColorBoard splitterButtonPressed:sender];
}

- (IBAction)connectorCellPressed:(id)sender
{
    [self.userColorBoard connectorCellPressed:sender];
}

- (IBAction)zonerCellPressed:(id)sender
{
    [self.userColorBoard zonerCellPressed:sender];
}

- (IBAction)converterButtonPressed:(id)sender
{
    [self.userColorBoard converterButtonPressed:sender];
}

- (IBAction)shifterCellPressed:(id)sender
{
    [self.userColorBoard shifterCellPressed:sender];
}

-(void)OnUserActionTaken
{
    // Update moves count and check for victory
    [self incrementMoveCount];
    [self checkAndDoVictory];
}

-(void)incrementMoveCount
{
    // Cap moves count at 99
    if (self.movesCount < 99)
    {
        self.movesCount++;
        [self updateMovesCountLabel];
    }
}

-(void)resetActionBar
{
    NSArray* buttons = [self getColorButtons];
    
    for (UIButton* button in buttons)
    {
        [self deselectColorButton:button];
    }
    
    self.selectedColor = 0;
}

-(void)checkAndDoVictory
{
    if ([self CheckVictory] == true)
    {
        [self DoVictory];
    }
}

-(BOOL)CheckVictory
{
    for (int i=0; i < _goalBoard.colorCellSections.count; i++)
    {
        NSMutableArray *goalRow = [_goalBoard.colorCellSections objectAtIndex:i];
        NSMutableArray *userBoardRow = [_userColorBoard.colorCellSections objectAtIndex:i];
        
        for (int j=0; j < goalRow.count; j++)
        {
            ColorCell *goalColorCell = [goalRow objectAtIndex:j];
            ColorCell *userColorCell = [userBoardRow objectAtIndex:j];
            
            if (![ColorCell isGoalTargetCell:goalColorCell.cellType])
            {
                continue;
            }
            
            if (goalColorCell.currentColor != userColorCell.currentColor)
            {
                return false;
            }
        }
    }
    
    return true;
}

- (void)nextLevelButtonPressed
{
    bool gamePurchased = [[UserData sharedUserData] getGamePurchased];
    
    if (!gamePurchased)
    {
        self.adPendingState = PendingNextGame;
        
        // Present Ad
        [self presentInterlude];
    }
    else
    {
        [self NextLevel];
    }
}

- (void)resetBoardAndStartLevel
{
    [self removeExistingBoard];
    [self resetActionBar];
    
    // Re-generate board cells
    [self loadBoardCellTypes];
    
    [self getNextLevelParameters:self.worldId levelId:self.levelId];
    self.viewController.worldId = self.worldId;
    self.viewController.levelId = self.levelId;
    
    [self.viewController createGameManagerAndStartNewGame];
}

- (void)retryLevelButtonPressed:(int)stars
{
    [self resetBoardAndStartLevel];
    
    // Instrument
    NSString *levelString = [UserData getLevelString:self.worldId levelId:self.levelId];
    
    NSString *name = [@"Retry level " stringByAppendingString:levelString];
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:name
                                                          action:nil
                                                           label:nil
                                                           value:[NSNumber numberWithInt:stars]] build]];
}

- (void)NextLevel
{
    FullLevelId *nextLevelId = [self getNextLevelId];
    
    bool isLevelLocked = [[UserData sharedUserData] getIsLevelLocked:nextLevelId.worldId levelId:nextLevelId.levelId];
    
    if (!isLevelLocked)
    {
        // Level not locked
        self.worldId = nextLevelId.worldId;
        self.levelId = nextLevelId.levelId;
        
        [self resetBoardAndStartLevel];
    }
    else
    {
        // Level is locked
        [CommonUtils ShowLockedLevelMessage:nextLevelId.worldId levelId:nextLevelId.levelId isFromPreviousLevel:true viewController:self.viewController triggerBackOnDismiss:true];
    }
}

- (FullLevelId*)getNextLevelId
{
    if (self.worldId == 0 && self.levelId == 0)
    {
        // This is a randomly generated board, no need to change levelId
        return [[FullLevelId alloc] init:self.worldId levelId:self.levelId];
    }
    
    if (self.levelId < [LevelsManager GetLevelCountForWorld:self.worldId])
    {
        return [[FullLevelId alloc] init:self.worldId levelId:self.levelId+1];
    }
    else
    {
        // Transition to next world
        return [[FullLevelId alloc] init:self.worldId+1 levelId:1];
    }
}

- (void)getNextLevelParameters:(int)worldId levelId:(int)levelId
{
    int gameSize = [LevelsManager GetGameSizeForWorld:worldId levelId:levelId];
    _boardParameters = [self getBoardParametersForSize:gameSize];
}

- (void)removeExistingBoard
{
    [_userColorBoard removeExistingBoard];
    [_goalBoard removeExistingBoard];
}

- (void)clearExistingGame
{
    // Stop the timer
    [self.stopWatchTimer invalidate];
    
    // Remove game board state
    [self removeExistingBoard];
}

- (void)OnShowHelpMenu:(id)sender
{
    [[SoundManager sharedManager] playSound:@"helpButtonSFX.mp3" looping:NO];
    
    // Hide navigation bar
    [self.viewController.navigationController setNavigationBarHidden:YES animated:false];
    
    self.helpScreenViewController = [[HelpScreenViewController alloc] initWithParameters:self.worldId];
    
    [self.viewController addChildViewController:self.helpScreenViewController];
    self.helpScreenViewController.view.frame = CGRectMake(0,0,self.viewController.view.frame.size.width, self.viewController.view.frame.size.height);
    [self.viewController.view addSubview:self.helpScreenViewController.view];
    [self.helpScreenViewController didMoveToParentViewController: self.viewController];
    
    // Pause game
    [self pauseTimer];
}


- (void)CloseHelpMenu
{
    [[SoundManager sharedManager] playSound:@"helpButtonSFX.mp3" looping:NO];
    
    [self.helpScreenViewController willMoveToParentViewController:nil];
    [self.helpScreenViewController.view removeFromSuperview];
    [self.helpScreenViewController removeFromParentViewController];
    
    // Show navigation bar
    [self.viewController.navigationController setNavigationBarHidden:NO animated:false];
    
    // Resume game
    [self resumeTimer];
}

#pragma mark - Ads


- (void)cycleInterstitial
{
    self.interstitial = [[GADInterstitial alloc] initWithAdUnitID:@"ca-app-pub-7449410278277334/1916784201"];
    self.interstitial.delegate = self;
    
    GADRequest *request = [GADRequest request];
    request.testDevices = @[@"c064e2cc00e4cf55a71f55b0edffc535"];
    [self.interstitial loadRequest:request];
}

- (void)presentInterlude
{
    if ([CommonUtils shouldShowAd] && [self.interstitial isReady])
    {
        [self.interstitial presentFromRootViewController:self.viewController];
    }
    else
    {
        [self resumeGameAfterAd];
    }
}

- (void)interstitialDidDismissScreen:(GADInterstitial*)interstitial
{
    [self resumeGameAfterAd];
}

- (void)resumeGameAfterAd
{
    [self cycleInterstitial];
    if (self.adPendingState == PendingNextGame)
    {
        [self NextLevel];
    }
}

#pragma mark -

- (void)navigatedBack
{
    // Game considered abandoned if move count is more than 0
    if (self.movesCount > 0)
    {
        // Instrument
        NSMutableString *levelString = [UserData getLevelString:self.worldId levelId:self.levelId];
        NSString *name = [@"Abandoned level " stringByAppendingString:levelString];
        NSString *moveCount = [NSString stringWithFormat:@"%ld moves", (long)self.movesCount];
        id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
        NSDate *timerDate = [NSDate dateWithTimeIntervalSince1970:self.timeInterval];
        NSString *timeInSeconds = [NSString stringWithFormat:@"%d seconds", (int)[timerDate timeIntervalSince1970]];
        [tracker send:[[GAIDictionaryBuilder createEventWithCategory:name
                                                              action:timeInSeconds
                                                               label:moveCount
                                                               value:@1] build]];
    }
}

- (void)OnTapTopContainer
{
    // NOOP in base class
}

@end
