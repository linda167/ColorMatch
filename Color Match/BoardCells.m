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
        if (cellType.intValue == NormalCell)
        {
            int reflectorDirection = arc4random()%2;
            CellType reflectorType = reflectorDirection == 1 ?
                ReflectorLeftToDown : ReflectorTopToRight;
            [row replaceObjectAtIndex:randomCol withObject:[NSNumber numberWithInt:reflectorType]];
            i++;
        }
    }
}

@end
