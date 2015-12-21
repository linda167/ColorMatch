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

@interface MainGameManager ()

@property NSTimer *stopWatchTimer;
@property NSDate *startTime;
@property NSInteger movesCount;
@property GoalBoard *goalBoard;
@property int levelId;
@property NSTimeInterval timeInterval;
@property HelpScreenViewController *helpScreenViewController;
@property bool timerPaused;
@property ADInterstitialAd *interstitial;
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
    
    switch (size)
    {
        case 3:
            boardParameters.colorCellSize = 50;
            boardParameters.colorCellSpacing = 14;
            boardParameters.yOffsetForFirstTopGridButton= 4;
            boardParameters.xOffsetForFirstLeftGridButton = 31;
            boardParameters.emptyPaddingInGridButton = 13;
            boardParameters.goalColorCellSize = 46;
            boardParameters.goalColorCellSpacing = 8;
            boardParameters.xAdjustmentForColorCells = -4;
            boardParameters.reflectorArrowCellSize = 49;
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
            boardParameters.transporterArrowSize = 43;
            boardParameters.transporterArrowDownXAdjustment = 4;
            boardParameters.transporterArrowDownYAdjustment = -16;
            boardParameters.transporterArrowDownYAdjustment2 = 7;
            boardParameters.transporterArrowRightXAdjustment = 7;
            boardParameters.transporterArrowRightXAdjustment2 = -16;
            boardParameters.transporterArrowRightYAdjustment = 4;
            break;
        case 4:
            boardParameters.colorCellSize = 40;
            boardParameters.colorCellSpacing = 10;
            boardParameters.yOffsetForFirstTopGridButton= 6;
            boardParameters.xOffsetForFirstLeftGridButton = 27;
            boardParameters.emptyPaddingInGridButton = 11;
            boardParameters.goalColorCellSize = 34;
            boardParameters.goalColorCellSpacing = 6;
            boardParameters.xAdjustmentForColorCells = -6;
            boardParameters.reflectorArrowCellSize = 39;
            boardParameters.reflectorLeftToDownArrowXAdjustment = 2;
            boardParameters.reflectorLeftToDownArrowYAdjustment = 8;
            boardParameters.reflectorTopToRightArrowXAdjustment = 8;
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
            boardParameters.transporterArrowSize = 35;
            boardParameters.transporterArrowDownXAdjustment = 3;
            boardParameters.transporterArrowDownYAdjustment = -14;
            boardParameters.transporterArrowDownYAdjustment2 = 7;
            boardParameters.transporterArrowRightXAdjustment = 7;
            boardParameters.transporterArrowRightXAdjustment2 = -16;
            boardParameters.transporterArrowRightYAdjustment = 3;
            break;
        case 5:
            boardParameters.colorCellSize = 35;
            boardParameters.colorCellSpacing = 8;
            boardParameters.yOffsetForFirstTopGridButton= 0;
            boardParameters.xOffsetForFirstLeftGridButton = 20;
            boardParameters.emptyPaddingInGridButton = 9;
            boardParameters.goalColorCellSize = 27;
            boardParameters.goalColorCellSpacing = 4;
            boardParameters.xAdjustmentForColorCells = 0;
            boardParameters.reflectorArrowCellSize = 35;
            boardParameters.reflectorLeftToDownArrowXAdjustment = 1;
            boardParameters.reflectorLeftToDownArrowYAdjustment = 5;
            boardParameters.reflectorTopToRightArrowXAdjustment = 5;
            boardParameters.reflectorTopToRightArrowYAdjustment = 1;
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
            boardParameters.transporterArrowSize = 29;
            boardParameters.transporterArrowDownXAdjustment = 4;
            boardParameters.transporterArrowDownYAdjustment = -12;
            boardParameters.transporterArrowDownYAdjustment2 = 7;
            boardParameters.transporterArrowRightXAdjustment = 7;
            boardParameters.transporterArrowRightXAdjustment2 = -10;
            boardParameters.transporterArrowRightYAdjustment = 4;
            break;
        default:
            [NSException raise:@"Invalid input" format:@"Invalid board size"];
            break;
    }
    
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
    
    // Create the title string
    NSString *levelString = [[NSString alloc] init];
    if (![LevelsManager IsRandomLevel:self.worldId levelId:self.levelId])
    {
        levelString = [[UserData getLevelString:self.worldId levelId:self.levelId] stringByAppendingString:@" "];
    }
    NSString *titleMessage = [[@"Level "
                               stringByAppendingString:levelString]
                              stringByAppendingString:@"Complete: "];
    
    // Show victory message
    NSString *starsEarnedMessage = [self getStarsEarnedMessage:stars];
    NSString *victoryMessage = [[[[@"Nicely done! \n\nMoves: " stringByAppendingString:self.viewController.MovesLabel.text] stringByAppendingString:@"\nTime taken: "]
        stringByAppendingString:self.viewController.TimerLabel.text]
        stringByAppendingString:starsEarnedMessage];
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:titleMessage
                          message:victoryMessage
                          delegate: self cancelButtonTitle:@"Cancel"
                          otherButtonTitles:nil];
    [alert addButtonWithTitle:@"Next Level"];
    [alert show];
}

-(NSString*)getStarsEarnedMessage:(int)stars
{
    
    NSString *starsMessage;
    if (![LevelsManager IsRandomLevel:self.worldId levelId:self.levelId])
    {
        NSString *rainbowString = stars > 3 ? @" rainbow" : @"";
        if (stars > 3)
            stars = 3;
        
        starsMessage = [[[NSString stringWithFormat:@"\n\nYou have earned %d", stars]
                         stringByAppendingString:rainbowString ]
                        stringByAppendingString: stars > 1 ? @" stars!" : @" star!"];
    }
    else
    {
        starsMessage = @"";
    }
    
    return starsMessage;
}

-(int)storeLevelCompleteProgress
{
    int stars = [LevelsManager CalculateStarsEarned:_boardParameters.gridSize time:self.timeInterval worldId:self.worldId levelId:self.levelId];
    
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
            
            if ([ColorCell isGoalTargetCell:goalColorCell.cellType] && goalColorCell.currentColor != userColorCell.currentColor)
            {
                return false;
            }
        }
    }
    
    return true;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    bool gamePurchased = [[UserData sharedUserData] getGamePurchased];
    
    if (!gamePurchased)
    {
        if (buttonIndex == 0)
        {
            self.adPendingState = PendingCancel;
        }
        else
        {
            self.adPendingState = PendingNextGame;
        }
        
        // Present Ad
        [self presentInterlude];
    }
    else if (buttonIndex == 1)
    {
        [self NextLevel];
    }
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
        
        [self removeExistingBoard];
        [self resetActionBar];
        
        // Re-generate board cells
        [self loadBoardCellTypes];
        
        [self getNextLevelParameters:nextLevelId.worldId levelId:nextLevelId.levelId];
        
        [self StartNewGame];
    }
    else
    {
        // Level is locked
        [CommonUtils ShowLockedLevelMessage:nextLevelId.worldId levelId:nextLevelId.levelId isFromPreviousLevel:true];
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
        
        // TODO:Bug#26 Need to handle last world
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
    self.interstitial = [[ADInterstitialAd alloc] init];
}

- (void)presentInterlude
{
    if (self.interstitial.loaded)
    {
        [self.viewController PresentAd];
    }
    else
    {
        [self resumeGameAfterAd];
    }
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

@end
