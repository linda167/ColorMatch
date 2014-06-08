//
//  BoardCells.m
//  Color Match
//
//  Description: Object representing the board with cell types for each cell.
//  Will be consumed by both goal board and user color board.
//
//  Created by Linda Chen on 5/11/14.
//  Copyright (c) 2014 SunSpark Entertainment. All rights reserved.
//

#import "BoardCells.h"

@interface BoardCells ()
@property BoardParameters boardParameters;
@end

@implementation BoardCells

-(id)initWithParameters:(BoardParameters)boardParameters
{
    self = [super init];
    if (self)
    {
        self.boardParameters = boardParameters;
        
        [self initCells];
    }
    
    return self;
}

- (void)initCells
{
    self.colorCellSections = [[NSMutableArray alloc] init];
    
    for (int i=0; i<self.boardParameters.gridSize; i++)
    {
        NSMutableArray *row = [[NSMutableArray alloc] init];
        for (int j=0; j<self.boardParameters.gridSize; j++)
        {
            // Initialize all cells to normal type
            CellType cellType = NormalCell;
            [row addObject:[NSNumber numberWithInt:cellType]];
        }
        
        [self.colorCellSections addObject:row];
    }
}

- (void)generateRandomCellTypes
{
    // TODO: Need to modify this to add additional mechanics
    int random = arc4random()%2;
    bool hasReflectorMechanic = random == 1;
    
    if (hasReflectorMechanic)
    {
        [self addReflectorMechanic];
    }
    
    [self logBoardCellState];
}

- (void)addReflectorMechanic
{
    int specialCellsCount;
    int upperBound = 2;
    int lowerBound = 1;
    switch (self.boardParameters.gridSize)
    {
        case 3:
            specialCellsCount = 1;
            break;
        case 4:
            upperBound = 2;
            lowerBound = 1;
            specialCellsCount = arc4random()%(upperBound - lowerBound + 1) + lowerBound;
            break;
        case 5:
            upperBound = 4;
            lowerBound = 2;
            specialCellsCount = arc4random()%(upperBound - lowerBound + 1) + lowerBound;
            break;
        default:
            [NSException raise:@"Invalid input" format:@"Invalid board size"];
            break;
    }
    
    int i = 0;
    while (i < specialCellsCount)
    {
        int randomRow = arc4random()%self.boardParameters.gridSize;
        int randomCol = arc4random()%self.boardParameters.gridSize;
        
        NSMutableArray *row = [self.colorCellSections objectAtIndex:randomRow];
        NSNumber *cellType = [row objectAtIndex:randomCol];
        
        // Only replace normal cells, not cells that already have mechanics
        if (cellType.intValue != NormalCell)
        {
            continue;
        }
        
        int reflectorDirection = arc4random()%2;
        CellType reflectorType = reflectorDirection == 1 ?
            ReflectorLeftToDown : ReflectorTopToRight;
        
        // Do not allow LeftToDown mechanic on bottom row
        if (reflectorType == ReflectorLeftToDown && randomRow == self.boardParameters.gridSize - 1)
        {
            continue;
        }
        
        // Do not allow TopToRight mechanic on right column
        if (reflectorType == ReflectorTopToRight && randomCol == self.boardParameters.gridSize - 1)
        {
            continue;
        }
        
        if (reflectorType == ReflectorTopToRight)
        {
            // Make sure there is a connection from the top
            if (![self hasConnectionFromTop:randomRow col:randomCol])
            {
                continue;
            }
            
            // Make sure we don't need a connection on the bottom
            if ([self needConnectionOnBottom:randomRow col:randomCol])
            {
                // We need the connection to the bottom, so can't add this reflector here
                continue;
            }
            
            // Make sure we don't have 2 TopToRight next to each other
            if ([self hasAdjacentTopToRightCell:randomRow col:randomCol])
            {
                continue;
            }
        }
        
        if (reflectorType == ReflectorLeftToDown)
        {
            // Make sure there is a connection from the left
            if (![self hasConnectionFromLeft:randomRow col:randomCol])
            {
                continue;
            }
            
            // Make sure we don't need a connection on the right
            if ([self needConnectionOnRight:randomRow col:randomCol])
            {
                // We need the connection to the right, so can't add this reflector here
                continue;
            }
            
            // Make sure we don't have 2 LeftToDown on top of each other
            if ([self hasAdjacentLeftToDownCell:randomRow col:randomCol])
            {
                continue;
            }
        }
        
        // Replace with special cell
        [row replaceObjectAtIndex:randomCol withObject:[NSNumber numberWithInt:reflectorType]];
        i++;
    }
}

