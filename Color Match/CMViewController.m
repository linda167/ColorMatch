//
//  CMViewController.m
//  Color Match
//
//  Created by Linda Chen on 1/1/14.
//  Copyright (c) 2014 SunSpark Entertainment. All rights reserved.
//

#import "CMViewController.h"
#import "GridColorButton.h"

typedef struct BoardParameters
{
    int gridSize;
    int xOffsetForFirstColorCell;
    int yOffsetForFirstColorCell;
    int colorCellSize;
    int colorCellSpacing;
} BoardParameters;

@interface CMViewController ()

@property NSInteger selectedColor;
@property NSArray *allGridColorButtons;
@property NSArray *topGridColorButtons;
@property NSArray *leftGridColorButtons;
@property NSMutableArray *colorCellSections;
@property NSMutableArray *verticalLines;
@property NSMutableArray *horizontalLines;
@property NSMutableArray *goalCellSections;
@property NSMutableArray *goalTopColorsState;
@property NSMutableArray *goalLeftColorsState;
@property (strong, nonatomic) NSTimer *stopWatchTimer;
@property (strong, nonatomic) NSDate * startTime;
@property NSInteger movesCount;
@property BoardParameters boardParameters;
@end

@implementation CMViewController

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationPortrait + UIInterfaceOrientationPortraitUpsideDown;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.boardParameters = [self getBoardParametersForSize:3];

    // Init color bar buttons
    [self initGridColorButtons];
    
    // Init color cell sections
    [self initColorCells];
    
    // Init goal color cell sections
    NSArray *goalRow1 = [NSArray arrayWithObjects:_Goal00,_Goal01, _Goal02, nil];
    NSArray *goalRow2 = [NSArray arrayWithObjects:_Goal10,_Goal11, _Goal12, nil];
    NSArray *goalRow3 = [NSArray arrayWithObjects:_Goal20,_Goal21, _Goal22, nil];
    
    self.goalCellSections = [NSMutableArray arrayWithObjects:goalRow1, goalRow2, goalRow3, nil];
    
    // Init goal color bar states
    self.goalTopColorsState = [NSMutableArray arrayWithObjects:[NSNumber numberWithInt:0], [NSNumber numberWithInt:0], [NSNumber numberWithInt:0], nil];
    self.goalLeftColorsState = [NSMutableArray arrayWithObjects:[NSNumber numberWithInt:0], [NSNumber numberWithInt:0], [NSNumber numberWithInt:0], nil];
    
    // Generate goal board
    [self generateNewBoard];
    
    // Draw connecting lines
    [self DrawVerticalConnectingLines];
    [self DrawHorizontalConnectingLines];
    
    // Start the timer
    [self startTimer];
    
    // Init moves count
    [self initMovesCount];
}

-(BoardParameters)getBoardParametersForSize:(int)size
{
    struct BoardParameters boardParameters;
    
    // For now always return 3x3 parameters
    boardParameters.gridSize = 3;
    boardParameters.xOffsetForFirstColorCell = 93;
    boardParameters.yOffsetForFirstColorCell = 63;
    boardParameters.colorCellSize = 50;
    boardParameters.colorCellSpacing = 64;
    
    return boardParameters;
}

- (void)initColorCells
{
    int xOffset = _boardParameters.xOffsetForFirstColorCell;
    int yOffset = _boardParameters.yOffsetForFirstColorCell;

    self.colorCellSections = [[NSMutableArray alloc] init];
    
    for (int i=0; i<_boardParameters.gridSize; i++)
    {
        NSMutableArray *row = [[NSMutableArray alloc] init];
        for (int j=0; j<_boardParameters.gridSize; j++)
        {
            UIImageView *cellBlock = [[UIImageView alloc] initWithFrame:CGRectMake(xOffset, yOffset, _boardParameters.colorCellSize, _boardParameters.colorCellSize)];
            cellBlock.image=[UIImage imageNamed:@"BlockWhite.png"];
            [_GridContainerView addSubview:cellBlock];
            
            [row addObject:cellBlock];
            xOffset += _boardParameters.colorCellSpacing;
        }

        [self.colorCellSections addObject:row];
        yOffset += _boardParameters.colorCellSpacing;
        xOffset = _boardParameters.xOffsetForFirstColorCell;
    }
}

