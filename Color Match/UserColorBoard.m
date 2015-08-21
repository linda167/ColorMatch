//
//  UserColorBoard.m
//  Color Match
//
//  Created by Linda Chen on 1/11/14.
//  Copyright (c) 2014 SunSpark Entertainment. All rights reserved.
//

#import "UserColorBoard.h"
#import "GridColorButton.h"
#import "ColorCell.h"
#import "BoardCells.h"
#import "ConnectorLines.h"
#import "ZonerCell.h"
#import "ZonerCellButton.h"
#import "ConnectorCell.h"
#import "SplitterCellButton.h"
#import "ConverterCell.h"
#import "ConverterCellButton.h"
#import "TransporterGroup.h"
#import "TransporterCell.h"
#import "ShifterCell.h"
#import "DiverterCell.h"
#import "MainGameManager.h"
#import "SoundManager.h"

@interface UserColorBoard ()
@property MainGameViewController *viewController;
@property NSMutableArray *allConnectorCells;
@property NSMutableArray *allSplitterCells;
@property NSMutableArray *allConverterCells;
@property NSMutableArray *allShifterCells;
@property int connectorColorInput;
@end

@implementation UserColorBoard

-(id)initWithParameters:
    (BoardParameters)boardParameters
    containerView:(UIView*)containerView
    viewController:(MainGameViewController*)viewController
    boardCells:(BoardCells*) boardCells
{
    self = [super initWithParameters:boardCells];
    if (self)
    {
        self.boardParameters = boardParameters;
        self.containerView = containerView;
        _viewController = viewController;
        self.allConnectorCells = [[NSMutableArray alloc] init];
        self.allSplitterCells = [[NSMutableArray alloc] init];
        self.allConverterCells = [[NSMutableArray alloc] init];
        self.allShifterCells = [[NSMutableArray alloc] init];
        self.connectorColorInput = 0;
        
        [self createNewBoard];
    }
    
    return self;
}

- (void)createNewBoard
{
    [self initGridColorButtons];
    [self initColorCells];
    [self applySpecialCells];
    
    // Draw connecting lines
    [self CreateConnectorLinesFrame];
    [self DrawVerticalConnectingLines];
    [self DrawHorizontalConnectingLines];
    [self DrawConverterCellLines];
    [self DrawTransporterCellLines];
    
    // Hide certain grid color buttons if needed
    [self adjustGridColorButtons];
}

- (void)initColorCells
{
    // Color cell start 1 cell away from the left, so the xOffset is calculated by offset of the first column + 1 cellspacing
    int cellSizePlusSpace = self.boardParameters.colorCellSize + self.boardParameters.colorCellSpacing;
    int xOffsetInitial = self.boardParameters.xOffsetForFirstLeftGridButton + cellSizePlusSpace + self.boardParameters.xAdjustmentForColorCells;
    int xOffset = xOffsetInitial;
    
    // Color cells starts 1 cell away from the top due to grid buttons
    int yOffset = cellSizePlusSpace;
    
    self.colorCellSections = [[NSMutableArray alloc] init];
    
    for (int i=0; i<self.boardParameters.gridSize; i++)
    {
        NSMutableArray *row = [[NSMutableArray alloc] init];
        NSMutableArray *boardCellTypeRow = [self.boardCells.colorCellSections objectAtIndex:i];
        
        for (int j=0; j<self.boardParameters.gridSize; j++)
        {
            NSNumber *cellType = [boardCellTypeRow objectAtIndex:j];
            
            ColorCell *colorCell = [self getColorCellForType:cellType.intValue xOffset:xOffset yOffset:yOffset size:self.boardParameters.colorCellSize row:i col:j boardCells:self.boardCells];
            
            [row addObject:colorCell];
            xOffset += cellSizePlusSpace;
        }
        
        [self.colorCellSections addObject:row];
        yOffset += cellSizePlusSpace;
        xOffset = xOffsetInitial;
    }
}

- (void)applySpecialCells
{
    for (int i=0; i<self.colorCellSections.count; i++)
    {
        NSMutableArray *row = [self.colorCellSections objectAtIndex:i];
        
        for (int j=0; j<row.count; j++)
        {
            ColorCell *colorCell = [row objectAtIndex:j];
            if (colorCell.cellType == Shifter)
            {
                [self applySpecialCell:colorCell isAdd:true cellsAffected:NULL];
            }
        }
    }
}

-(void)CreateConnectorLinesFrame
{
    // CGRect for dimensions of container frame
    CGRect containerFrame = CGRectMake(0,0,self.containerView.frame.size.height,self.containerView.frame.size.height);
    self.connectorLines = [[ConnectorLines alloc] initWithFrame:containerFrame];
    [self.containerView addSubview:self.connectorLines];
    [self.containerView sendSubviewToBack:self.connectorLines];
}

-(void)DrawVerticalConnectingLines
{
    // We want to connect lines from the top color buttons to the bottom row of color cells, unless there are reflector cells
    NSArray *topConnections = self.topGridColorButtons;
    
    int itemCount = (int)[topConnections count];
    for (int i=0; i<itemCount; i++)
    {
        // Figure out connection points
        GridColorButton *topColorButton = [topConnections objectAtIndex:i];
        UIView *topConnection = topColorButton.button;
        
        // Accounts for extra spacing in top button
        int topAdjustment = -1 * (self.boardParameters.emptyPaddingInGridButton);
        int topY = topConnection.frame.origin.y + topConnection.frame.size.height + topAdjustment;
        int topX = topConnection.frame.origin.x + topConnection.frame.size.width / 2 + 0.5;
        
        // Draw the line
        LineInfo *lineInfo = [[LineInfo alloc] init];
        lineInfo.lineThickness = 3;
        lineInfo.startX = topX;
        lineInfo.startY = topY;
        lineInfo.color = [CommonUtils GetGrayColor];
        [self DrawLineToNextConnectionPoint:-1 currentCol:i currentX:topX currentY:topY isHorizontal:false lineInfo:lineInfo];
        [self.connectorLines addLine:lineInfo isHorizontal:false];
    }
}

