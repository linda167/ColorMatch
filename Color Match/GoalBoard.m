//
//  GoalBoard.m
//  Color Match
//
//  Created by Linda Chen on 1/11/14.
//  Copyright (c) 2014 SunSpark Entertainment. All rights reserved.
//

#import "GoalBoard.h"
#import "ColorCell.h"
#import "BoardCells.h"

@interface GoalBoard ()
@end

@implementation GoalBoard

-(id)initWithParameters:(BoardParameters)boardParameters containerView:(UIView*)containerView
{
    self = [super init];
    if (self)
    {
        self.boardParameters = boardParameters;
        self.containerView = containerView;
     
        // Init board cell types
        _boardCells = [[BoardCells alloc] initWithParameters:(boardParameters)];
        [self initGoalColorCells];
    }
    
    return self;
}

- (void)initGoalColorCells
{
    int cellSizePlusSpace = self.boardParameters.goalColorCellSize + self.boardParameters.goalColorCellSpacing;
    int xOffsetInitial = 0;
    int xOffset = xOffsetInitial;
    int yOffset = self.boardParameters.yOffsetForFirstTopGridButton;
    
    self.colorCellSections = [[NSMutableArray alloc] init];
    
    for (int i=0; i<self.boardParameters.gridSize; i++)
    {
        NSMutableArray *row = [[NSMutableArray alloc] init];
        NSMutableArray *boardCellTypeRow = [self.boardCells.colorCellSections objectAtIndex:i];
        
        for (int j=0; j<self.boardParameters.gridSize; j++)
        {
            NSNumber *cellType = [boardCellTypeRow objectAtIndex:j];
            ColorCell *colorCell = [self getColorCellForType:cellType.intValue xOffset:xOffset yOffset:yOffset size:self.boardParameters.goalColorCellSize];
            
            [row addObject:colorCell];
            xOffset += cellSizePlusSpace;
        }
        
        [self.colorCellSections addObject:row];
        yOffset += cellSizePlusSpace;
        xOffset = xOffsetInitial;
    }
}

- (void)removeExistingGoalColorCells
{
    for (int i=0; i<self.colorCellSections.count; i++)
    {
        NSMutableArray *row = [self.colorCellSections objectAtIndex:i];
        
        for (int j=0; j<row.count; j++)
        {
            ColorCell *colorCell = [row objectAtIndex:j];
            UIImageView *cellBlock = [colorCell image];
            [cellBlock removeFromSuperview];
        }
        
        [row removeAllObjects];
    }
    
    [self.colorCellSections removeAllObjects];
}

-(void)randomGenGoalStates
{
    self.topColorsState = [[NSMutableArray alloc] init];
    self.leftColorsState = [[NSMutableArray alloc] init];
    
    for (int i=0; i<self.boardParameters.gridSize; i++)
    {
        int random = arc4random()%4;
        NSNumber* wrappedNumber = [NSNumber numberWithInt:random];
        [self.topColorsState addObject:wrappedNumber];
    }
    
    for (int i=0; i<self.boardParameters.gridSize; i++)
    {
        int random = arc4random()%4;
        NSNumber* wrappedNumber = [NSNumber numberWithInt:random];
        [self.leftColorsState addObject:wrappedNumber];
    }
}