- (void)initGridColorButtons
{
    self.allGridColorButtons = [NSArray arrayWithObjects:
        [[GridColorButton alloc] initWithButton:_Top1Button],
        [[GridColorButton alloc] initWithButton:_Top2Button],
        [[GridColorButton alloc] initWithButton:_Top3Button],
        [[GridColorButton alloc] initWithButton:_Left1Button],
        [[GridColorButton alloc] initWithButton:_Left2Button],
        [[GridColorButton alloc] initWithButton:_Left3Button],
        nil];

    self.topGridColorButtons = [_allGridColorButtons subarrayWithRange:NSMakeRange(0, _allGridColorButtons.count / 2)];
    self.leftGridColorButtons = [_allGridColorButtons subarrayWithRange:NSMakeRange(_allGridColorButtons.count / 2, _allGridColorButtons.count / 2)];
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
    // Create elapsed time
    NSDate *currentTime = [NSDate date];
    NSTimeInterval timeInterval = [currentTime timeIntervalSinceDate:self.startTime];
    NSDate *timerDate = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    
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

- (void)generateNewBoard
{
    do
    {
        // Randomly generate goal color bar
        [self RandomGenGoalStates];
    }
    while ([self CheckGoalSufficientDifficulty] == false);
    
    // Update goal cells
    [self UpdateColorCells: self.goalCellSections :self.goalTopColorsState :self.goalLeftColorsState];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)ColorButtonPressed:(id)sender {
    NSArray* buttons = [NSArray arrayWithObjects:_whiteButton,_blueButton,_redButton, _yellowButton, nil];
    
    for (UIButton* button in buttons){
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

- (IBAction)GridButtonPressed:(id)sender
{
    // Update moves count
    for (GridColorButton* gridColorButton in _allGridColorButtons)
    {
        if (gridColorButton.button == sender)
        {
            if ([gridColorButton.color intValue] != self.selectedColor)
            {
                // Update moves count only if color changed
                self.movesCount++;
                [self updateMovesCountLabel];
            }
            break;
        }
    }
    
    // Handle selecting color
    int selectedColor = (int)self.selectedColor;
    [self PressGridButtonWithColor:sender :selectedColor];
    
    if ([self CheckVictory] == true)
    {
        [self DoVictory];
    }
}

-(void)DoVictory
{
    // Stop the timer
    [self.stopWatchTimer invalidate];
    
    // Show victory message
    NSString *victoryMessage = [[[@"Nicely done! \n\nMoves: " stringByAppendingString:self.MovesLabel.text] stringByAppendingString:@"\nTime taken: "]
        stringByAppendingString:self.TimerLabel.text];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Level Complete"                                                        message:victoryMessage
        delegate: self cancelButtonTitle:@"Cancel"
        otherButtonTitles:nil];
    [alert addButtonWithTitle:@"Next Level"];
    [alert show];
}

-(void)PressGridButtonWithColor:(UIButton *)button :(int)selectedColor
{
    // Update color state on top and left bar
    NSNumber* wrappedSelectedColor = [NSNumber numberWithInt:selectedColor];
    
    // Update grid color button state
    GridColorButton* gridColorButtonClicked;
    for (GridColorButton* gridColorButton in _allGridColorButtons)
    {
        if (gridColorButton.button == button)
        {
            [gridColorButton setColor:wrappedSelectedColor];
            gridColorButtonClicked = gridColorButton;
            break;
        }
    }
    
    NSInteger topIndex = [self.topGridColorButtons indexOfObject:gridColorButtonClicked];
    UIView *lineToUpdate;
    if (topIndex != NSNotFound)
    {
        lineToUpdate = [self.verticalLines objectAtIndex:topIndex];
    }
    else
    {
        NSInteger leftIndex = [self.leftGridColorButtons indexOfObject:gridColorButtonClicked];
        lineToUpdate = [self.horizontalLines objectAtIndex:leftIndex];
    }
    
    // Update filled color on the button being clicked, and the color of the connecting line
    if (selectedColor == 0)
    {
        lineToUpdate.backgroundColor = [self GetGrayColor];
    }
    else if (selectedColor == 1)
    {
        lineToUpdate.backgroundColor = [self GetBlueColor];
    }
    else if (selectedColor == 2)
    {
        lineToUpdate.backgroundColor = [self GetRedColor];
    }
    else if (selectedColor == 3)
    {
        lineToUpdate.backgroundColor = [self GetYellowColor];
    }
    
    // Get current color states
    NSMutableArray *currentTopColorState = [[NSMutableArray alloc] init];
    for (GridColorButton* gridColorButton in _topGridColorButtons)
    {
        [currentTopColorState addObject:gridColorButton.color];
    }
    
    NSMutableArray *currentLeftColorState = [[NSMutableArray alloc]  init];
    for (GridColorButton* gridColorButton in _leftGridColorButtons)
    {
        [currentLeftColorState addObject:gridColorButton.color];
    }
    
    // Trigger update of color cells
    [self UpdateColorCells: self.colorCellSections :currentTopColorState :currentLeftColorState];
}

-(void)RandomGenGoalStates
{
    int topCount = (int)[self.goalTopColorsState count];
    for (int i=0; i<topCount; i++)
    {
        int random = arc4random()%4;
        NSNumber* wrappedNumber = [NSNumber numberWithInt:random];
        [self.goalTopColorsState replaceObjectAtIndex:i withObject:wrappedNumber];
    }
    
    int leftCount = (int)[self.goalLeftColorsState count];
    for (int i=0; i<leftCount; i++)
    {
        int random = arc4random()%4;
        NSNumber* wrappedNumber = [NSNumber numberWithInt:random];
        [self.goalLeftColorsState replaceObjectAtIndex:i withObject:wrappedNumber];
    }
}

-(BOOL)CheckGoalSufficientDifficulty
{
    // Check that we have all non-white colors represented in the toggle states
    bool has1 = false;
    bool has2 = false;
    bool has3 = false;
    
    // Keep track of white cells
    bool hasWhiteOnTop = false;
    bool hasWhiteOnLeft = false;
    
    for (NSNumber* number in self.goalTopColorsState){
        int num = [number intValue];
        if (num == 0)
        {
            hasWhiteOnTop = true;
        }
        else if (num == 1)
        {
            has1 = true;
        }
        else if (num == 2)
        {
            has2 = true;
        }
        else if (num == 3)
        {
            has3 = true;
        }
    }
    
    for (NSNumber* number in self.goalLeftColorsState){
        int num = [number intValue];
        if (num == 0)
        {
            hasWhiteOnLeft = true;
        }
        else if (num == 1)
        {
            has1 = true;
        }
        else if (num == 2)
        {
            has2 = true;
        }
        else if (num == 3)
        {
            has3 = true;
        }
    }
    
    bool hasAllColors = has1 && has2 && has3;
    if (!hasAllColors)
    {
        return false;
    }
    
    // Check that we don't have any whites in the result
    if (hasWhiteOnTop && hasWhiteOnLeft)
    {
        return false;
    }
    
    // Check all rows for same colors in the row
    for (NSNumber* leftNSNumber in self.goalLeftColorsState)
    {
        int leftColor = [leftNSNumber intValue];
        int previousCombinedColor = -1;
        bool differentColorFound = false;
        for (NSNumber* topNSNumber in self.goalTopColorsState)
        {
            int topColor = [topNSNumber intValue];
            int combinedColor = [self CombineColors:leftColor :topColor];
            if (previousCombinedColor == -1)
            {
                previousCombinedColor = combinedColor;
            }
            else if (combinedColor != previousCombinedColor)
            {
                // We found a different color in the row, we're good
                differentColorFound = true;
                break;
            }
        }
        
        if (!differentColorFound)
        {
            // We found all same colors in a row, no good
            return false;
        }
    }
    
    // Check all columns for same colors in the column
    for (NSNumber* topNSNumber in self.goalTopColorsState)
    {
        int topColor = [topNSNumber intValue];
        int previousCombinedColor = -1;
        bool differentColorFound = false;
        for (NSNumber* leftNSNumber in self.goalLeftColorsState)
        {
            int leftColor = [leftNSNumber intValue];
            int combinedColor = [self CombineColors:leftColor :topColor];
            if (previousCombinedColor == -1)
            {
                previousCombinedColor = combinedColor;
            }
            else if (combinedColor != previousCombinedColor)
            {
                // We found a different color in the row, we're good
                differentColorFound = true;
                break;
            }
        }
        
        if (!differentColorFound)
        {
            // We found all same colors in a column, no good
            return false;
        }
    }
    
    return true;
}

-(void)DrawVerticalConnectingLines
{
    // We want to connect lines from the top color buttons to the bottom row of color cells
    NSArray *topConnections = self.topGridColorButtons;
    int rowCount = (int)[self.colorCellSections count];
    NSArray *bottomConnections = [self.colorCellSections objectAtIndex:rowCount - 1];
    
    // We should assert that top connections and bottom connections have equal number of items
    int itemCount = (int)[topConnections count];
    NSMutableArray *verticalLines = [NSMutableArray array];
    for (int i=0; i<itemCount; i++)
    {
        // Draw line
        GridColorButton *topColorButton = [topConnections objectAtIndex:i];
        UIView *topConnection = topColorButton.button;
        int topAdjustment = -13;   // Accounts for extra spacing in top button
        int topY = topConnection.frame.origin.y + topConnection.frame.size.height + topAdjustment;
        int xAdjustment = -1; // Account for the fact that our width is 3 pixels
        int topX = topConnection.frame.origin.x + topConnection.frame.size.width / 2 + xAdjustment;
        
        UIImageView *bottomConnection = [bottomConnections objectAtIndex:i];
        int bottomAdjustment = 3;   // Accounts for extra spacing in bottom button
        int bottomY = bottomConnection.frame.origin.y + bottomAdjustment;
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(topX, topY, 3, bottomY - topY)];
        line.backgroundColor = [self GetGrayColor];
        [_GridContainerView addSubview:line];
        [_GridContainerView sendSubviewToBack:line];
        
        [verticalLines addObject:line];
    }
    
    self.verticalLines = verticalLines;
}

-(void)DrawHorizontalConnectingLines
{
    // We want to connect lines from the left color buttons to the rightmost column of color cells
    NSArray *leftConnections = self.leftGridColorButtons;
    int rowCount = (int)[self.colorCellSections count];

    // Add rightmost cell of each row to rightConnections
    NSMutableArray *rightConnections = [NSMutableArray array];
    for (int i=0; i<rowCount; i++)
    {
        NSArray *row = [self.colorCellSections objectAtIndex:i];
        int colCount = (int)[row count];
        UIView *rightConnection = [row objectAtIndex:colCount - 1];
        [rightConnections addObject:rightConnection];
    }
    
    // We should assert that left connections and right connections have equal number of items
    int itemCount = (int)[leftConnections count];
    NSMutableArray *horizontalLines = [NSMutableArray array];
    for (int i=0; i<itemCount; i++)
    {
        // Draw line
        GridColorButton *leftColorButton = [leftConnections objectAtIndex:i];
        UIView *leftConnection = leftColorButton.button;

        int yAdjustment = -1; // Account for the fact that our width is 3 pixels
        int leftY = leftConnection.frame.origin.y + leftConnection.frame.size.height / 2 + yAdjustment;
        int leftAdjustment = -13;   // Accounts for extra spacing in left button
        int leftX = leftConnection.frame.origin.x + leftConnection.frame.size.width + leftAdjustment;
        
        UIImageView *rightConnection = [rightConnections objectAtIndex:i];;
        int rightAdjustment = 3;   // Accounts for extra spacing in right button
        int rightX = rightConnection.frame.origin.x + rightAdjustment;
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(leftX, leftY, rightX - leftX, 3)];
        line.backgroundColor = [self GetGrayColor];
        [_GridContainerView addSubview:line];
        [_GridContainerView sendSubviewToBack:line];
        
        [horizontalLines addObject:line];
    }
    
    self.horizontalLines = horizontalLines;
}