-(void)DrawHorizontalConnectingLines
{
    // We want to connect lines from the left color buttons to the rightmost column of color cells
    NSArray *leftConnections = self.leftGridColorButtons;
    
    int itemCount = (int)[leftConnections count];
    for (int i=0; i<itemCount; i++)
    {
        // Figue out connection points
        GridColorButton *leftColorButton = [leftConnections objectAtIndex:i];
        UIView *leftConnection = leftColorButton.button;
        
        int leftY = leftConnection.frame.origin.y + leftConnection.frame.size.height / 2 + 0.5;
        int leftAdjustment = -1 * (self.boardParameters.emptyPaddingInGridButton);   // Accounts for extra spacing in left button
        int leftX = leftConnection.frame.origin.x + leftConnection.frame.size.width + leftAdjustment;
        
        // Draw the line
        LineInfo *lineInfo = [[LineInfo alloc] init];
        lineInfo.lineThickness = 3;
        lineInfo.startX = leftX;
        lineInfo.startY = leftY;
        lineInfo.color = [CommonUtils GetGrayColor];
        [self DrawLineToNextConnectionPoint:i currentCol:-1 currentX:leftX currentY:leftY isHorizontal:true lineInfo:lineInfo];
        [self.connectorLines addLine:lineInfo isHorizontal:true];
    }
}

-(void)DrawLineToNextConnectionPoint:(int)currentRow currentCol:(int)currentCol currentX:(int)currentX currentY:(int)currentY isHorizontal:(BOOL)isHorizontal lineInfo:(LineInfo*)lineInfo
{
    if (isHorizontal)
    {
        NSArray *row = [self.colorCellSections objectAtIndex:currentRow];
        
        bool connectionFound = false;
        for (int i = currentCol+1; i < row.count; i++)
        {
            ColorCell *colorCell = [row objectAtIndex:i];
            if (colorCell.cellType == ReflectorLeftToDown || colorCell.cellType == Diverter)
            {
                // Draw line to reflector
                int rightX = [self DrawHorizontalLineToConnection:colorCell lineInfo:lineInfo currentY:currentY drawToCenter:true];
                
                // Trigger drawing to next connection vertically
                [self DrawLineToNextConnectionPoint:currentRow currentCol:i currentX:rightX currentY:currentY isHorizontal:false lineInfo:lineInfo];
                
                connectionFound = true;
                break;
            }
            else if (colorCell.cellType == ReflectorTopToRight ||
                     colorCell.cellType == TransporterOutputRight ||
                     colorCell.cellType == Converter)
            {
                if (i > currentCol + 1)
                {
                    // Draw line to closest cell to the left that would need a line
                    ColorCell *colorCell = [self FindClosestCellReceivingLinesToLeft:currentRow colStartVal:currentCol colEndVal:i];
                    
                    if (colorCell != NULL)
                    {
                        [self DrawHorizontalLineToConnection:colorCell lineInfo:lineInfo currentY:currentY drawToCenter:true];
                    }
                }
        
                connectionFound = true;
                break;
            }
            else if (colorCell.cellType == TransporterInputLeft)
            {
                // Draw line to cell
                ColorCell *colorCell = [row objectAtIndex:i];
                [self DrawHorizontalLineToConnection:colorCell lineInfo:lineInfo currentY:currentY drawToCenter:true];
                
                connectionFound = true;
                break;
            }
        }
        
        if (!connectionFound)
        {
            // If no special connection found, then the connection is to the right most cell that supports combining color
            ColorCell *colorCell = [self FindRightmostGoalTargetCell:currentRow];
            [self DrawHorizontalLineToConnection:colorCell lineInfo:lineInfo currentY:currentY drawToCenter:true];
        }
    }
    else    // if vertical
    {
        bool connectionFound = false;
        for (int i=currentRow+1; i<self.colorCellSections.count; i++)
        {
            NSArray *row = [self.colorCellSections objectAtIndex:i];
            ColorCell *colorCell = [row objectAtIndex:currentCol];
            
            if (colorCell.cellType == ReflectorLeftToDown ||
                colorCell.cellType == TransporterOutputDown ||
                colorCell.cellType == Converter)
            {
                if (i > currentRow + 1)
                {
                    // Draw line to closest cell above that would need a line
                    ColorCell *colorCell = [self FindClosestCellReceivingLinesOnTop:currentCol rowStartVal:currentRow rowEndVal:i];
                    if (colorCell != NULL)
                    {
                        [self DrawVerticalLineToConnection:colorCell lineInfo:lineInfo currentX:currentX drawToCenter:true];
                    }
                }
                 
                connectionFound = true;
                break;
            }
            else if (colorCell.cellType == ReflectorTopToRight ||
                     colorCell.cellType == Diverter)
            {
                // Draw line to reflector
                int bottomY = [self DrawVerticalLineToConnection:colorCell lineInfo:lineInfo currentX:currentX drawToCenter:true];
                
                // Trigger drawing to next connection horizontally
                [self DrawLineToNextConnectionPoint:i currentCol:currentCol currentX:   currentX currentY:bottomY isHorizontal:true lineInfo:lineInfo];
                
                connectionFound = true;
                break;
            }
            else if (colorCell.cellType == Converter || colorCell.cellType == TransporterInputTop)
            {
                // Draw line to converter
                [self DrawVerticalLineToConnection:colorCell lineInfo:lineInfo currentX:currentX drawToCenter:true];
                
                connectionFound = true;
                break;
            }
        }
        
        if (!connectionFound)
        {
            // If no special connection found, then the connection is to the bottom most cell that supports combining color
            ColorCell *colorCell = [self FindBottommostGoalTargetCell:currentCol];
            [self DrawVerticalLineToConnection:colorCell lineInfo:lineInfo currentX:currentX drawToCenter:true];
        }
    }
}

-(int)DrawHorizontalLineToConnection:(ColorCell*)connection lineInfo:(LineInfo*)lineInfo currentY:(int)currentY drawToCenter:(BOOL)drawToCenter
{
    UIView *rightConnection = [connection image];
    int rightAdjustment = 4;   // Accounts for extra spacing in right button
    int rightX = rightConnection.frame.origin.x + rightAdjustment;
    
    if (drawToCenter)
    {
        rightX = rightX + rightConnection.frame.size.width / 2;
        
        // adjustment for line width
        rightX = rightX - 3;
    }
    
    LinePiece *linePiece = [[LinePiece alloc] init];
    linePiece.endX = rightX;
    linePiece.endY = currentY;
    linePiece.isHorizontal = true;
    [lineInfo addLinePiece:linePiece];
    
    return rightX;
}

