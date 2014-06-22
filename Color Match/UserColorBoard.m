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

@interface UserColorBoard ()
@property MainGameViewController *viewController;
@property NSMutableArray *allGridColorButtons;
@property ConnectorLines *connectorLines;
@property NSMutableArray *allConnectorCells;
@property int connectorColorInput;
@end

@implementation UserColorBoard

-(id)initWithParameters:
    (BoardParameters)boardParameters
    containerView:(UIView*)containerView
    viewController:(MainGameViewController*)viewController
    boardCells:(BoardCells*) boardCells
{
    self = [super init];
    if (self)
    {
        self.boardParameters = boardParameters;
        self.containerView = containerView;
        self.boardCells = boardCells;
        _viewController = viewController;
        self.allConnectorCells = [[NSMutableArray alloc] init];
        self.connectorColorInput = 0;
        
        [self createNewBoard];
    }
    
    return self;
}

- (void)createNewBoard
{
    [self initGridColorButtons];
    [self initColorCells];
    
    // Draw connecting lines
    [self CreateConnectorLinesFrame];
    [self DrawVerticalConnectingLines];
    [self DrawHorizontalConnectingLines];
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
        int topX = topConnection.frame.origin.x + topConnection.frame.size.width / 2;
        
        // Draw the line
        LineInfo *lineInfo = [[LineInfo alloc] init];
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
        
        int leftY = leftConnection.frame.origin.y + leftConnection.frame.size.height / 2;
        int leftAdjustment = -1 * (self.boardParameters.emptyPaddingInGridButton);   // Accounts for extra spacing in left button
        int leftX = leftConnection.frame.origin.x + leftConnection.frame.size.width + leftAdjustment;
        
        // Draw the line
        LineInfo *lineInfo = [[LineInfo alloc] init];
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
            if (colorCell.cellType == ReflectorLeftToDown)
            {
                // Draw line to reflector
                int rightX = [self DrawHorizontalLineToConnection:colorCell lineInfo:lineInfo currentY:currentY drawToCenter:true];
                
                // Trigger drawing to next connection vertically
                [self DrawLineToNextConnectionPoint:currentRow currentCol:i currentX:rightX currentY:currentY isHorizontal:false lineInfo:lineInfo];
                
                connectionFound = true;
                break;
            }
            else if (colorCell.cellType == ReflectorTopToRight)
            {
                if (i > currentCol + 1)
                {
                    // Draw line to cell before the reflector
                    ColorCell *colorCell = [row objectAtIndex:i-1];
                    [self DrawHorizontalLineToConnection:colorCell lineInfo:lineInfo currentY:currentY drawToCenter:true];
                }
        
                connectionFound = true;
                break;
            }
        }
        
        if (!connectionFound)
        {
            // If no special connection found, then the connection is to the right most cell
            ColorCell *colorCell = [row objectAtIndex:row.count - 1];
            [self DrawHorizontalLineToConnection:colorCell lineInfo:lineInfo currentY:currentY drawToCenter:false];
        }
    }
    else    // if vertical
    {
        bool connectionFound = false;
        for (int i=currentRow+1; i<self.colorCellSections.count; i++)
        {
            NSArray *row = [self.colorCellSections objectAtIndex:i];
            ColorCell *colorCell = [row objectAtIndex:currentCol];
            
            if (colorCell.cellType == ReflectorLeftToDown)
            {
                if (i > currentRow + 1)
                {
                    // Draw line to cell before the reflector
                    NSArray *row = [self.colorCellSections objectAtIndex:i-1];
                    ColorCell *colorCell = [row objectAtIndex:currentCol];
                    [self DrawVerticalLineToConnection:colorCell lineInfo:lineInfo currentX:currentX drawToCenter:true];
                }
                 
                connectionFound = true;
                break;
            }
            else if (colorCell.cellType == ReflectorTopToRight)
            {
                // Draw line to reflector
                int bottomY = [self DrawVerticalLineToConnection:colorCell lineInfo:lineInfo currentX:currentX drawToCenter:true];
                
                // Trigger drawing to next connection horizontally
                [self DrawLineToNextConnectionPoint:i currentCol:currentCol currentX:   currentX currentY:bottomY isHorizontal:true lineInfo:lineInfo];
                
                connectionFound = true;
                break;
            }
        }
        
        if (!connectionFound)
        {
            // If no special connection found, then the connection is to the bottom most cell
            NSArray *row = [self.colorCellSections objectAtIndex:self.colorCellSections.count - 1];
            ColorCell *colorCell = [row objectAtIndex:currentCol];
            [self DrawVerticalLineToConnection:colorCell lineInfo:lineInfo currentX:currentX drawToCenter:false];
        }
    }
}

