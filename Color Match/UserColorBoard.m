//
//  UserColorBoard.m
//  Color Match
//
//  Created by Linda Chen on 1/11/14.
//  Copyright (c) 2014 SunSpark Entertainment. All rights reserved.
//

#import "UserColorBoard.h"
#import "GridColorButton.h"

@interface UserColorBoard ()
@property CMViewController *viewController;
@property NSMutableArray *allGridColorButtons;
@property NSMutableArray *verticalLines;
@property NSMutableArray *horizontalLines;
@end

@implementation UserColorBoard

-(id)initWithParameters:(BoardParameters)boardParameters containerView:(UIView*)containerView viewController:(CMViewController*)viewController
{
    self = [super init];
    if (self)
    {
        self.boardParameters = boardParameters;
        self.containerView = containerView;
        _viewController = viewController;
        
        [self initGridColorButtons];
        [self initColorCells];

        // Draw connecting lines
        [self DrawVerticalConnectingLines];
        [self DrawHorizontalConnectingLines];
    }
    
    return self;
}

- (void)initColorCells
{
    // Color cell start 1 cell away from the left, so the xOffset is calculated by offset of the first column + 1 cellspacing
    int cellSizePlusSpace = self.boardParameters.colorCellSize + self.boardParameters.colorCellSpacing;
    int xOffsetInitial = self.boardParameters.xOffsetForFirstLeftGridButton + cellSizePlusSpace;
    int xOffset = xOffsetInitial;
    
    // Color cells starts 1 cell away from the top due to grid buttons
    int yOffset = cellSizePlusSpace;
    
    self.colorCellSections = [[NSMutableArray alloc] init];
    
    for (int i=0; i<self.boardParameters.gridSize; i++)
    {
        NSMutableArray *row = [[NSMutableArray alloc] init];
        for (int j=0; j<self.boardParameters.gridSize; j++)
        {
            UIImageView *cellBlock = [[UIImageView alloc] initWithFrame:CGRectMake(xOffset, yOffset, self.boardParameters.colorCellSize, self.boardParameters.colorCellSize)];
            cellBlock.image=[UIImage imageNamed:@"BlockWhite.png"];
            [self.containerView addSubview:cellBlock];
            
            [row addObject:cellBlock];
            xOffset += cellSizePlusSpace;
        }
        
        [self.colorCellSections addObject:row];
        yOffset += cellSizePlusSpace;
        xOffset = xOffsetInitial;
    }
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
        int topAdjustment = -1 * (self.boardParameters.emptyPaddingInGridButton);   // Accounts for extra spacing in top button
        int topY = topConnection.frame.origin.y + topConnection.frame.size.height + topAdjustment;
        int xAdjustment = -1; // Account for the fact that our width is 3 pixels
        int topX = topConnection.frame.origin.x + topConnection.frame.size.width / 2 + xAdjustment;
        
        UIImageView *bottomConnection = [bottomConnections objectAtIndex:i];
        int bottomAdjustment = 3;   // Accounts for extra spacing in bottom button
        int bottomY = bottomConnection.frame.origin.y + bottomAdjustment;
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(topX, topY, 3, bottomY - topY)];
        line.backgroundColor = [CommonUtils GetGrayColor];
        [self.containerView addSubview:line];
        [self.containerView sendSubviewToBack:line];
        
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
        int leftAdjustment = -1 * (self.boardParameters.emptyPaddingInGridButton);   // Accounts for extra spacing in left button
        int leftX = leftConnection.frame.origin.x + leftConnection.frame.size.width + leftAdjustment;
        
        UIImageView *rightConnection = [rightConnections objectAtIndex:i];;
        int rightAdjustment = 3;   // Accounts for extra spacing in right button
        int rightX = rightConnection.frame.origin.x + rightAdjustment;
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(leftX, leftY, rightX - leftX, 3)];
        line.backgroundColor = [CommonUtils GetGrayColor];
        [self.containerView addSubview:line];
        [self.containerView sendSubviewToBack:line];
        
        [horizontalLines addObject:line];
    }
    
    self.horizontalLines = horizontalLines;
}

