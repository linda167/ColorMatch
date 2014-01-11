//
//  CMViewController.m
//  Color Match
//
//  Created by Linda Chen on 1/1/14.
//  Copyright (c) 2014 SunSpark Entertainment. All rights reserved.
//

#import "CMViewController.h"
#import "GridColorButton.h"

// Parameters used to create current board
typedef struct BoardParameters
{
    int gridSize;
    int colorCellSize;
    int colorCellSpacing;
    int yOffsetForFirstTopGridButton;
    int xOffsetForFirstLeftGridButton;
    int emptyPaddingInGridButton;
    int goalColorCellSize;
    int goalColorCellSpacing;
} BoardParameters;

@interface CMViewController ()

@property NSInteger selectedColor;
@property NSMutableArray *allGridColorButtons;
@property NSMutableArray *topGridColorButtons;
@property NSMutableArray *leftGridColorButtons;
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
    
    // Init board parameters
    self.boardParameters = [self getBoardParametersForSize:3];
    
    // Start new game
    [self startNewGame];
}

- (void)startNewGame
{
    // Render new game board
    [self renderNewBoard];
    
    // Generate new random goal state
    [self generateNewGoalBoard];
    
    // Start the timer
    [self startTimer];
    
    // Init moves count
    [self initMovesCount];
}

// Render new board to view given current parameters
- (void)renderNewBoard
{
    // Init goal color cells
    [self initGoalColorCells];
    
    // Init color bar buttons
    [self initGridColorButtons];
    
    // Init color cell sections
    [self initColorCells];
    
    // Draw connecting lines
    [self DrawVerticalConnectingLines];
    [self DrawHorizontalConnectingLines];
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
            boardParameters.yOffsetForFirstTopGridButton= 0;
            boardParameters.xOffsetForFirstLeftGridButton = 29;
            boardParameters.emptyPaddingInGridButton = 13;
            boardParameters.goalColorCellSize = 40;
            boardParameters.goalColorCellSpacing = 8;
            break;
        case 4:
            boardParameters.colorCellSize = 40;
            boardParameters.colorCellSpacing = 10;
            boardParameters.yOffsetForFirstTopGridButton= 0;
            boardParameters.xOffsetForFirstLeftGridButton = 27;
            boardParameters.emptyPaddingInGridButton = 11;
            boardParameters.goalColorCellSize = 32;
            boardParameters.goalColorCellSpacing = 2;
            break;
        case 5:
            boardParameters.colorCellSize = 35;
            boardParameters.colorCellSpacing = 8;
            boardParameters.yOffsetForFirstTopGridButton= 0;
            boardParameters.xOffsetForFirstLeftGridButton = 20;
            boardParameters.emptyPaddingInGridButton = 9;
            boardParameters.goalColorCellSize = 25;
            boardParameters.goalColorCellSpacing = 2;
            break;
        default:
            [NSException raise:@"Invalid input" format:@"Invalid board size"];
            break;
    }
    
    return boardParameters;
}

- (void)initColorCells
{
    // Color cell start 1 cell away from the left, so the xOffset is calculated by offset of the first column + 1 cellspacing
    int cellSizePlusSpace = _boardParameters.colorCellSize + _boardParameters.colorCellSpacing;
    int xOffsetInitial = _boardParameters.xOffsetForFirstLeftGridButton + cellSizePlusSpace;
    int xOffset = xOffsetInitial;
    
    // Color cells starts 1 cell away from the top due to grid buttons
    int yOffset = cellSizePlusSpace;

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
            xOffset += cellSizePlusSpace;
        }

        [self.colorCellSections addObject:row];
        yOffset += cellSizePlusSpace;
        xOffset = xOffsetInitial;
    }
}

