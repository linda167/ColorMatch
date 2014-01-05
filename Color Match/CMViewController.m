//
//  CMViewController.m
//  Color Match
//
//  Created by Linda Chen on 1/1/14.
//  Copyright (c) 2014 SunSpark Entertainment. All rights reserved.
//

#import "CMViewController.h"

@interface CMViewController ()

@property NSInteger selectedColor;
@property NSArray *topColorButtons;
@property NSMutableArray *topColorsState;
@property NSArray *leftColorButtons;
@property NSMutableArray *leftColorsState;
@property NSMutableArray *colorCellSections;
@property NSMutableArray *verticalLines;
@property NSMutableArray *horizontalLines;
@property NSMutableArray *goalCellSections;
@property NSMutableArray *goalTopColorsState;
@property NSMutableArray *goalLeftColorsState;
@property (strong, nonatomic) NSTimer *stopWatchTimer;
@property (strong, nonatomic) NSDate * startTime;
@property NSInteger movesCount;
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

    // Init color bar buttons
    self.topColorButtons = [NSArray arrayWithObjects:_Top1Button,_Top2Button, _Top3Button, nil];
    self.leftColorButtons = [NSArray arrayWithObjects:_Left1Button,_Left2Button, _Left3Button, nil];
    
    // Init color bar states
    self.topColorsState = [NSMutableArray arrayWithObjects:[NSNumber numberWithInt:0], [NSNumber numberWithInt:0], [NSNumber numberWithInt:0], nil];
    self.leftColorsState = [NSMutableArray arrayWithObjects:[NSNumber numberWithInt:0], [NSNumber numberWithInt:0], [NSNumber numberWithInt:0], nil];
    
    // Init color cell sections
    NSArray *row1 = [NSArray arrayWithObjects:_Cell00,_Cell01, _Cell02, nil];
    NSArray *row2 = [NSArray arrayWithObjects:_Cell10,_Cell11, _Cell12, nil];
    NSArray *row3 = [NSArray arrayWithObjects:_Cell20,_Cell21, _Cell22, nil];
    
    self.colorCellSections = [NSMutableArray arrayWithObjects:row1, row2, row3, nil];
    
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
    self.movesCount = 0;
    [self updateMovesCountLabel];    
}

- (void)updateMovesCountLabel
{
    self.MovesLabel.text = [NSString stringWithFormat:@"%d", self.movesCount];
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
        else {
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
    }
}

- (IBAction)GridButtonPressed:(id)sender
{
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
    NSString *victoryMessage = [@"Nicely done! \n\n Time taken: " stringByAppendingString:self.TimerLabel.text];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Level Complete!"                                                        message:victoryMessage
        delegate: self cancelButtonTitle:@"Cancel"
        otherButtonTitles:nil];
    [alert addButtonWithTitle:@"Next Level"];
    [alert show];
}

-(void)PressGridButtonWithColor:(UIButton *)button :(int)selectedColor
{
    // Update color state on top and left bar
    NSNumber* wrappedSelectedColor = [NSNumber numberWithInt:selectedColor];
    NSInteger topIndex = [self.topColorButtons indexOfObject:button];
    UIView *lineToUpdate;
    if (topIndex != NSNotFound)
    {
        [self.topColorsState replaceObjectAtIndex:topIndex withObject:wrappedSelectedColor];
        lineToUpdate = [self.verticalLines objectAtIndex:topIndex];
    }
    else
    {
        NSInteger leftIndex = [self.leftColorButtons indexOfObject:button];
        // Should not be NSNotFound at ths point
        [self.leftColorsState replaceObjectAtIndex:leftIndex withObject:wrappedSelectedColor];
        lineToUpdate = [self.horizontalLines objectAtIndex:leftIndex];
    }
    
    // Update filled color on the button being clicked, and the color of the connecting line
    if (selectedColor == 0)
    {
        UIImage *btnImage1 = [UIImage imageNamed:@"EmptyCircle.png"];
        [button setImage:btnImage1 forState:UIControlStateNormal];
        lineToUpdate.backgroundColor = [self GetGrayColor];
    }
    else if (selectedColor == 1)
    {
        UIImage *btnImage1 = [UIImage imageNamed:@"FilledCircleBlue.png"];
        [button setImage:btnImage1 forState:UIControlStateNormal];
        lineToUpdate.backgroundColor = [self GetBlueColor];
    }
    else if (selectedColor == 2)
    {
        UIImage *btnImage1 = [UIImage imageNamed:@"FilledCircleRed.png"];
        [button setImage:btnImage1 forState:UIControlStateNormal];
        lineToUpdate.backgroundColor = [self GetRedColor];
    }
    else if (selectedColor == 3)
    {
        UIImage *btnImage1 = [UIImage imageNamed:@"FilledCircleYellow.png"];
        [button setImage:btnImage1 forState:UIControlStateNormal];
        lineToUpdate.backgroundColor = [self GetYellowColor];
    }
    
    // Trigger update of color cells
    [self UpdateColorCells: self.colorCellSections :self.topColorsState :self.leftColorsState];
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
    
    for (NSNumber* number in self.goalTopColorsState){
        int num = [number intValue];
        if (num == 1)
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
        if (num == 1)
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
    for (int i=0; i<self.goalTopColorsState.count; i++)
    {
        NSNumber* topNumber =[self.goalTopColorsState objectAtIndex:i];
        NSNumber* leftNumber =[self.goalLeftColorsState objectAtIndex:i];
        
        if ([topNumber intValue] == 0 && [topNumber intValue] == [leftNumber intValue])
        {
            // Top and left at matching index both has white. This will end up having a white cell in the result.
            return false;
        }
    }
    
    return true;
}

-(void)DrawVerticalConnectingLines
{
    // We want to connect lines from the top color buttons to the bottom row of color cells
    NSArray *topConnections = self.topColorButtons;
    int rowCount = (int)[self.colorCellSections count];
    NSArray *bottomConnections = [self.colorCellSections objectAtIndex:rowCount - 1];
    
    // We should assert that top connections and bottom connections have equal number of items
    int itemCount = (int)[topConnections count];
    NSMutableArray *verticalLines = [NSMutableArray array];
    for (int i=0; i<itemCount; i++)
    {
        // Draw line
        UIView *topConnection = [topConnections objectAtIndex:i];
        int topAdjustment = -13;   // Accounts for extra spacing in top button
        int topY = topConnection.frame.origin.y + topConnection.frame.size.height + topAdjustment;
        int xAdjustment = -1; // Account for the fact that our width is 3 pixels
        int topX = topConnection.frame.origin.x + topConnection.frame.size.width / 2 + xAdjustment;
        
        UIImageView *bottomConnection = [bottomConnections objectAtIndex:i];
        int bottomAdjustment = 3;   // Accounts for extra spacing in bottom button
        int bottomY = bottomConnection.frame.origin.y + bottomAdjustment;
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(topX, topY, 3, bottomY - topY)];
        line.backgroundColor = [self GetGrayColor];
        [self.view addSubview:line];
        [self.view sendSubviewToBack:line];
        
        [verticalLines addObject:line];
    }
    
    self.verticalLines = verticalLines;
}