-(int)DrawVerticalLineToConnection:(ColorCell*)connection lineInfo:(LineInfo*)lineInfo currentX:(int)currentX drawToCenter:(BOOL)drawToCenter
{
    UIView *bottomConnection = [connection image];
    int bottomAdjustment = 4;   // Accounts for extra spacing in bottom button
    int bottomY = bottomConnection.frame.origin.y + bottomAdjustment;
    
    if (drawToCenter)
    {
        bottomY = bottomY + bottomConnection.frame.size.height / 2;
        
        // adjustment for line width
        bottomY = bottomY - 3;
    }
    
    LinePiece *linePiece = [[LinePiece alloc] init];
    linePiece.endX = currentX;
    linePiece.endY = bottomY;
    linePiece.isHorizontal = false;
    [lineInfo addLinePiece:linePiece];
    
    return bottomY;
}

-(ColorCell*)FindClosestCellReceivingLinesToLeft:(int)rowVal colStartVal:(int)colStartVal colEndVal:(int)colEndVal
{
    // Search between but not including start and end val
    NSArray *row = [self.colorCellSections objectAtIndex:rowVal];
    for (int i = colEndVal-1; i > colStartVal; i--)
    {
        ColorCell *colorCell = [row objectAtIndex:i];
        if (colorCell.cellType != ReflectorTopToRight &&
            colorCell.cellType != Zoner &&
            colorCell.cellType != Splitter &&
            colorCell.cellType != TransporterInputTop &&
            colorCell.cellType != TransporterOutputRight &&
            colorCell.cellType != TransporterOutputDown)
        {
            return colorCell;
        }
    }
    
    return NULL;
}

-(ColorCell*)FindClosestCellReceivingLinesOnTop:(int)colVal rowStartVal:(int)rowStartVal rowEndVal:(int)rowEndVal
{
    // Search between but not including start and end val
    for (int i = rowEndVal-1; i > rowStartVal; i--)
    {
        NSArray *row = [self.colorCellSections objectAtIndex:i];
        ColorCell *colorCell = [row objectAtIndex:colVal];
        if (colorCell.cellType != ReflectorLeftToDown &&
            colorCell.cellType != Zoner &&
            colorCell.cellType != Splitter &&
            colorCell.cellType != TransporterInputLeft &&
            colorCell.cellType != TransporterOutputRight &&
            colorCell.cellType != TransporterOutputDown)
        {
            return colorCell;
        }
    }
    
    return NULL;
}

-(ColorCell*)FindRightmostGoalTargetCell:(int)rowVal
{
    NSArray *row = [self.colorCellSections objectAtIndex:rowVal];
    for (int i = row.count-1; i >=0; i--)
    {
        ColorCell *colorCell = [row objectAtIndex:i];
        if ([ColorCell isGoalTargetCell:colorCell.cellType])
        {
            return colorCell;
        }
    }
    
    return NULL;
}

-(ColorCell*)FindBottommostGoalTargetCell:(int)colVal
{
    for (int i = self.colorCellSections.count - 1; i >= 0; i--)
    {
        NSArray *row = [self.colorCellSections objectAtIndex:i];
        ColorCell *colorCell = [row objectAtIndex:colVal];
        if ([ColorCell isGoalTargetCell:colorCell.cellType])
        {
            return colorCell;
        }
    }
    
    return NULL;
}

-(void)DrawTransporterCellLines
{
    for (NSString* key in self.transporterGroups)
    {
        TransporterGroup* transporterGroup = [self.transporterGroups objectForKey:key];
        for (TransporterCell* cell in transporterGroup.teleporterOutputs)
        {
            bool isHorizontal = cell.cellType == TransporterOutputRight;
            
            [CommonUtils Log:[NSMutableString stringWithFormat: @"Drawing transporter line from:(%d,%d), isHorizontal:%d", cell.row, cell.col, isHorizontal]];
            
            [self DrawSingleTransporterLine:isHorizontal transporterCell:cell];
        }
    }
}

-(void)DrawSingleTransporterLine:(BOOL)isHorizontal transporterCell:(TransporterCell*)transporterCell
{
    // Draw from center of cell
    int leftY = transporterCell.image.frame.origin.y + transporterCell.image.frame.size.height / 2 + 0.5;
    int leftX = transporterCell.image.frame.origin.x + transporterCell.image.frame.size.width / 2 + 0.5;
    
    // Draw the line
    LineInfo *lineInfo = [[LineInfo alloc] init];
    lineInfo.lineThickness = 3;
    lineInfo.startX = leftX;
    lineInfo.startY = leftY;
    lineInfo.color = [CommonUtils GetGrayColor];
    
    int rowValue = transporterCell.row;
    int colValue = transporterCell.col;
    
    // Draw line
    [self DrawLineToNextConnectionPoint:rowValue currentCol:colValue currentX:leftX currentY:leftY isHorizontal:isHorizontal lineInfo:lineInfo];
    
    [self.connectorLines addTransporterLine:transporterCell.groupId lineInfo:lineInfo];
}


-(void)DrawConverterCellLines
{
    for (int i = 0; i < self.allConverterCells.count; i++)
    {
        ConverterCell* converterCell = [self.allConverterCells objectAtIndex:i];
        [self DrawSingleConverterLine:converterCell index:i];
    }
}

-(void)DrawSingleConverterLine:(ConverterCell*)converterCell index:(int)index
{
    bool isHorizontal = converterCell.isDirectionRight;
    
    UIView* previousCellWithInputLine;
    if (isHorizontal)
    {
        previousCellWithInputLine = [self FindClosestCellReceivingLinesToLeft:converterCell.row colStartVal:-1 colEndVal:converterCell.col].image;
        
        if (previousCellWithInputLine == NULL)
        {
            // If we're on edge, return grid color cell
            GridColorButton *gridColorButton = [self.leftGridColorButtons objectAtIndex:converterCell.row];
            previousCellWithInputLine = gridColorButton.button;
        }
    }
    else
    {
        previousCellWithInputLine = [self FindClosestCellReceivingLinesOnTop:converterCell.col rowStartVal:-1 rowEndVal:converterCell.row].image;
        
        if (previousCellWithInputLine == NULL)
        {
            // If we're on edge, return grid color cell
            GridColorButton *gridColorButton = [self.topGridColorButtons objectAtIndex:converterCell.col];
            previousCellWithInputLine = gridColorButton.button;
        }
    }
    
    // Draw from center of previous input cell cell
    int leftY = previousCellWithInputLine.frame.origin.y + previousCellWithInputLine.frame.size.height / 2 + 0.5;
    int leftX = previousCellWithInputLine.frame.origin.x + previousCellWithInputLine.frame.size.width / 2 + 0.5;
    
    // Draw the line
    LineInfo *lineInfo = [[LineInfo alloc] init];
    lineInfo.lineThickness = 3;
    lineInfo.startX = leftX;
    lineInfo.startY = leftY;
    lineInfo.color = [CommonUtils GetGrayColor];
    
    int rowValue = converterCell.row;
    int colValue = converterCell.col;
    
    // Draw line
    [self DrawLineToNextConnectionPoint:rowValue currentCol:colValue currentX:leftX currentY:leftY isHorizontal:isHorizontal lineInfo:lineInfo];
    
    if (index >= self.connectorLines.converterLines.count)
    {
        // Append new line to end
        [self.connectorLines addConverterLine:lineInfo];
    }
    else
    {
        // Line already exists so replace instead
        [self.connectorLines replaceConverterLine:lineInfo index:index];
    }
}

