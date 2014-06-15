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

@interface MainGameViewController ()

@property NSInteger selectedColor;
@property NSTimer *stopWatchTimer;
@property NSDate *startTime;
@property NSInteger movesCount;
@property BoardParameters boardParameters;
@property BoardCells *boardCells;
@property GoalBoard *goalBoard;
@property UserColorBoard *userColorBoard;
@property int worldId;
@property int levelId;
@property NSTimeInterval timeInterval;
@end

@implementation MainGameViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    // Start new game
    [self startNewGame];
}

- (void)SetParametersForNewGame:(int)size worldId:(int)worldId levelId:(int)levelId
{
    _boardParameters = [self getBoardParametersForSize:size];
    _worldId = worldId;
    _levelId = levelId;
}

- (void)startNewGame
{
    // Render new game board
    [self renderNewBoard];
    
    // Generate new random goal state
    [_goalBoard generateNewGoalBoardStates:self.worldId levelId:self.levelId];
    
    // Start the timer
    [self startTimer];
    
    // Init moves count
    [self initMovesCount];
}

// Render new board to view given current parameters
- (void)renderNewBoard
{
    // Init board cell types
    [self loadBoardCellTypes];
    
    // Init goal color cells
    _goalBoard = [[GoalBoard alloc] initWithParameters:(_boardParameters) containerView:_GoalContainerView boardCells:_boardCells];

    // Init color cell sections
    _userColorBoard = [[UserColorBoard alloc] initWithParameters:(_boardParameters) containerView:_GridContainerView viewController:self boardCells:_boardCells];
    
    // Set the level name
    if ([LevelsManager IsRandomLevel:self.worldId levelId:self.levelId])
    {
        [self.LevelNumberLabel removeFromSuperview];
        [self.LevelLabel removeFromSuperview];
    }
    else
    {
        NSMutableString *levelString = [UserData getLevelString:self.worldId levelId:self.levelId];
        self.LevelNumberLabel.text = levelString;
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
            boardParameters.yOffsetForFirstTopGridButton= 15;
            boardParameters.xOffsetForFirstLeftGridButton = 29;
            boardParameters.emptyPaddingInGridButton = 13;
            boardParameters.goalColorCellSize = 40;
            boardParameters.goalColorCellSpacing = 8;
            break;
        case 4:
            boardParameters.colorCellSize = 40;
            boardParameters.colorCellSpacing = 10;
            boardParameters.yOffsetForFirstTopGridButton= 6;
            boardParameters.xOffsetForFirstLeftGridButton = 27;
            boardParameters.emptyPaddingInGridButton = 11;
            boardParameters.goalColorCellSize = 32;
            boardParameters.goalColorCellSpacing = 6;
            break;
        case 5:
            boardParameters.colorCellSize = 35;
            boardParameters.colorCellSpacing = 8;
            boardParameters.yOffsetForFirstTopGridButton= 0;
            boardParameters.xOffsetForFirstLeftGridButton = 20;
            boardParameters.emptyPaddingInGridButton = 9;
            boardParameters.goalColorCellSize = 27;
            boardParameters.goalColorCellSpacing = 4;
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
    self.MovesLabel.text = [NSString stringWithFormat:@"%ld", (long)self.movesCount];
}

- (void)startTimer
{
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
    // Max time capped at 59:59
    int MAXTIME = 59*60 + 59;
    
    // Create elapsed time
    NSDate *currentTime = [NSDate date];
    self.timeInterval = [currentTime timeIntervalSinceDate:self.startTime];
    
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
    
    self.TimerLabel.text = timeString;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)ColorButtonPressed:(id)sender
{
    NSArray* buttons = [NSArray arrayWithObjects:_whiteButton,_blueButton,_redButton, _yellowButton, nil];
    
    for (UIButton* button in buttons)
    {
        if (button == sender){
            button.selected = YES;
            
            if (button == _whiteButton)
            {
                self.selectedColor = 0;
                UIImage *btnImage = [UIImage imageNamed:@"WhiteSelected.png"];
                [button setImage:btnImage forState:UIControlStateNormal];
            }
            if (button == _blueButton)
            {
                self.selectedColor = 1;
                UIImage *btnImage = [UIImage imageNamed:@"BlueSelected.png"];
                [button setImage:btnImage forState:UIControlStateNormal];
            }
            else if (button == _redButton)
            {
                self.selectedColor = 2;
                UIImage *btnImage = [UIImage imageNamed:@"RedSelected.png"];
                [button setImage:btnImage forState:UIControlStateNormal];
            }
            else if (button == _yellowButton)
            {
                self.selectedColor = 3;
                UIImage *btnImage = [UIImage imageNamed:@"YellowSelected.png"];
                [button setImage:btnImage forState:UIControlStateNormal];
            }
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
    
    if (button == _whiteButton)
    {
        UIImage *btnImage = [UIImage imageNamed:@"White.png"];
        [button setImage:btnImage forState:UIControlStateNormal];
    }
    if (button == _blueButton)
    {
        UIImage *btnImage = [UIImage imageNamed:@"Blue.png"];
        [button setImage:btnImage forState:UIControlStateNormal];
    }
    else if (button == _redButton)
    {
        UIImage *btnImage = [UIImage imageNamed:@"Red.png"];
        [button setImage:btnImage forState:UIControlStateNormal];
    }
    else if (button == _yellowButton)
    {
        UIImage *btnImage = [UIImage imageNamed:@"Yellow.png"];
        [button setImage:btnImage forState:UIControlStateNormal];
    }
}

-(void)DoVictory
{
    // Stop the timer
    [self.stopWatchTimer invalidate];
    
    // Store level complete progress
    int stars = [self storeLevelCompleteProgress];
    
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
    NSString *rainbowString = stars > 3 ? @" rainbow" : @"";
    if (stars > 3)
        stars = 3;
    
    NSString *victoryMessage = [[[[[[@"Nicely done! \n\nMoves: " stringByAppendingString:self.MovesLabel.text] stringByAppendingString:@"\nTime taken: "]
        stringByAppendingString:self.TimerLabel.text]
        stringByAppendingString:[NSString stringWithFormat:@"\n\nYou have earned %d", stars]]
        stringByAppendingString:rainbowString]
        stringByAppendingString:@" stars!"];
    UIAlertView *alert = [[UIAlertView alloc]
        initWithTitle:titleMessage
        message:victoryMessage
        delegate: self cancelButtonTitle:@"Cancel"
        otherButtonTitles:nil];
    [alert addButtonWithTitle:@"Next Level"];
    [alert show];
}

-(int)storeLevelCompleteProgress
{
    int stars = [LevelsManager CalculateStarsEarned:_boardParameters.gridSize time:self.timeInterval];
    
    [[UserData sharedUserData] storeLevelComplete:self.worldId levelId:self.levelId stars:stars];
    
    return stars;
}

- (IBAction)GridButtonPressed:(id)sender
{
    // Update moves count
    NSNumber* currentColorForButton = [_userColorBoard getCurrentColorForButton:sender];

    if ([currentColorForButton intValue] != self.selectedColor)
    {
        // Update moves count only if color changed
        // Cap moves count at 99
        if (self.movesCount < 99)
        {
            self.movesCount++;
            [self updateMovesCountLabel];
        }
    }
    
    // Handle selecting color
    int selectedColor = (int)self.selectedColor;
    [_userColorBoard pressGridButtonWithColor:sender :selectedColor];
    
    if ([self CheckVictory] == true)
    {
        [self DoVictory];
    }
}

-(void)resetActionBar
{
    NSArray* buttons = [NSArray arrayWithObjects:_whiteButton,_blueButton,_redButton, _yellowButton, nil];
    
    for (UIButton* button in buttons)
    {
        [self deselectColorButton:button];
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
            
            if (goalColorCell.currentColor != userColorCell.currentColor)
            {
                return false;
            }
        }
    }
    
    return true;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        [self NextLevel];
    }
}

- (void)NextLevel
{
    [self removeExistingBoard];
    [self resetActionBar];

    // Re-generate board cells
    [self loadBoardCellTypes];
    
    [self getNextLevelParameters];
    
    [self startNewGame];
}

- (void)getNextLevelParameters
{
    if (self.worldId == 0 && self.levelId == 0)
    {
        // This is a randomly generated board, no need to change levelId
        return;
    }
    
    if (self.levelId < [LevelsManager GetLevelCountForWorld:self.worldId])
    {
        self.levelId++;
    }
    else
    {
        // TODO: transition to next world
    }
    
    int gameSize = [LevelsManager GetGameSizeForWorld:self.worldId levelId:self.levelId];
    _boardParameters = [self getBoardParametersForSize:gameSize];
}

- (void)removeExistingBoard
{
    [_userColorBoard removeExistingBoard];
    [_goalBoard removeExistingGoalColorCells];
    [_goalBoard removeExistingGoalColorsState];
}

- (void)clearExistingGame
{
    // Stop the timer
    [self.stopWatchTimer invalidate];
    
    // Remove game board state
    [self removeExistingBoard];
}

@end
