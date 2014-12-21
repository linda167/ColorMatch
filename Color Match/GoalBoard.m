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
#import "LevelsManager.h"
#import "ZonerCell.h"
#import "ConnectorCell.h"
#import "SplitterCell.h"
#import "ConverterCell.h"
#import "TransporterCell.h"

@interface GoalBoard ()
@end

@implementation GoalBoard

-(id)initWithParameters:(BoardParameters)boardParameters containerView:(UIView*)containerView boardCells:(BoardCells*)boardCells
{
    self = [super initWithParameters:boardCells];
    if (self)
    {
        self.boardParameters = boardParameters;
        self.containerView = containerView;
        self.topColorsState = [[NSMutableArray alloc] init];
        self.leftColorsState = [[NSMutableArray alloc] init];
        
        [self initGoalColorCells];
    }
    
    return self;
}

- (void)initGoalColorCells
{
    int cellSizePlusSpace = self.boardParameters.goalColorCellSize + self.boardParameters.goalColorCellSpacing;
    int xOffsetInitial = 0;
    int xOffset = xOffsetInitial;
    int yOffset = 0;
    
    self.colorCellSections = [[NSMutableArray alloc] init];
    
    for (int i=0; i<self.boardParameters.gridSize; i++)
    {
        NSMutableArray *row = [[NSMutableArray alloc] init];
        NSMutableArray *boardCellTypeRow = [self.boardCells.colorCellSections objectAtIndex:i];
        
        for (int j=0; j<self.boardParameters.gridSize; j++)
        {
            NSNumber *cellType = [boardCellTypeRow objectAtIndex:j];
            ColorCell *colorCell = [self getColorCellForType:cellType.intValue xOffset:xOffset yOffset:yOffset size:self.boardParameters.goalColorCellSize row:i col:j boardCells:self.boardCells];
            
            if (cellType.intValue == Zoner)
            {
                ((ZonerCell*)colorCell).inputColor = [self.boardCells getZonerValueAt:i col:j];
            }
            else if (cellType.intValue == Splitter)
            {
                ((SplitterCell*)colorCell).inputColor = [self.boardCells getSplitterValueAt:i col:j];
            }
            else if (cellType.intValue == Converter)
            {
                ((ConverterCell*)colorCell).isDirectionRight = [self.boardCells getConverterDirectionAt:i col:j] == 1;
            }
            
            [row addObject:colorCell];
            xOffset += cellSizePlusSpace;
        }
        
        [self.colorCellSections addObject:row];
        yOffset += cellSizePlusSpace;
        xOffset = xOffsetInitial;
    }
}

-(void)randomGenGoalStates
{
    [self.topColorsState removeAllObjects];
    [self.leftColorsState removeAllObjects];
    
    for (int i=0; i<self.boardParameters.gridSize; i++)
    {
        [self.topColorsState addObject:[self getRandomColor]];
    }
    
    for (int i=0; i<self.boardParameters.gridSize; i++)
    {
        [self.leftColorsState addObject:[self getRandomColor]];
    }
    
    [self logGoalStates];
}

- (NSNumber*)getRandomColor
{
    int random = arc4random()%4;
    return [NSNumber numberWithInt:random];
}


- (void)randomGenAndApplySpecialCellStates
{
    for (int i=0; i<self.colorCellSections.count; i++)
    {
        NSMutableArray *row = [self.colorCellSections objectAtIndex:i];
        for (int j=0; j<row.count; j++)
        {
            ColorCell *colorCell = [row objectAtIndex:j];
            
            if (colorCell.cellType == Zoner)
            {
                ((ZonerCell*)colorCell).inputColor = [self getRandomColor].intValue;
                [self applySpecialCell:colorCell isAdd:true cellsAffected:NULL];
            }
            else if (colorCell.cellType == Connector)
            {
                ((ConnectorCell*)colorCell).inputColor = self.boardCells.connectorCellInput;
                [self applySpecialCell:colorCell isAdd:true cellsAffected:NULL];
            }
            else if (colorCell.cellType == Splitter)
            {
                ((SplitterCell*)colorCell).inputColor = [self getRandomColor].intValue;
                [self applySpecialCell:colorCell isAdd:true cellsAffected:NULL];
            }
        }
    }
}

