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
    
    // TODO: Need to modify this to add additional mechanics
    int random = arc4random()%2;
    bool hasReflectorMechanic = random == 1;
    
    if (hasReflectorMechanic)
    {
        [self addReflectorMechanic];
    }
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
            specialCellsCount = arc4random()%(upperBound - lowerBound + 1) + 1;
            break;
        case 5:
            upperBound = 4;
            lowerBound = 2;
            specialCellsCount = arc4random()%(upperBound - lowerBound + 1) + 1;
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
            // Check both sides for TopToRight cell
            if (randomCol > 0)
            {
                NSNumber *leftCellType = [row objectAtIndex:randomCol - 1];
                if (leftCellType.intValue == ReflectorTopToRight)
                {
                    // Don't want 2 TopToRight cells next to each other
                    continue;
                }
            }
            
            if (randomCol < self.boardParameters.gridSize - 1)
            {
                NSNumber *rightCellType = [row objectAtIndex:randomCol + 1];
                if (rightCellType.intValue == ReflectorTopToRight)
                {
                    // Don't want 2 TopToRight cells next to each other
                    continue;
                }
            }
        }
        
        if (reflectorType == ReflectorLeftToDown)
        {
            // Check both sides for LeftToDown cell
            if (randomRow > 0)
            {
                NSMutableArray *topRow = [self.colorCellSections objectAtIndex:randomRow - 1];
                NSNumber *topCellType = [topRow objectAtIndex:randomCol];
                if (topCellType.intValue == ReflectorLeftToDown)
                {
                    // Don't want 2 LeftToDown cells next to each other
                    continue;
                }
            }
            
            if (randomRow < self.boardParameters.gridSize - 1)
            {
                NSMutableArray *bottomRow = [self.colorCellSections objectAtIndex:randomRow + 1];
                NSNumber *bottomCellType = [bottomRow objectAtIndex:randomCol];
                if (bottomCellType.intValue == ReflectorLeftToDown)
                {
                    // Don't want 2 LeftToDown cells next to each other
                    continue;
                }
            }
        }
        
        // Replace iwth special cell
        [row replaceObjectAtIndex:randomCol withObject:[NSNumber numberWithInt:reflectorType]];
        i++;
            
        // Logging
        NSString *reflector = reflectorDirection == 1 ?
                @"ReflectorLeftToDown" : @"ReflectorTopToRight";
        NSMutableString *string = [[NSMutableString alloc] init];
        [string appendString:@"Added reflector cell of type "];
        [string appendString:reflector];
        [string appendString:[NSString stringWithFormat: @" to cell %d,%d", randomRow, randomCol]];
        NSLog(@"%@", string);
        
    }
}

@end