-(int)DrawHorizontalLineToConnection:(ColorCell*)connection lineInfo:(LineInfo*)lineInfo currentY:(int)currentY drawToCenter:(BOOL)drawToCenter
{
    UIView *rightConnection = [connection image];
    int rightAdjustment = 3;   // Accounts for extra spacing in right button
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
    [lineInfo addLinePiece:linePiece];
    
    return rightX;
}

-(int)DrawVerticalLineToConnection:(ColorCell*)connection lineInfo:(LineInfo*)lineInfo currentX:(int)currentX drawToCenter:(BOOL)drawToCenter
{
    UIView *bottomConnection = [connection image];
    int bottomAdjustment = 3;   // Accounts for extra spacing in bottom button
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
    [lineInfo addLinePiece:linePiece];
    
    return bottomY;
}

-(void)pressGridButtonWithColor:(UIButton *)button :(int)selectedColor
{
    NSNumber* wrappedSelectedColor = [NSNumber numberWithInt:selectedColor];
    
    // Update grid color button state
    // Find the grid button that was clicked
    GridColorButton* gridColorButtonClicked;
    for (GridColorButton* gridColorButton in _allGridColorButtons)
    {
        if (gridColorButton.button == button)
        {
            gridColorButtonClicked = gridColorButton;
            break;
        }
    }
    
    // Get the index of the grid button clicked
    NSInteger topIndex = [self.topGridColorButtons indexOfObject:gridColorButtonClicked];
    NSInteger leftIndex = [self.leftGridColorButtons indexOfObject:gridColorButtonClicked];
    
    // Remove color of the previous state of the grid button
    if (gridColorButtonClicked.hasInputColorFromUser)
    {
        int previousColor = gridColorButtonClicked.color.intValue;
        if (topIndex != NSNotFound)
        {
            [self removeColorForColumn:previousColor colIndex:topIndex];
        }
        else
        {
            [self removeColorForRow:previousColor rowIndex:leftIndex];
        }
    }
    
    // Set grid button to new color
    [gridColorButtonClicked setColor:wrappedSelectedColor isUserInput:true];
    
    // Get new color of connecting line
    UIColor *color;
    if (selectedColor == 0)
    {
        color = [CommonUtils GetGrayColor];
    }
    else if (selectedColor == 1)
    {
        color = [CommonUtils GetBlueColor];
    }
    else if (selectedColor == 2)
    {
        color = [CommonUtils GetRedColor];
    }
    else if (selectedColor == 3)
    {
        color = [CommonUtils GetYellowColor];
    }
    
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
        [self addColorForColumn:selectedColor colIndex:topIndex];
    }
    else
    {
        [self addColorForRow:selectedColor rowIndex:leftIndex];
    }
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
            ColorCell *colorCell = [row objectAtIndex:j];
            UIView *cellBlock = [colorCell image];
            [cellBlock removeFromSuperview];
            
            if (colorCell.specialImage != NULL)
            {
                UIImageView *specialImageCell = colorCell.specialImage;
                [specialImageCell removeFromSuperview];
            }
        }
        
        [row removeAllObjects];
    }
    
    [self.colorCellSections removeAllObjects];
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
-(UIImage*)GetImageForCellType:(int)cellType
{
    switch (cellType)
    {
        case ReflectorLeftToDown:
            return [UIImage imageNamed:@"BlockClear.png"];
        case ReflectorTopToRight:
            return [UIImage imageNamed:@"BlockClear.png"];
        case Zoner:
            return [UIImage imageNamed:@"zonerWhite@2x.png"];
        case Connector:
            return [UIImage imageNamed:@"connectorOuterWhite@2x.png"];
    }
    
    return [super GetImageForCellType:cellType];
}

-(void)GetSpecialImageForCellIfNeeded:(ColorCell*)colorCell boardCells:(BoardCells*)boardCells
{
    UIImage *specialImage = NULL;
    
    switch (colorCell.cellType)
    {
        case ReflectorLeftToDown:
            specialImage = [UIImage imageNamed:@"ReflectorArrowLtD@2x.png"];
            break;
        case ReflectorTopToRight:
            specialImage = [UIImage imageNamed:@"ReflectorArrowTtR@2x.png"];
            break;
        case Connector:
            // Initialize to white cell
            specialImage = [CommonUtils GetConnectorInnerImageForColor:0];
            break;
    }
    
    if (specialImage != NULL)
    {
        int x, y, size;
        
        if (colorCell.cellType == ReflectorLeftToDown || colorCell.cellType == ReflectorTopToRight)
        {
            // Fix width for now for all layouts so arrows look consistent
            size = 35;
            int adjustmentX = [self getXAdjustmentForSpecialCell:colorCell.cellType];
            int adjustmentY = [self getYAdjustmentForSpecialCell:colorCell.cellType];
            
            x = colorCell.image.frame.origin.x + adjustmentX;
            y = colorCell.image.frame.origin.y + adjustmentY;
        }
        else
        {
            size = colorCell.image.frame.size.width;
            x = colorCell.image.frame.origin.x;
            y = colorCell.image.frame.origin.y;
        }
        
        UIImageView *specialImageView = [[UIImageView alloc] initWithFrame:CGRectMake(x, y, size, size)];
        
        specialImageView.image = specialImage;
        colorCell.specialImage = specialImageView;
        [self.containerView addSubview:specialImageView];
    }
}