-(void)DrawHorizontalConnectingLines
{
    // We want to connect lines from the left color buttons to the rightmost column of color cells
    NSArray *leftConnections = self.leftColorButtons;
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
        UIView *leftConnection = [leftConnections objectAtIndex:i];

        int yAdjustment = -1; // Account for the fact that our width is 3 pixels
        int leftY = leftConnection.frame.origin.y + leftConnection.frame.size.height / 2 + yAdjustment;
        int leftAdjustment = -13;   // Accounts for extra spacing in left button
        int leftX = leftConnection.frame.origin.x + leftConnection.frame.size.width + leftAdjustment;
        
        UIImageView *rightConnection = [rightConnections objectAtIndex:i];;
        int rightAdjustment = 3;   // Accounts for extra spacing in right button
        int rightX = rightConnection.frame.origin.x + rightAdjustment;
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(leftX, leftY, rightX - leftX, 3)];
        line.backgroundColor = [self GetGrayColor];
        [self.view addSubview:line];
        [self.view sendSubviewToBack:line];
        
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
            
            UIImage *image;
            if (topColor == 0 && leftColor == 0)
            {
                image = [UIImage imageNamed:@"BlockWhite.png"];
            }
            else if ((topColor == 1 && leftColor == 1) || (topColor == 1 && leftColor == 0) || (topColor == 0 && leftColor == 1))
            {
                image = [UIImage imageNamed:@"BlockBlue.png"];
            }
            else if ((topColor == 2 && leftColor == 2) || (topColor == 2 && leftColor == 0) || (topColor == 0 && leftColor == 2))
            {
                image = [UIImage imageNamed:@"BlockRed.png"];
            }
            else if ((topColor == 3 && leftColor == 3) || (topColor == 3 && leftColor == 0) || (topColor == 0 && leftColor == 3))
            {
                image = [UIImage imageNamed:@"BlockYellow.png"];
            }
            else if ((topColor == 1 && leftColor == 2) || (topColor == 2 && leftColor == 1))
            {
                image = [UIImage imageNamed:@"BlockPurple.png"];
            }
            else if ((topColor == 1 && leftColor == 3) || (topColor == 3 && leftColor == 1))
            {
                image = [UIImage imageNamed:@"BlockGreen.png"];
            }
            else if ((topColor == 2 && leftColor == 3) || (topColor == 3 && leftColor == 2))
            {
                image = [UIImage imageNamed:@"BlockOrange.png"];
            }
            
            UIImageView *imageView = [row objectAtIndex:j];
            [imageView setImage:image];
        }
    }
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

-(void)resetCells
{
    // Clear top color buttons
    for (int i=0; i < self.topColorButtons.count; i++)
    {
        UIButton *button = [self.topColorButtons objectAtIndex:i];
        [self PressGridButtonWithColor:button :0];
    }
    
    // Clear left color buttons
    for (int i=0; i < self.leftColorButtons.count; i++)
    {
        UIButton *button = [self.leftColorButtons objectAtIndex:i];
        [self PressGridButtonWithColor:button :0];
    }
    
}

-(BOOL)CheckVictory
{
    // Check top button states
    for (int i=0; i < self.goalTopColorsState.count; i++)
    {
        int goalColor = [(NSNumber *)[self.goalTopColorsState objectAtIndex:i] intValue];
        int actualColor = [(NSNumber *)[self.topColorsState objectAtIndex:i] intValue];
        
        if (goalColor != actualColor)
        {
            return false;
        }
    }
    
    // Check left button states
    for (int i=0; i < self.goalLeftColorsState.count; i++)
    {
        int goalColor = [(NSNumber *)[self.goalLeftColorsState objectAtIndex:i] intValue];
        int actualColor = [(NSNumber *)[self.leftColorsState objectAtIndex:i] intValue];
        
        if (goalColor != actualColor)
        {
            return false;
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
    [self resetCells];
    [self startTimer];
}
@end