-(void)UpdateColorCells:(NSMutableArray *)colorCellSections :(NSMutableArray*)topColorsState :(NSMutableArray*) leftColorsState
{
    int sectionsCount = (int)[colorCellSections count];
    for (int i=0; i<sectionsCount; i++)
    {
        NSArray *row = [colorCellSections objectAtIndex:i];
        int rowLength = (int)[row count];
        for (int j=0; j<rowLength; j++)
        {
            int topColor = [(NSNumber *)[topColorsState objectAtIndex:j] intValue];
            int leftColor = [(NSNumber *)[leftColorsState objectAtIndex:i] intValue];
            
            int combinedColor = [self CombineColors:leftColor :topColor];
            
            UIImage *image = [self GetCellImageForColor:combinedColor];
            
            UIImageView *imageView = [row objectAtIndex:j];
            [imageView setImage:image];
        }
    }
}

/*------------------------------------------
 Return results:
 0 - white
 1 - blue
 2 - Red
 3 - Yellow
 4 - Purple
 5 - Green
 6 - Orange
 ------------------------------------------*/
-(int)CombineColors:(int)color1 :(int)color2
{
    if (color1 == 0 && color2 == 0)
    {
        return 0;
    }
    else if ((color1 == 1 && color2 == 1) || (color1 == 1 && color2 == 0) || (color1 == 0 && color2 == 1))
    {
        return 1;
    }
    else if ((color1 == 2 && color2 == 2) || (color1 == 2 && color2 == 0) || (color1 == 0 && color2 == 2))
    {
        return 2;
    }
    else if ((color1 == 3 && color2 == 3) || (color1 == 3 && color2 == 0) || (color1 == 0 && color2 == 3))
    {
        return 3;
    }
    else if ((color1 == 1 && color2 == 2) || (color1 == 2 && color2 == 1))
    {
        return 4;
    }
    else if ((color1 == 1 && color2 == 3) || (color1 == 3 && color2 == 1))
    {
        return 5;
    }
    else if ((color1 == 2 && color2 == 3) || (color1 == 3 && color2 == 2))
    {
        return 6;
    }
    
    // Should not be hit
    return 0;
}