-(BOOL)checkGoalSufficientDifficulty
{
    // Check that we have all non-white colors represented in the toggle states
    bool has1 = false;
    bool has2 = false;
    bool has3 = false;
    bool hasAllColors = false;
    bool hasWhiteInResult = false;
    bool hasSpecialCells = false;
    
    for (int i=0; i<self.colorCellSections.count; i++)
    {
        NSMutableArray *row = [self.colorCellSections objectAtIndex:i];
        
        for (int j=0; j<row.count; j++)
        {
            ColorCell *colorCell = [row objectAtIndex:j];
            if (colorCell.cellType == NormalCell)
            {
                if ([colorCell.colorInputs containsObject:[NSNumber numberWithInt:1]])
                {
                    has1 = true;
                }
                
                if ([colorCell.colorInputs containsObject:[NSNumber numberWithInt:2]])
                {
                    has2 = true;
                }
                
                if ([colorCell.colorInputs containsObject:[NSNumber numberWithInt:3]])
                {
                    has3 = true;
                }
                
                hasAllColors = has1 && has2 && has3;
                
                if (colorCell.currentColor == 0)
                {
                    hasWhiteInResult = true;
                }
            }
            else
            {
                hasSpecialCells = true;
            }
        }
    }
    
    // Make sure all colors are represented on the board
    if (!hasAllColors)
    {
        return false;
    }
    
    // Check that we don't have any whites in the result
    if (!hasSpecialCells &&
        hasWhiteInResult)
    {
        return false;
    }
    
    // Check horizontally for max consecutive allowed
    int maxConsecutiveCountAllowed = 3;
    for (int i=0; i<self.colorCellSections.count; i++)
    {
        int sameColorConsecutiveCount = 0;
        int previousColor = -1;
        NSMutableArray *row = [self.colorCellSections objectAtIndex:i];
        for (int j=0; j<row.count; j++)
        {
            ColorCell *colorCell = [row objectAtIndex:j];
            if (colorCell.cellType == NormalCell)
            {
                int currentColor = colorCell.currentColor;
                if (previousColor == -1 || currentColor != previousColor)
                {
                    previousColor = currentColor;
                    sameColorConsecutiveCount = 1;
                }
                else if (currentColor == previousColor)
                {
                    sameColorConsecutiveCount++;
                    if (sameColorConsecutiveCount > maxConsecutiveCountAllowed)
                    {
                        // Too many same color found consecutively
                        return false;
                    }
                }
            }
            else
            {
                sameColorConsecutiveCount = 0;
            }
        }
    }
    
    // Check vertically for max consecutive allowed
    for (int i=0; i<self.colorCellSections.count; i++)
    {
        int sameColorConsecutiveCount = 0;
        int previousColor = -1;
        for (int j=0; j<self.colorCellSections.count; j++)
        {
            NSMutableArray *row = [self.colorCellSections objectAtIndex:j];
            ColorCell *colorCell = [row objectAtIndex:i];
            if (colorCell.cellType == NormalCell)
            {
                int currentColor = colorCell.currentColor;
                if (previousColor == -1 || currentColor != previousColor)
                {
                    previousColor = currentColor;
                    sameColorConsecutiveCount = 1;
                }
                else if (currentColor == previousColor)
                {
                    sameColorConsecutiveCount++;
                    if (sameColorConsecutiveCount > maxConsecutiveCountAllowed)
                    {
                        // Too many same color found consecutively
                        return false;
                    }
                }
            }
            else
            {
                sameColorConsecutiveCount = 0;
            }
        }
    }
    
    return true;
}

- (void)generateNewGoalBoardStates
{
    do
    {
        // Re-generate board cells
        self.boardCells = [[BoardCells alloc] initWithParameters:(self.boardParameters)];
        
        // Randomly generate goal color bar
        [self randomGenGoalStates];
        
        // Remove existing input colors from cells
        [self removeAllInputColorsFromCells];
        
        // Update goal cells
        [self updateAllColorCells];
    }
    while ([self checkGoalSufficientDifficulty] == false);
}

- (void)removeExistingGoalColorsState
{
    [self.topColorsState removeAllObjects];
    [self.leftColorsState removeAllObjects];
}

- (void)removeAllInputColorsFromCells
{
    for (int i=0; i<self.colorCellSections.count; i++)
    {
        NSMutableArray *row = [self.colorCellSections objectAtIndex:i];
        
        for (int j=0; j<row.count; j++)
        {
            ColorCell *colorCell = [row objectAtIndex:j];
            [colorCell removeAllInputColors];
        }
    }
}

// override base class
-(UIImage*)GetImageForCellType:(int)cellType
{
    switch (cellType)
    {
        case ReflectorLeftToDown:
            return [UIImage imageNamed:@"ReflectorLtDGoal@2x.png"];
        case ReflectorTopToRight:
            return [UIImage imageNamed:@"ReflectorTtRGoal@2x.png"];
    }
    
    return [super GetImageForCellType:cellType];
}

@end