-(void)pressGridButtonWithColor:(UIButton *)button :(int)selectedColor
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
        lineToUpdate.backgroundColor = [CommonUtils GetGrayColor];
    }
    else if (selectedColor == 1)
    {
        lineToUpdate.backgroundColor = [CommonUtils GetBlueColor];
    }
    else if (selectedColor == 2)
    {
        lineToUpdate.backgroundColor = [CommonUtils GetRedColor];
    }
    else if (selectedColor == 3)
    {
        lineToUpdate.backgroundColor = [CommonUtils GetYellowColor];
    }
    
    // Get current color states
    NSMutableArray *currentTopColorState = [[NSMutableArray alloc] init];
    for (GridColorButton* gridColorButton in _topGridColorButtons)
    {
        [currentTopColorState addObject:gridColorButton.color];
    }
    self.topColorsState = currentTopColorState;
    
    NSMutableArray *currentLeftColorState = [[NSMutableArray alloc]  init];
    for (GridColorButton* gridColorButton in _leftGridColorButtons)
    {
        [currentLeftColorState addObject:gridColorButton.color];
    }
    self.leftColorsState = currentLeftColorState;
    
    // Trigger update of color cells
    [self updateColorCells];
}

- (void)initGridColorButtons
{
    _allGridColorButtons = [[NSMutableArray alloc] init];
    _topGridColorButtons = [[NSMutableArray alloc] init];
    _leftGridColorButtons = [[NSMutableArray alloc] init];
    
    // Color cell start 1 cell away from the left, so the xOffset is calculated by offset of the first column + 1 cellspacing
    int cellSizePlusSpace = self.boardParameters.colorCellSize + self.boardParameters.colorCellSpacing;
    int xOffset = self.boardParameters.xOffsetForFirstLeftGridButton + cellSizePlusSpace;
    int yOffset = self.boardParameters.yOffsetForFirstTopGridButton;
    
    // Create top buttons
    for (int i=0; i<self.boardParameters.gridSize; i++)
    {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(xOffset, yOffset, self.boardParameters.colorCellSize, self.boardParameters.colorCellSize);
        [button setImage:[UIImage imageNamed:@"EmptyCircle.png"] forState:UIControlStateNormal];
        [button addTarget:_viewController action:@selector(GridButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self.containerView addSubview:button];
        
        GridColorButton *gridColorButton = [[GridColorButton alloc] initWithButton:button];
        [_allGridColorButtons addObject:gridColorButton];
        [_topGridColorButtons addObject:gridColorButton];
        xOffset += cellSizePlusSpace;
    }
    
    // Create left buttons
    xOffset = self.boardParameters.xOffsetForFirstLeftGridButton;
    yOffset = cellSizePlusSpace;
    for (int i=0; i<self.boardParameters.gridSize; i++)
    {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(xOffset, yOffset, self.boardParameters.colorCellSize, self.boardParameters.colorCellSize);
        [button setImage:[UIImage imageNamed:@"EmptyCircle.png"] forState:UIControlStateNormal];
        [button addTarget:_viewController action:@selector(GridButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self.containerView addSubview:button];
        
        GridColorButton *gridColorButton = [[GridColorButton alloc] initWithButton:button];
        [_allGridColorButtons addObject:gridColorButton];
        [_leftGridColorButtons addObject:gridColorButton];
        yOffset += cellSizePlusSpace;
    }
}

-(void)resetCells
{
    // Clear top color buttons
    for (int i=0; i < _topGridColorButtons.count; i++)
    {
        GridColorButton *gridColorButton = [_topGridColorButtons objectAtIndex:i];
        UIButton *button = gridColorButton.button;
        [self pressGridButtonWithColor:button :0];
    }
    
    // Clear left color buttons
    for (int i=0; i < _leftGridColorButtons.count; i++)
    {
        GridColorButton *gridColorButton = [_leftGridColorButtons objectAtIndex:i];
        UIButton *button = gridColorButton.button;
        [self pressGridButtonWithColor:button :0];
    }
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
    for (int i=0; i<self.colorCellSections.count; i++)
    {
        NSMutableArray *row = [self.colorCellSections objectAtIndex:i];
        for (int j=0; j<row.count; j++)
        {
            UIImageView *cellBlock = [row objectAtIndex:j];
            [cellBlock removeFromSuperview];
        }
        
        [row removeAllObjects];
    }
    
    [self.colorCellSections removeAllObjects];
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

- (void)removeExistingBoard
{
    [self removeExistingGridColorButtons];
    [self removeExistingGridCells];
    [self removeExistingConnectingLines];
}

-(NSNumber*)getCurrentColorForButton:(UIButton *)button;
{
    for (GridColorButton* gridColorButton in _allGridColorButtons)
    {
        if (gridColorButton.button == button)
        {
            return gridColorButton.color;
        }
    }
    
    // Should not be hit
    return NULL;
}

@end