- (void)initGridColorButtons
{
    _allGridColorButtons = [[NSMutableArray alloc] init];
    _topGridColorButtons = [[NSMutableArray alloc] init];
    _leftGridColorButtons = [[NSMutableArray alloc] init];
    
    // Color cell start 1 cell away from the left, so the xOffset is calculated by offset of the first column + 1 cellspacing
    int cellSizePlusSpace = _boardParameters.colorCellSize + _boardParameters.colorCellSpacing;
    int xOffset = _boardParameters.xOffsetForFirstLeftGridButton + cellSizePlusSpace;
    int yOffset = _boardParameters.yOffsetForFirstTopGridButton;
    
    // Create top buttons
    for (int i=0; i<_boardParameters.gridSize; i++)
    {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(xOffset, yOffset, _boardParameters.colorCellSize, _boardParameters.colorCellSize);
        [button setImage:[UIImage imageNamed:@"EmptyCircle.png"] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(GridButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [_GridContainerView addSubview:button];

        GridColorButton *gridColorButton = [[GridColorButton alloc] initWithButton:button];
        [_allGridColorButtons addObject:gridColorButton];
        [_topGridColorButtons addObject:gridColorButton];
        xOffset += cellSizePlusSpace;
    }
    
    // Create left buttons
    xOffset = _boardParameters.xOffsetForFirstLeftGridButton;
    yOffset = cellSizePlusSpace;
    for (int i=0; i<_boardParameters.gridSize; i++)
    {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(xOffset, yOffset, _boardParameters.colorCellSize, _boardParameters.colorCellSize);
        [button setImage:[UIImage imageNamed:@"EmptyCircle.png"] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(GridButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [_GridContainerView addSubview:button];

        GridColorButton *gridColorButton = [[GridColorButton alloc] initWithButton:button];
        [_allGridColorButtons addObject:gridColorButton];
        [_leftGridColorButtons addObject:gridColorButton];
        yOffset += cellSizePlusSpace;
    }
}

- (void)initGoalColorCells
{
    int cellSizePlusSpace = _boardParameters.goalColorCellSize + _boardParameters.goalColorCellSpacing;
    int xOffsetInitial = 0;
    int xOffset = xOffsetInitial;
    int yOffset = 0;
    
    self.goalCellSections = [[NSMutableArray alloc] init];
    
    for (int i=0; i<_boardParameters.gridSize; i++)
    {
        NSMutableArray *row = [[NSMutableArray alloc] init];
        for (int j=0; j<_boardParameters.gridSize; j++)
        {
            UIImageView *cellBlock = [[UIImageView alloc] initWithFrame:CGRectMake(xOffset, yOffset, _boardParameters.goalColorCellSize, _boardParameters.goalColorCellSize)];
            cellBlock.image=[UIImage imageNamed:@"BlockWhite.png"];
            [_GoalContainerView addSubview:cellBlock];
            
            [row addObject:cellBlock];
            xOffset += cellSizePlusSpace;
        }
        
        [self.goalCellSections addObject:row];
        yOffset += cellSizePlusSpace;
        xOffset = xOffsetInitial;
    }
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

- (void)generateNewGoalBoard
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

- (IBAction)x3Pressed:(id)sender {
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
    self.goalTopColorsState = [[NSMutableArray alloc] init];
    self.goalLeftColorsState = [[NSMutableArray alloc] init];
    
    for (int i=0; i<_boardParameters.gridSize; i++)
    {
        int random = arc4random()%4;
        NSNumber* wrappedNumber = [NSNumber numberWithInt:random];
        [self.goalTopColorsState addObject:wrappedNumber];
    }
    
    for (int i=0; i<_boardParameters.gridSize; i++)
    {
        int random = arc4random()%4;
        NSNumber* wrappedNumber = [NSNumber numberWithInt:random];
        [self.goalLeftColorsState addObject:wrappedNumber];
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
        int topAdjustment = -1 * (_boardParameters.emptyPaddingInGridButton);   // Accounts for extra spacing in top button
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
        int leftAdjustment = -1 * (_boardParameters.emptyPaddingInGridButton);   // Accounts for extra spacing in left button
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
    [self generateNewGoalBoard];
    [self resetActionBar];
    [self resetCells];
    [self startTimer];
    [self initMovesCount];
}

- (void)removeExistingGridColorButtons
{
    for (int i=0; i<_allGridColorButtons.count; i++)
    {
        GridColorButton *gridColorButton = [_allGridColorButtons objectAtIndex:i];
        [gridColorButton.button removeFromSuperview];
    }
    
    [_allGridColorButtons removeAllObjects];
    [_topGridColorButtons removeAllObjects];
    [_leftGridColorButtons removeAllObjects];
}

- (void)removeExistingGridCells
{
    for (int i=0; i<_colorCellSections.count; i++)
    {
        NSMutableArray *row = [_colorCellSections objectAtIndex:i];
        for (int j=0; j<row.count; j++)
        {
            UIImageView *cellBlock = [row objectAtIndex:j];
            [cellBlock removeFromSuperview];
        }
        
        [row removeAllObjects];
    }
    
    [_colorCellSections removeAllObjects];
}

- (void)removeExistingConnectingLines
{
    for (int i=0; i<_verticalLines.count; i++)
    {
        UIView *line = [_verticalLines objectAtIndex:i];
        [line removeFromSuperview];
    }
    
    [_verticalLines removeAllObjects];
    
    for (int i=0; i<_horizontalLines.count; i++)
    {
        UIView *line = [_horizontalLines objectAtIndex:i];
        [line removeFromSuperview];
    }
    
    [_horizontalLines removeAllObjects];
}


- (void)removeExistingGoalColorCells
{
    for (int i=0; i<_goalCellSections.count; i++)
    {
        NSMutableArray *row = [_goalCellSections objectAtIndex:i];

        for (int j=0; j<row.count; j++)
        {
            UIImageView *cellBlock = [row objectAtIndex:j];
            [cellBlock removeFromSuperview];
        }
        
        [row removeAllObjects];
    }
    
    [_goalCellSections removeAllObjects];
}

- (void)removeExistingGoalColorsState
{
    [_goalTopColorsState removeAllObjects];
    [_goalLeftColorsState removeAllObjects];
}

- (void)removeExistingBoard
{
    [self removeExistingGridColorButtons];
    [self removeExistingGridCells];
    [self removeExistingConnectingLines];
    [self removeExistingGoalColorCells];
    [self removeExistingGoalColorsState];
}

- (void)clearExistingGame
{
    // Stop the timer
    [self.stopWatchTimer invalidate];
    
    // Remove game board state
    [self removeExistingBoard];
}

- (IBAction)ThreePressed:(id)sender {
    // Clean out existing game
    [self clearExistingGame];
    
    // Generate 3x3 parameters
    self.boardParameters = [self getBoardParametersForSize:3];
    
    // Start new game
    [self startNewGame];
}

- (IBAction)FourPressed:(id)sender
{
    // Clean out existing game
    [self clearExistingGame];

    // Generate 4x4 parameters
    self.boardParameters = [self getBoardParametersForSize:4];
    
    // Start new game
    [self startNewGame];
}

- (IBAction)FivePressed:(id)sender
{
    // Clean out existing game
    [self clearExistingGame];
    
    // Generate 5x5 parameters
    self.boardParameters = [self getBoardParametersForSize:5];
    
    // Start new game
    [self startNewGame];
}
@end