-(UIColor *) GetGrayColor
{
    return [UIColor colorWithRed:(192/255.0) green:(192/255.0) blue:(192/255.0) alpha:1];
}

-(UIColor *) GetBlueColor
{
    return [UIColor colorWithRed:(0/255.0) green:(38/255.0) blue:(255/255.0) alpha:1];
}

-(UIColor *) GetYellowColor
{
    return [UIColor colorWithRed:(255/255.0) green:(216/255.0) blue:(0/255.0) alpha:1];
}

-(UIColor *) GetRedColor
{
    return [UIColor colorWithRed:(255/255.0) green:(0/255.0) blue:(0/255.0) alpha:1];
}

-(UIImage *) GetCellImageForColor:(int)color
{
    switch (color)
    {
        case 0:
            return [UIImage imageNamed:@"BlockWhite.png"];
            break;
        case 1:
            return [UIImage imageNamed:@"BlockBlue.png"];
            break;
        case 2:
            return [UIImage imageNamed:@"BlockRed.png"];
            break;
        case 3:
            return [UIImage imageNamed:@"BlockYellow.png"];
            break;
        case 4:
            return [UIImage imageNamed:@"BlockPurple.png"];
            break;
        case 5:
            return [UIImage imageNamed:@"BlockGreen.png"];
            break;
        case 6:
            return [UIImage imageNamed:@"BlockOrange.png"];
            break;
        default:
            return [UIImage imageNamed:@"BlockWhite.png"];
            break;
    }
}

