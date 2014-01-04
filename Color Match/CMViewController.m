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
    self.topColorButtons = [NSArray arrayWithObjects:_Top1Button,_Top2Button, _Top3Button, nil];
    self.leftColorButtons = [NSArray arrayWithObjects:_Left1Button,_Left2Button, _Left3Button, nil];
    
    self.topColorsState = [NSMutableArray arrayWithObjects:[NSNumber numberWithInt:0], [NSNumber numberWithInt:0], [NSNumber numberWithInt:0], nil];
    self.leftColorsState = [NSMutableArray arrayWithObjects:[NSNumber numberWithInt:0], [NSNumber numberWithInt:0], [NSNumber numberWithInt:0], nil];
    
    NSArray *row1 = [NSArray arrayWithObjects:_Cell00,_Cell01, _Cell02, nil];
    NSArray *row2 = [NSArray arrayWithObjects:_Cell10,_Cell11, _Cell12, nil];
    NSArray *row3 = [NSArray arrayWithObjects:_Cell20,_Cell21, _Cell22, nil];
    
    self.colorCellSections = [NSMutableArray arrayWithObjects:row1, row2, row3, nil];
    
    [self DrawVerticalConnectingLines];
    [self DrawHorizontalConnectingLines];
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

- (IBAction)GridButtonPressed:(id)sender {

    int selectedColor = (int)self.selectedColor;
    
    // Update color state on top and left bar
    NSNumber* wrappedSelectedColor = [NSNumber numberWithInt:selectedColor];
    NSInteger topIndex = [self.topColorButtons indexOfObject:sender];
    UIView *lineToUpdate;
    if (topIndex != NSNotFound)
    {
        [self.topColorsState replaceObjectAtIndex:topIndex withObject:wrappedSelectedColor];
        lineToUpdate = [self.verticalLines objectAtIndex:topIndex];
    }
    else
    {
        NSInteger leftIndex = [self.leftColorButtons indexOfObject:sender];
        // Should not be NSNotFound at ths point
        [self.leftColorsState replaceObjectAtIndex:leftIndex withObject:wrappedSelectedColor];
        lineToUpdate = [self.horizontalLines objectAtIndex:leftIndex];
    }
    
    // Update filled color on the button being clicked, and the color of the connecting line
    if (selectedColor == 0)
    {
        UIImage *btnImage1 = [UIImage imageNamed:@"EmptyCircle.png"];
        [sender setImage:btnImage1 forState:UIControlStateNormal];
        lineToUpdate.backgroundColor = [self GetGrayColor];
    }
    else if (selectedColor == 1)
    {
        UIImage *btnImage1 = [UIImage imageNamed:@"FilledCircleBlue.png"];
        [sender setImage:btnImage1 forState:UIControlStateNormal];
        lineToUpdate.backgroundColor = [self GetBlueColor];
    }
    else if (selectedColor == 2)
    {
        UIImage *btnImage1 = [UIImage imageNamed:@"FilledCircleRed.png"];
        [sender setImage:btnImage1 forState:UIControlStateNormal];
        lineToUpdate.backgroundColor = [self GetRedColor];
    }
    else if (selectedColor == 3)
    {
        UIImage *btnImage1 = [UIImage imageNamed:@"FilledCircleYellow.png"];
        [sender setImage:btnImage1 forState:UIControlStateNormal];
        lineToUpdate.backgroundColor = [self GetYellowColor];
    }
    
    // Trigger update of color cells
    [self UpdateColorCells];
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

-(void)UpdateColorCells
{
    int sectionsCount = (int)[self.colorCellSections count];
    for (int i=0; i<sectionsCount; i++)
    {
        NSArray *row = [self.colorCellSections objectAtIndex:i];
        int rowLength = (int)[row count];
        for (int j=0; j<rowLength; j++)
        {
            int topColor = [(NSNumber *)[self.topColorsState objectAtIndex:j] intValue];
            int leftColor = [(NSNumber *)[self.leftColorsState objectAtIndex:i] intValue];
            
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

@end