- (void)logBoardCellState
{
    NSMutableString *string = [[NSMutableString alloc] init];
    [string appendString:@"Board cells state:\n "];
    for (int i=0; i<self.colorCellSections.count; i++)
    {
        NSMutableArray *row = [self.colorCellSections objectAtIndex:i];
        for (int j=0; j<self.colorCellSections.count; j++)
        {
            NSNumber *cellType = [row objectAtIndex:j];
            [string appendString:[NSString stringWithFormat: @"%d", cellType.intValue]];
        }
        
        [string appendString:@"\n "];
    }
    
    [CommonUtils Log:string];
}

// Returns true if at given row, col, there is a connection from up top
- (bool)hasConnectionFromTop:(int)row col:(int)col
{
    for (int j = row-1; j >=0; j--)
    {
        NSMutableArray *tempRow = [self.colorCellSections objectAtIndex:j];
        NSNumber *tempCellType = [tempRow objectAtIndex:col];
        
        if (tempCellType.intValue == ReflectorTopToRight)
        {
            return false;
        }
        else if (tempCellType.intValue == ReflectorLeftToDown)
        {
            return true;
        }
    }
    
    return true;
}

// Returns true if at given row, col, we require a connection to the bottom
- (bool)needConnectionOnBottom:(int)row col:(int)col
{
    for (int j=row+1; j<self.boardParameters.gridSize; j++)
    {
        NSMutableArray *tempRow = [self.colorCellSections objectAtIndex:j];
        NSNumber *tempCellType = [tempRow objectAtIndex:col];
        
        if (tempCellType.intValue == ReflectorTopToRight)
        {
            return true;
        }
        else if (tempCellType.intValue == ReflectorLeftToDown)
        {
            return false;
        }
    }
    
    return false;
}

// Returns true if at given row, col, there is a connection from the left
- (bool)hasConnectionFromLeft:(int)row col:(int)col
{
    NSMutableArray *currentRow = [self.colorCellSections objectAtIndex:row];
    for (int j = col-1; j >=0; j--)
    {
        NSNumber *tempCellType = [currentRow objectAtIndex:j];
        
        if (tempCellType.intValue == ReflectorLeftToDown)
        {
            return false;
        }
        else if (tempCellType.intValue == ReflectorTopToRight)
        {
            return true;
        }
    }
    
    return true;
}

// Returns true if at given row, col, we require a connection on the right
- (bool)needConnectionOnRight:(int)row col:(int)col
{
    NSMutableArray *currentRow = [self.colorCellSections objectAtIndex:row];
    for (int j=col+1; j<self.boardParameters.gridSize; j++)
    {
        NSNumber *tempCellType = [currentRow objectAtIndex:j];
        
        if (tempCellType.intValue == ReflectorLeftToDown)
        {
            return true;
        }
        else if (tempCellType.intValue == ReflectorTopToRight)
        {
            return false;
        }
    }
    
    return false;
}

- (bool)hasAdjacentTopToRightCell:(int)row col:(int)col
{
    // Check both sides for TopToRight cell
    NSMutableArray *currentRow = [self.colorCellSections objectAtIndex:row];
    if (col > 0)
    {
        NSNumber *leftCellType = [currentRow objectAtIndex:col - 1];
        if (leftCellType.intValue == ReflectorTopToRight)
        {
            // 2 TopToRight cells next to each other
            return true;
        }
    }
    
    if (col < self.boardParameters.gridSize - 1)
    {
        NSNumber *rightCellType = [currentRow objectAtIndex:col + 1];
        if (rightCellType.intValue == ReflectorTopToRight)
        {
            // 2 TopToRight cells next to each other
            return true;
        }
    }
    
    return false;
}

- (bool)hasAdjacentLeftToDownCell:(int)row col:(int)col
{
    // Check both sides for LeftToDown cell
    if (row > 0)
    {
        NSMutableArray *topRow = [self.colorCellSections objectAtIndex:row - 1];
        NSNumber *topCellType = [topRow objectAtIndex:col];
        if (topCellType.intValue == ReflectorLeftToDown)
        {
            // 2 LeftToDown cells on top of each other
            return true;
        }
    }
    
    if (row < self.boardParameters.gridSize - 1)
    {
        NSMutableArray *bottomRow = [self.colorCellSections objectAtIndex:row + 1];
        NSNumber *bottomCellType = [bottomRow objectAtIndex:col];
        if (bottomCellType.intValue == ReflectorLeftToDown)
        {
            // 2 LeftToDown cells on top of each other
            return true;
        }
    }
    
    return false;
}

@end