-(void)resetCells
{
    // Clear top color buttons
    for (int i=0; i < _topGridColorButtons.count; i++)
    {
        GridColorButton *gridColorButton = [_topGridColorButtons objectAtIndex:i];
        UIButton *button = gridColorButton.button;
        [self PressGridButtonWithColor:button :0];
    }
    
    // Clear left color buttons
    for (int i=0; i < _leftGridColorButtons.count; i++)
    {
        GridColorButton *gridColorButton = [_leftGridColorButtons objectAtIndex:i];
        UIButton *button = gridColorButton.button;
        [self PressGridButtonWithColor:button :0];
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
    for (int i=0; i < self.goalTopColorsState.count; i++)
    {
        for (int j=0; j < self.goalLeftColorsState.count; j++)
        {
            int goalTopColor = [(NSNumber *)[self.goalTopColorsState objectAtIndex:i] intValue];
            int goalLeftColor = [(NSNumber *)[self.goalLeftColorsState objectAtIndex:j] intValue];
            int goalCombinedColor = [self CombineColors:goalTopColor :goalLeftColor];
            
            GridColorButton *actualTopButton = [_topGridColorButtons objectAtIndex:i];
            int actualTopColor = [actualTopButton.color intValue];
            GridColorButton *actualLeftButton = [_leftGridColorButtons objectAtIndex:j];
            int actualLeftColor = [actualLeftButton.color intValue];
            int actualCombinedColor = [self CombineColors:actualTopColor :actualLeftColor];
            
            if (goalCombinedColor != actualCombinedColor)
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
    [self generateNewBoard];
    [self resetActionBar];
    [self resetCells];
    [self startTimer];
    [self initMovesCount];
}
@end