-(void)pressGridButtonWithColor:(UIButton *)button :(int)selectedColor doAnimate:(bool)doAnimate doSound:(bool)doSound;
{
    if (doSound)
    {
        // Play sound:
        [[SoundManager sharedManager] playSound:@"circleFill.mp3" looping:NO];
    }
    
    NSNumber* wrappedSelectedColor = [NSNumber numberWithInt:selectedColor];
    
    // Update grid color button state
    // Find the grid button that was clicked
    GridColorButton* gridColorButtonClicked = [self getGridColorButtonFromButton:button];
    
    // Collect the list of UIViews affected by this action, that we should animate
    NSMutableArray* viewsToAnimate = [[NSMutableArray alloc] init];
    [viewsToAnimate addObject:gridColorButtonClicked.button];
    
    // Get the index of the grid button clicked
    NSInteger topIndex = [self.topGridColorButtons indexOfObject:gridColorButtonClicked];
    NSInteger leftIndex = [self.leftGridColorButtons indexOfObject:gridColorButtonClicked];
    
    // Remove color of the previous state of the grid button
    if (gridColorButtonClicked.hasInputColorFromUser)
    {
        int previousColor = gridColorButtonClicked.color.intValue;
        if (topIndex != NSNotFound)
        {
            [self removeColorForColumn:previousColor colIndex:(int)topIndex cellsAffected:NULL];
        }
        else
        {
            [self removeColorForRow:previousColor rowIndex:(int)leftIndex cellsAffected:NULL];
        }
    }
    
    // Set grid button to new color
    [gridColorButtonClicked setColor:wrappedSelectedColor isUserInput:true];
    
    // Get new color of connecting line
    UIColor *color = [CommonUtils GetUIColorForColor:selectedColor];
    
    // Update vertical or horizontal line
    if (topIndex != NSNotFound)
    {
        [self.connectorLines updateLine:topIndex isHorizontal:false color:color];
    }
    else
    {
        [self.connectorLines updateLine:leftIndex isHorizontal:true color:color];
    }
    
    // Update current color states
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
    
    // Add new color
    if (topIndex != NSNotFound)
    {
        [self addColorForColumn:selectedColor colIndex:topIndex cellsAffected:viewsToAnimate];
    }
    else
    {
        [self addColorForRow:selectedColor rowIndex:leftIndex cellsAffected:viewsToAnimate];
    }
    
    if (doAnimate)
    {
        [CommonUtils AnimateViewsAffected:viewsToAnimate];
    }
}

-(GridColorButton*)getGridColorButtonFromButton:(UIButton*)button
{
    // Find the grid button from button
    for (GridColorButton* gridColorButton in _allGridColorButtons)
    {
        if (gridColorButton.button == button)
        {
            return gridColorButton;
        }
    }
    
    return NULL;
}