-(int)getXAdjustmentForSpecialCell:(int)cellType
{
    switch (cellType)
    {
        case ReflectorLeftToDown:
            if (self.boardParameters.gridSize == 4)
            {
                return 3;
            }
            else if (self.boardParameters.gridSize == 3)
            {
                return 8;
            }
            break;
        case ReflectorTopToRight:
            if (self.boardParameters.gridSize == 5)
            {
                return 2;
            }
            else if (self.boardParameters.gridSize == 4)
            {
                return 4;
            }
            else if (self.boardParameters.gridSize == 3)
            {
                return 12;
            }
            break;
    }
    
    return 0;
}

-(int)getYAdjustmentForSpecialCell:(int)cellType
{
    switch (cellType)
    {
        case ReflectorLeftToDown:
            if (self.boardParameters.gridSize == 5)
            {
                return 2;
            }
            else if (self.boardParameters.gridSize == 4)
            {
                return 4;
            }
            else if (self.boardParameters.gridSize == 3)
            {
                return 12;
            }
        case ReflectorTopToRight:
            if (self.boardParameters.gridSize == 4)
            {
                return 3;
            }
            else if (self.boardParameters.gridSize == 3)
            {
                return 8;
            }
            break;
    }
    
    return 0;
}

-(UIView*)getUIViewForCell:(int)cellType xOffset:(int)xOffset yOffset:(int)yOffset size:(int)size colorCell:(ColorCell*)colorCell
{
    if (cellType == Zoner)
    {
        ZonerCellButton* cellBlock = [[ZonerCellButton alloc] initWithFrame:CGRectMake(xOffset, yOffset, size, size)];
        cellBlock.colorCell = colorCell;
        [cellBlock setImage:[self GetImageForCellType:cellType] forState:UIControlStateNormal];
        
        [cellBlock addTarget:self action:@selector(zonerCellPressed:) forControlEvents:UIControlEventTouchUpInside];
        
        return cellBlock;
    }
    else if (cellType == Connector)
    {
        UIButton* connectorButton = [[UIButton alloc] initWithFrame:CGRectMake(xOffset, yOffset, size, size)];
        [connectorButton setImage:[self GetImageForCellType:cellType] forState:UIControlStateNormal];
        
        [connectorButton addTarget:self action:@selector(connectorCellPressed:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.allConnectorCells addObject:colorCell];
        
        return connectorButton;
    }
    else
    {
        return [super getUIViewForCell:cellType xOffset:xOffset yOffset:yOffset size:size colorCell:colorCell];
    }
}

- (IBAction)zonerCellPressed:(id)sender
{
    int currentSelectedColor = (int)self.viewController.selectedColor;
    ZonerCellButton* zonerCellButton = (ZonerCellButton*)sender;
    
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
    
    int existingInputColor = ((ZonerCell*)zonerCellButton.colorCell).inputColor;
    if (existingInputColor != 0)
    {
        [self applySpecialCell:zonerCellButton.colorCell isAdd:false];
    }
    
    ((ZonerCell*)zonerCellButton.colorCell).inputColor = currentSelectedColor;
    [self applySpecialCell:zonerCellButton.colorCell isAdd:true];
    
    // User action was taken so we need to check for victory
    [self.viewController checkAndDoVictory];
}

- (IBAction)connectorCellPressed:(id)sender
{
    int currentSelectedColor = (int)self.viewController.selectedColor;
    
    for (ConnectorCell* colorCell in self.allConnectorCells)
    {
        // Remove existing connector input
        [self applySpecialCell:colorCell isAdd:false];
        
        // Add new connector input
        self.connectorColorInput = currentSelectedColor;
        colorCell.inputColor = currentSelectedColor;
        [self applySpecialCell:colorCell isAdd:true];
        
        // TODO: lindach
        // Update the outer color
        UIImage* newConnectorImage = [CommonUtils GetConnectorOuterImageForColor:currentSelectedColor];
        [colorCell setImage:(UIView*)newConnectorImage];
    }
    
    // User action was taken so we need to check for victory
    [self.viewController checkAndDoVictory];
}

@end