-(void)logGoalStates
{
    NSMutableString *string = [[NSMutableString alloc] init];

    [string appendString:@"Left goal states: "];
    for (NSNumber* leftNSNumber in self.leftColorsState)
    {
        [string appendString:[NSString stringWithFormat: @"%d", leftNSNumber.intValue]];
    }
    [string appendString:@"\n "];
    
    [string appendString:@"Top goal states: "];
    for (NSNumber* topNSNumber in self.topColorsState)
    {
        [string appendString:[NSString stringWithFormat: @"%d", topNSNumber.intValue]];
    }
    [string appendString:@"\n "];
    
    [CommonUtils Log:string];
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
            if ([ColorCell doesCellSupportCombineColor:colorCell.cellType])
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
        [CommonUtils Log:[NSMutableString stringWithString:@"Not all colors are represented on the board."]];
        return false;
    }
    
    // Check that we don't have any whites in the result if there are no special cells
    if (!hasSpecialCells &&
        hasWhiteInResult)
    {
        [CommonUtils Log:[NSMutableString stringWithString:@"Difficulty check failed, white found in result with no special cells."]];
        return false;
    }
    
    if (!hasSpecialCells)
    {
        // Check horizontally for max consecutive allowed
        int maxConsecutiveCountAllowed = 2;
        for (int i=0; i<self.colorCellSections.count; i++)
        {
            int sameColorConsecutiveCount = 0;
            int previousColor = -1;
            NSMutableArray *row = [self.colorCellSections objectAtIndex:i];
            for (int j=0; j<row.count; j++)
            {
                ColorCell *colorCell = [row objectAtIndex:j];
                if ([ColorCell doesCellSupportCombineColor:colorCell.cellType])
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
                            [CommonUtils Log:[NSMutableString stringWithString:@"Difficulty check failed, too many same color found consecutively horizontally."]];
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
                if ([ColorCell doesCellSupportCombineColor:colorCell.cellType])
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
                            [CommonUtils Log:[NSMutableString stringWithString:@"Difficulty check failed, too many same color found consecutively vertically."]];
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
    }
    
    if (hasSpecialCells)
    {
        // Only allow max of 1 white input if we have special cells
        int whiteColorInputCount = 0;
        for (NSNumber* leftNSNumber in self.leftColorsState)
        {
            int leftColor = [leftNSNumber intValue];
            if (leftColor == 0)
            {
                whiteColorInputCount++;
            }
        }
        
        for (NSNumber* topNSNumber in self.topColorsState)
        {
            int topColor = [topNSNumber intValue];
            if (topColor == 0)
            {
                whiteColorInputCount++;
            }
        }
        
        if (whiteColorInputCount > 1)
        {
            [CommonUtils Log:[NSMutableString stringWithFormat: @"Too many white inputs. HasSpecialCells, white color inputs: %d", whiteColorInputCount]];
            return false;
        }
    }
    
    return true;
}

- (void)generateNewGoalBoardStates:(int)worldId levelId:(int)levelId
{
    if ([LevelsManager IsRandomLevel:worldId levelId:levelId])
    {
        // Random board
        [self generateRandomGoalBoardStates];
    }
    else
    {
        [LevelsManager GetBoardStatesForLevel:worldId levelId:levelId topColorsState:self.topColorsState leftColorsState:self.leftColorsState];
        
        // Update goal cell
        [self updateAllColorCells];
        
        // Apply special cells
        [self applySpecialCells];
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
            if (colorCell.cellType == Zoner || colorCell.cellType == Splitter || colorCell.cellType == Converter)
            {
                [self applySpecialCell:colorCell isAdd:true cellsAffected:NULL];
            }
            else if (colorCell.cellType == Connector)
            {
                ((ConnectorCell*)colorCell).inputColor = self.boardCells.connectorCellInput;
                [self applySpecialCell:colorCell isAdd:true cellsAffected:NULL];
            }
        }
    }
}

- (void)generateRandomGoalBoardStates
{
    int tryCount = 0;
    do
    {
        // Randomly generate goal color bar
        [self randomGenGoalStates];
        
        // Remove existing input colors from cells
        [self removeAllInputColorsFromCells];
        
        // Update goal cells
        [self updateAllColorCells];
        
        // Randomly generate and apply special cell states
        [self randomGenAndApplySpecialCellStates];
        tryCount++;
    }
    while ([self checkGoalSufficientDifficulty] == false && tryCount < 10);
}

- (void)removeExistingBoard
{
    [self removeExistingGridCells];
    [self removeExistingGoalColorsState];
    [self resetBoardState];
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
-(UIImage*)GetImageForCellType:(ColorCell*)colorCell
{
    switch (colorCell.cellType)
    {
        case ReflectorLeftToDown:
            return [UIImage imageNamed:@"ReflectorLtDGoal@2x.png"];
        case ReflectorTopToRight:
            return [UIImage imageNamed:@"ReflectorTtRGoal@2x.png"];
        case Zoner:
            return [UIImage imageNamed:@"zonerGoal@2x.png"];
        case Connector:
            return [UIImage imageNamed:@"connectorOuterWhite@2x.png"];
        case Diverter:
            return [UIImage imageNamed:@"diverterGoal@2x.png"];
        case Splitter:
            return [UIImage imageNamed:@"splitterWhite@2x.png"];
        case Converter:
            return [UIImage imageNamed:@"converterGoal@2x.png"];
        case TransporterInputLeft:
        case TransporterInputTop:
        case TransporterOutputDown:
        case TransporterOutputRight:
            return [self getTransporterImageWithColor:colorCell color:0];
    }
    
    return [super GetImageForCellType:colorCell];
}

-(void)GetSpecialImageForCellIfNeeded:(ColorCell*)colorCell boardCells:(BoardCells*)boardCells
{
    UIImage *specialImage = NULL;
    
    switch (colorCell.cellType)
    {
        case Connector:
        {
            // Initialize to white cell
            specialImage = [CommonUtils GetConnectorInnerImageForColor:0];
            break;
        }
    }
    
    if (specialImage != NULL)
    {
        int size = colorCell.image.frame.size.width;
        int x = colorCell.image.frame.origin.x;
        int y = colorCell.image.frame.origin.y;
        
        UIImageView *specialImageView = [[UIImageView alloc] initWithFrame:CGRectMake(x, y, size, size)];
        
        specialImageView.image = specialImage;
        colorCell.specialImage = specialImageView;
        [self.containerView addSubview:specialImageView];
    }
}

@end