- (void)initGridColorButtons
{
    _allGridColorButtons = [[NSMutableArray alloc] init];
    _topGridColorButtons = [[NSMutableArray alloc] init];
    _leftGridColorButtons = [[NSMutableArray alloc] init];
    
    // Color cell start 1 cell away from the left, so the xOffset is calculated by offset of the first column + 1 cellspacing
    int cellSizePlusSpace = self.boardParameters.colorCellSize + self.boardParameters.colorCellSpacing;
    int xOffset = self.boardParameters.xOffsetForFirstLeftGridButton + cellSizePlusSpace + self.boardParameters.xAdjustmentForColorCells;
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

-(void)adjustGridColorButtons
{
    NSArray *topButtons = self.topGridColorButtons;
    NSArray *leftButtons = self.leftGridColorButtons;
    NSArray *topRow = [self.colorCellSections objectAtIndex:0];
    for (int i = 0; i < topRow.count; i++)
    {
        ColorCell *colorCell = [topRow objectAtIndex:i];
        if (colorCell.cellType == ReflectorLeftToDown || colorCell.cellType == TransporterOutputDown)
        {
            // If the first cell under a top button is a cell that blocks input,
            // there's no need for a top button so remove it
            GridColorButton *gridColorButton = [topButtons objectAtIndex:i];
            [gridColorButton.button removeFromSuperview];
        }
    }
    
    for (int i = 0; i < leftButtons.count; i++)
    {
        NSArray *row = [self.colorCellSections objectAtIndex:i];
        ColorCell *colorCell = [row objectAtIndex:0];
        if (colorCell.cellType == ReflectorTopToRight || colorCell.cellType == TransporterOutputRight)
        {
            // If the first cell to the right of a left button is a cell that blocks input,
            // there's no need for a left button so remove it
            GridColorButton *gridColorButton = [leftButtons objectAtIndex:i];
            [gridColorButton.button removeFromSuperview];
        }
    }
}

-(void)resetCells
{
    // Clear top color buttons
    for (int i=0; i < _topGridColorButtons.count; i++)
    {
        GridColorButton *gridColorButton = [_topGridColorButtons objectAtIndex:i];
        UIButton *button = gridColorButton.button;
        [self pressGridButtonWithColor:button :0 doAnimate:false doSound:false];
    }
    
    // Clear left color buttons
    for (int i=0; i < _leftGridColorButtons.count; i++)
    {
        GridColorButton *gridColorButton = [_leftGridColorButtons objectAtIndex:i];
        UIButton *button = gridColorButton.button;
        [self pressGridButtonWithColor:button :0 doAnimate:false doSound:false];
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

- (void)removeExistingConnectingLines
{
    [self.connectorLines clear];
    [self.connectorLines removeFromSuperview];
}

- (void)removeExistingBoard
{
    [self removeExistingGridColorButtons];
    [self removeExistingGridCells];
    [self removeExistingConnectingLines];
    [self resetBoardState];
}

- (void)resetBoardState
{
    [self.allConnectorCells removeAllObjects];
    [self.allSplitterCells removeAllObjects];
    [self.allConverterCells removeAllObjects];
    [self.allShifterCells removeAllObjects];
    self.connectorColorInput = 0;
    
    [super resetBoardState];
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

// override base class
-(UIImage*)GetImageForCellType:(ColorCell*)colorCell
{
    switch (colorCell.cellType)
    {
        case ReflectorLeftToDown:
        case ReflectorTopToRight:
        case Diverter:
            return [UIImage imageNamed:@"BlockClear.png"];
            return [UIImage imageNamed:@"BlockClear.png"];
        case Zoner:
            return [UIImage imageNamed:@"zonerWhite@2x.png"];
        case Connector:
            return [UIImage imageNamed:@"connectorOuterWhite@2x.png"];
        case Splitter:
            return [UIImage imageNamed:@"splitterWhite@2x.png"];
        case Converter:
            return [self getConverterImageForColor:0 directionRight:((ConverterCell*)colorCell).isDirectionRight];
        case TransporterInputLeft:
        case TransporterInputTop:
        case TransporterOutputDown:
        case TransporterOutputRight:
            return [self getTransporterImageWithColor:colorCell color:0];
        case Shifter:
            return [self getShifterImage:(ShifterCell*)colorCell];
    }
    
    return [super GetImageForCellType:colorCell];
}

-(void)GetSpecialImageForCellIfNeeded:(ColorCell*)colorCell boardCells:(BoardCells*)boardCells
{
    [self GetSpecialImage1ForCell:colorCell boardCells:boardCells];
    [self GetSpecialImage2ForCell:colorCell boardCells:boardCells];
}

-(void)GetSpecialImage1ForCell:(ColorCell*)colorCell boardCells:(BoardCells*)boardCells
{
    UIImage *specialImage = NULL;
    int x, y, size;
    switch (colorCell.cellType)
    {
        case ReflectorLeftToDown:
        case Diverter:
            specialImage = [UIImage imageNamed:@"ReflectorArrowLtD@2x.png"];
            size = self.boardParameters.reflectorArrowCellSize;
            x = colorCell.image.frame.origin.x + self.boardParameters.reflectorLeftToDownArrowXAdjustment;
            y = colorCell.image.frame.origin.y + self.boardParameters.reflectorLeftToDownArrowYAdjustment;
            break;
            
        case ReflectorTopToRight:
            specialImage = [UIImage imageNamed:@"ReflectorArrowTtR@2x.png"];
            size = self.boardParameters.reflectorArrowCellSize;
            x = colorCell.image.frame.origin.x + self.boardParameters.reflectorTopToRightArrowXAdjustment;
            y = colorCell.image.frame.origin.y + self.boardParameters.reflectorTopToRightArrowYAdjustment;
            break;
        
        case Connector:
            // Initialize to white cell
            specialImage = [CommonUtils GetConnectorInnerImageForColor:0];
            size = colorCell.image.frame.size.width;
            x = colorCell.image.frame.origin.x;
            y = colorCell.image.frame.origin.y;
            break;
            
        case Shifter:
            // Initialize to white cell
            specialImage = [CommonUtils GetShifterInnerImageForColor:0];
            size = colorCell.image.frame.size.width;
            x = colorCell.image.frame.origin.x;
            y = colorCell.image.frame.origin.y;
            break;
            
        case TransporterInputTop:
            specialImage = [UIImage imageNamed:@"ReflectorArrowLtD@2x.png"];
            size = self.boardParameters.transporterArrowSize;
            x = colorCell.image.frame.origin.x + self.boardParameters.transporterArrowDownXAdjustment;
            y = colorCell.image.frame.origin.y + self.boardParameters.transporterArrowDownYAdjustment;
            break;
        
        case TransporterOutputRight:
            specialImage = [UIImage imageNamed:@"ReflectorArrowTtR@2x.png"];
            size = self.boardParameters.transporterArrowSize;
            x = colorCell.image.frame.origin.x + self.boardParameters.transporterArrowRightXAdjustment;
            y = colorCell.image.frame.origin.y + self.boardParameters.transporterArrowRightYAdjustment;
            break;
            
        case TransporterInputLeft:
            specialImage = [UIImage imageNamed:@"ReflectorArrowTtR@2x.png"];
            size = self.boardParameters.transporterArrowSize;
            x = colorCell.image.frame.origin.x + self.boardParameters.transporterArrowRightXAdjustment2;
            y = colorCell.image.frame.origin.y + self.boardParameters.transporterArrowRightYAdjustment;
            break;
            
        case TransporterOutputDown:
            specialImage = [UIImage imageNamed:@"ReflectorArrowLtD@2x.png"];
            size = self.boardParameters.transporterArrowSize;
            x = colorCell.image.frame.origin.x + self.boardParameters.transporterArrowDownXAdjustment;
            y = colorCell.image.frame.origin.y + self.boardParameters.transporterArrowDownYAdjustment2;
            break;
            break;
            
        default:
            // No special cell needed
            return;
    }
    
    UIImageView *specialImageView = [[UIImageView alloc] initWithFrame:CGRectMake(x, y, size, size)];
    
    specialImageView.image = specialImage;
    colorCell.specialImage = specialImageView;
    [self.containerView addSubview:specialImageView];
}

-(void)GetSpecialImage2ForCell:(ColorCell*)colorCell boardCells:(BoardCells*)boardCells
{
    UIImage *specialImage = NULL;
    int x, y, size;
    switch (colorCell.cellType)
    {
        case Diverter:
            specialImage = [UIImage imageNamed:@"ReflectorArrowTtR@2x.png"];
            size = self.boardParameters.reflectorArrowCellSize;
            x = colorCell.image.frame.origin.x + self.boardParameters.reflectorTopToRightArrowXAdjustment;
            y = colorCell.image.frame.origin.y + self.boardParameters.reflectorTopToRightArrowYAdjustment;
            break;
        default:
            // No special cell needed
            return;
    }
    
    UIImageView *specialImageView = [[UIImageView alloc] initWithFrame:CGRectMake(x, y, size, size)];
    
    specialImageView.image = specialImage;
    colorCell.specialImage2 = specialImageView;
    [self.containerView addSubview:specialImageView];
}

-(UIImage*)updateSpecialImageForCellWithColor:(ColorCell*)colorCell color:(int)color isHorizontal:(BOOL)isHorizontal
{
    CellType cellType = colorCell.cellType;
    switch (cellType)
    {
        case ReflectorLeftToDown:
            return [self getArrowLtDWithColor:colorCell.currentColor];
        case Diverter:
            if (isHorizontal)
            {
                return [self getArrowLtDWithColor:((DiverterCell*)colorCell).leftToDownLine.currentColor];
            }
            else
            {
                return NULL;
            }
        case TransporterInputTop:
        case TransporterOutputDown:
            return [self getArrowLtDWithColor:color];
        case ReflectorTopToRight:
            return [self getArrowTtRWithColor:colorCell.currentColor];
        case TransporterInputLeft:
        case TransporterOutputRight:
            return [self getArrowTtRWithColor:color];
        default:
            return NULL;
    }
}

-(UIImage*)updateSpecialImage2ForCellWithColor:(ColorCell*)colorCell color:(int)color isHorizontal:(BOOL)isHorizontal
{
    CellType cellType = colorCell.cellType;
    if (cellType == Diverter && !isHorizontal)
    {
        return [self getArrowTtRWithColor:((DiverterCell*)colorCell).topToRightLine.currentColor];
    }
    
    return NULL;
}

-(UIImage*)getArrowLtDWithColor:(int)color
{
    switch (color)
    {
        case 0:
            return [UIImage imageNamed:@"ReflectorArrowLtD@2x.png"];
            break;
        case 1:
            return [UIImage imageNamed:@"ReflectorArrowLtDBlue@2x.png"];
            break;
        case 2:
            return [UIImage imageNamed:@"ReflectorArrowLtDRed@2x.png"];
            break;
        case 3:
            return [UIImage imageNamed:@"ReflectorArrowLtDYellow@2x.png"];
            break;
        case 4:
            return [UIImage imageNamed:@"ReflectorArrowLtDPurple@2x.png"];
            break;
        case 5:
            return [UIImage imageNamed:@"ReflectorArrowLtDGreen@2x.png"];
            break;
        case 6:
            return [UIImage imageNamed:@"ReflectorArrowLtDOrange@2x.png"];
            break;
        case 7:
            return [UIImage imageNamed:@"ReflectorArrowLtDBrown@2x.png"];
            break;
        default:
            [NSException raise:@"Invalid input" format:@"Invalid input color"];
            break;
    }
    
    return NULL;
}

-(UIImage*)getArrowTtRWithColor:(int)color
{
    switch (color)
    {
        case 0:
            return [UIImage imageNamed:@"ReflectorArrowTtR@2x.png"];
            break;
        case 1:
            return [UIImage imageNamed:@"ReflectorArrowTtRBlue@2x.png"];
            break;
        case 2:
            return [UIImage imageNamed:@"ReflectorArrowTtRRed@2x.png"];
            break;
        case 3:
            return [UIImage imageNamed:@"ReflectorArrowTtRYellow@2x.png"];
            break;
        case 4:
            return [UIImage imageNamed:@"ReflectorArrowTtRPurple@2x.png"];
            break;
        case 5:
            return [UIImage imageNamed:@"ReflectorArrowTtRGreen@2x.png"];
            break;
        case 6:
            return [UIImage imageNamed:@"ReflectorArrowTtROrange@2x.png"];
            break;
        case 7:
            return [UIImage imageNamed:@"ReflectorArrowTtRBrown@2x.png"];
            break;
        default:
            [NSException raise:@"Invalid input" format:@"Invalid input color"];
            break;
    }
    
    return NULL;
}

-(UIView*)getUIViewForCell:(int)cellType xOffset:(int)xOffset yOffset:(int)yOffset size:(int)size colorCell:(ColorCell*)colorCell
{
    if (cellType == Zoner)
    {
        ZonerCellButton* cellBlock = [[ZonerCellButton alloc] initWithFrame:CGRectMake(xOffset, yOffset, size, size)];
        cellBlock.colorCell = (ZonerCell*)colorCell;
        [cellBlock setImage:[self GetImageForCellType:colorCell] forState:UIControlStateNormal];
        
        [cellBlock addTarget:self.viewController.mainGameManager action:@selector(zonerCellPressed:) forControlEvents:UIControlEventTouchUpInside];
        
        return cellBlock;
    }
    else if (cellType == Connector)
    {
        UIButton* connectorButton = [[UIButton alloc] initWithFrame:CGRectMake(xOffset, yOffset, size, size)];
        [connectorButton setImage:[self GetImageForCellType:colorCell] forState:UIControlStateNormal];
        
        [connectorButton addTarget:self.viewController.mainGameManager action:@selector(connectorCellPressed:) forControlEvents:UIControlEventTouchUpInside];
        
        ((ConnectorCell*)colorCell).button = connectorButton;
        [self.allConnectorCells addObject:colorCell];
        
        return connectorButton;
    }
    else if (cellType == Splitter)
    {
        SplitterCellButton* splitterButton = [[SplitterCellButton alloc] initWithFrame:CGRectMake(xOffset, yOffset, size, size)];
        [splitterButton setImage:[self GetImageForCellType:colorCell] forState:UIControlStateNormal];
        splitterButton.splitterCell = (SplitterCell*)colorCell;
        [self.allSplitterCells addObject:colorCell];
        
        [splitterButton addTarget:self.viewController.mainGameManager action:@selector(splitterButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        
        return splitterButton;
    }
    else if (cellType == Converter)
    {
        ConverterCell* converterCell = (ConverterCell*)colorCell;
        converterCell.isDirectionRight = [self.boardCells getConverterInitialDirectionAt:converterCell.row col:converterCell.col] == 1;
        ConverterCellButton* converterButton = [[ConverterCellButton alloc] initWithFrame:CGRectMake(xOffset, yOffset, size, size)];
        [converterButton setImage:[self GetImageForCellType:colorCell] forState:UIControlStateNormal];
        converterButton.converterCell = converterCell;
        converterCell.converterButton = converterButton;
        [self.allConverterCells addObject:converterCell];
        
        [converterButton addTarget:self.viewController.mainGameManager action:@selector(converterButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        
        return converterButton;
    }
    else if (cellType == Shifter)
    {
        UIButton* shifterButton = [[UIButton alloc] initWithFrame:CGRectMake(xOffset, yOffset, size, size)];
        [shifterButton setImage:[self GetImageForCellType:colorCell] forState:UIControlStateNormal];
        
        [shifterButton addTarget:self.viewController.mainGameManager action:@selector(shifterCellPressed:) forControlEvents:UIControlEventTouchUpInside];
        
        ((ShifterCell*)colorCell).button = shifterButton;
        [self.allShifterCells addObject:colorCell];
        
        return shifterButton;
    }
    else
    {
        return [super getUIViewForCell:cellType xOffset:xOffset yOffset:yOffset size:size colorCell:colorCell];
    }
}

- (IBAction)shifterCellPressed:(id)sender
{
    // Play sound:
    [[SoundManager sharedManager] playSound:@"shifterSFX.mp3" looping:NO];
    
    // Collect views to animate
    NSMutableArray* viewsToAnimate = [[NSMutableArray alloc] init];
    for (ShifterCell* colorCell in self.allShifterCells)
    {
        // Remove existing outer color
        [self applySpecialCell:colorCell isAdd:false cellsAffected:NULL];
        
        // Set and apply new outer color
        colorCell.outerColor = [self shiftColor:colorCell.outerColor backwards:false shiftCount:1];
        [self applySpecialCell:colorCell isAdd:true cellsAffected:viewsToAnimate];
        
        // Update the outer color
        UIImage* newConnectorImage = [self getShifterImage:colorCell];
        UIButton* connectorButton = (UIButton*)colorCell.image;
        [connectorButton setImage:newConnectorImage forState:UIControlStateNormal];
    }
    
    // Do animation
    [CommonUtils AnimateViewsAffected:viewsToAnimate];
    
    [self.viewController OnUserActionTaken];
}

- (IBAction)converterButtonPressed:(id)sender
{
    // Play sound:
    [[SoundManager sharedManager] playSound:@"converterSFX.mp3" looping:NO];
    
    ConverterCellButton* converterButton = (ConverterCellButton*)sender;
    ConverterCell* converterCell = converterButton.converterCell;
    
    bool isDirectionRight = converterCell.isDirectionRight;
    isDirectionRight = !isDirectionRight;
    converterCell.isDirectionRight = isDirectionRight;
    
    int newColorToApply = isDirectionRight ? converterCell.horizontalColorInput : converterCell.verticalColorInput;
    
    // Collect views to animate
    NSMutableArray* viewsToAnimate = [[NSMutableArray alloc] init];
    [viewsToAnimate addObject:converterButton];
    
    // Replace previous converter line
    int lineIndex = [self.allConverterCells indexOfObject:converterCell];
    [self DrawSingleConverterLine:converterCell index:lineIndex];
    [self.connectorLines updateConverterLine:lineIndex color:[CommonUtils GetUIColorForColor:newColorToApply]];
    
    // Remove color from current direction
    int oldColorToRemove = isDirectionRight ? converterCell.verticalColorInput : converterCell.horizontalColorInput;
    if (oldColorToRemove != 0)
    {
        [self applyColor:converterCell.row currentCol:converterCell.col isHorizontal:!isDirectionRight color:oldColorToRemove isAdd:false cellsAffected:viewsToAnimate];
    }
    
    converterCell.lineColor = newColorToApply;
    UIImage* newConverterImage = [self getConverterImageForColor:converterCell.lineColor directionRight:isDirectionRight];
    [converterButton setImage:newConverterImage forState:UIControlStateNormal];
    
    // Apply color in new direction
    [self applyColor:converterCell.row currentCol:converterCell.col isHorizontal:isDirectionRight color:newColorToApply isAdd:true cellsAffected:viewsToAnimate];
    
    // Do animation
    [CommonUtils AnimateViewsAffected:viewsToAnimate];
    
    [self.viewController OnUserActionTaken];
}

- (IBAction)splitterButtonPressed:(id)sender
{
    SplitterCellButton* splitterButton = (SplitterCellButton*)sender;
    
    int currentSelectedColor = (int)self.viewController.mainGameManager.selectedColor;
    int existingInputColor = splitterButton.splitterCell.inputColor;
    if (existingInputColor == currentSelectedColor)
    {
        // Do nothing if color didn't change
        return;
    }
    
    // Play sound:
    [[SoundManager sharedManager] playSound:@"splitterSFX.mp3" looping:NO];
    
    // Collect views to animate
    NSMutableArray* viewsToAnimate = [[NSMutableArray alloc] init];
    [viewsToAnimate addObject:splitterButton];
    
    UIImage* newSplitterImage;
    switch (currentSelectedColor)
    {
        case 0:
            newSplitterImage = [UIImage imageNamed:@"splitterWhite@2x.png"];
            break;
        case 1:
            newSplitterImage = [UIImage imageNamed:@"splitterBlue@2x.png"];
            break;
        case 2:
            newSplitterImage = [UIImage imageNamed:@"splitterRed@2x.png"];
            break;
        case 3:
            newSplitterImage = [UIImage imageNamed:@"splitterYellow@2x.png"];
            break;
    }
    
    [splitterButton setImage:newSplitterImage forState:UIControlStateNormal];
    
    if (existingInputColor != 0)
    {
        [self applySpecialCell:splitterButton.splitterCell isAdd:false cellsAffected:NULL];
    }
    
    ((SplitterCell*)splitterButton.splitterCell).inputColor = currentSelectedColor;
    [self applySpecialCell:splitterButton.splitterCell isAdd:true cellsAffected:viewsToAnimate];
    
    // Do animation
    [CommonUtils AnimateViewsAffected:viewsToAnimate];
    
    [self.viewController OnUserActionTaken];
}

- (IBAction)zonerCellPressed:(id)sender
{
    ZonerCellButton* zonerCellButton = (ZonerCellButton*)sender;
    
    int currentSelectedColor = (int)self.viewController.mainGameManager.selectedColor;
    int existingInputColor = ((ZonerCell*)zonerCellButton.colorCell).inputColor;
    if (existingInputColor == currentSelectedColor)
    {
        // Do nothing if color didn't change
        return;
    }
    
    // Play sound:
    [[SoundManager sharedManager] playSound:@"zonerSFX.mp3" looping:NO];
    
    // Collect views to animate
    NSMutableArray* viewsToAnimate = [[NSMutableArray alloc] init];
    [viewsToAnimate addObject:zonerCellButton];
    
    UIImage* newZonerImage;
    switch (currentSelectedColor)
    {
        case 0:
            newZonerImage = [UIImage imageNamed:@"zonerWhite@2x.png"];
            break;
        case 1:
            newZonerImage = [UIImage imageNamed:@"zonerBlue@2x.png"];
            break;
        case 2:
            newZonerImage = [UIImage imageNamed:@"zonerRed@2x.png"];
            break;
        case 3:
            newZonerImage = [UIImage imageNamed:@"zonerYellow@2x.png"];
            break;
    }
    
    [zonerCellButton setImage:newZonerImage forState:UIControlStateNormal];
    
    if (existingInputColor != 0)
    {
        [self applySpecialCell:zonerCellButton.colorCell isAdd:false cellsAffected:NULL];
    }
    
    ((ZonerCell*)zonerCellButton.colorCell).inputColor = currentSelectedColor;
    [self applySpecialCell:zonerCellButton.colorCell isAdd:true cellsAffected:viewsToAnimate];
    
    // Do animation
    [CommonUtils AnimateViewsAffected:viewsToAnimate];
    
    [self.viewController OnUserActionTaken];
}

- (IBAction)connectorCellPressed:(id)sender
{
    int currentSelectedColor = (int)self.viewController.mainGameManager.selectedColor;
    
    // Collect views to animate
    NSMutableArray* viewsToAnimate = [[NSMutableArray alloc] init];
    for (ConnectorCell* colorCell in self.allConnectorCells)
    {
        if (colorCell.inputColor == currentSelectedColor)
        {
            // Do nothing if color didn't change
            return;
        }
        
        // Remove existing connector input
        [self applySpecialCell:colorCell isAdd:false cellsAffected:NULL];
        
        // Add new connector input
        self.connectorColorInput = currentSelectedColor;
        colorCell.inputColor = currentSelectedColor;
        [self applySpecialCell:colorCell isAdd:true cellsAffected:viewsToAnimate];
        
        // Update the outer color
        UIImage* newConnectorImage = [CommonUtils GetConnectorOuterImageForColor:currentSelectedColor];
        UIButton* connectorButton = (UIButton*)colorCell.image;
        [connectorButton setImage:newConnectorImage forState:UIControlStateNormal];
    }
    
    // Play sound:
    [[SoundManager sharedManager] playSound:@"connectorSFX.mp3" looping:NO];
    
    // Do animation
    [CommonUtils AnimateViewsAffected:viewsToAnimate];
    
    [self.viewController OnUserActionTaken];
}

-(void)updateTransporterOutputCell:(TransporterCell*)outputCell transporterGroup:(TransporterGroup*)transporterGroup cellsAffected:(NSMutableArray*)cellsAffected
{
    // Change transporter input image
    [outputCell.image setImage:[self getTransporterImageWithColor:outputCell color:transporterGroup.currentColor]];
    
    // Change special image, direction doesn't matter
    [self updateSpecialCellImagesOnApplyColor:outputCell color:transporterGroup.currentColor isHorizontal:true cellsAffected:cellsAffected];
    
    [self.connectorLines updateTransporterLine:outputCell.groupId                                       color:[CommonUtils GetUIColorForColor:transporterGroup.currentColor]];
}

-(void)OnApplyColorOnConverterCell:(ConverterCell*)converterCell color:(int)color isHorizontal:(BOOL)isHorizontal
{
    int lineIndex = [self.allConverterCells indexOfObject:converterCell];
    
    if (isHorizontal == converterCell.isDirectionRight)
    {
        [self.connectorLines updateConverterLine:lineIndex color:[CommonUtils GetUIColorForColor:color]];
        converterCell.lineColor = color;
        
        UIImage* newConverterImage = [self getConverterImageForColor:color directionRight:converterCell.isDirectionRight];
        
        [converterCell.converterButton setImage:newConverterImage forState:UIControlStateNormal];
    }
    
    if (isHorizontal)
    {
        converterCell.horizontalColorInput = color;
    }
    else
    {
        converterCell.verticalColorInput = color;
    }
}

-(UIImage*)getConverterImageForColor:(int)color directionRight:(int)directionright
{
    switch (color)
    {
        case 0:
            return directionright ?
                [UIImage imageNamed:@"converterLeftToRightWhite@2x.png"] :
                [UIImage imageNamed:@"converterTopToDownWhite@2x.png"];
            break;
        case 1:
            return directionright ?
                [UIImage imageNamed:@"converterLeftToRightBlue@2x.png"] :
                [UIImage imageNamed:@"converterTopToDownBlue@2x.png"];
            break;
        case 2:
            return directionright ?
                [UIImage imageNamed:@"converterLeftToRightRed@2x.png"] :
                [UIImage imageNamed:@"converterTopToDownRed@2x.png"];
            break;
        case 3:
            return directionright ?
                [UIImage imageNamed:@"converterLeftToRightYellow@2x.png"] :
                [UIImage imageNamed:@"converterTopToDownYellow@2x.png"];
            break;
    }
    
    // Should not be hit
    return NULL;
}

-(UIImage*)getShifterImage:(ShifterCell*)shifterCell
{
    switch (shifterCell.outerColor)
    {
        case 1:
            return [UIImage imageNamed:@"shifterOuterBlue@2x.png"];
            break;
        case 2:
            return [UIImage imageNamed:@"shifterOuterRed@2x.png"];
            break;
        case 3:
            return [UIImage imageNamed:@"shifterOuterYellow@2x.png"];
            break;
    }
    
    // Should not be hit
    return NULL;
}

-(ShifterCell*)createShifterCell:(int)cellType row:(int)row col:(int)col boardCells:(BoardCells*)boardCells
{
    ShifterCell* shifterCell = [[ShifterCell alloc] init:cellType];
    int finalColor = [boardCells getShifterValueAt:row col:col];
    shifterCell.outerColor = [self shiftColor:finalColor backwards:true shiftCount:boardCells.shiftCount];
    return shifterCell;
}

@end
