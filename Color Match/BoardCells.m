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
@property NSMutableDictionary *zonerValueDictionary;
@end

@implementation BoardCells

-(id)initWithParameters:(BoardParameters)boardParameters
{
    self = [super init];
    if (self)
    {
        self.boardParameters = boardParameters;
        self.zonerValueDictionary = [[NSMutableDictionary alloc] init];
        
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

-(void)addZonerValueAt:(int)row col:(int)col value:(int)value
{
    NSString* key = [NSString stringWithFormat:@"%d_%d", row, col];
    [self.zonerValueDictionary setObject:[NSNumber numberWithInt:value] forKey:key];
}

-(int)getZonerValueAt:(int)row col:(int)col
{
    NSString* key = [NSString stringWithFormat:@"%d_%d", row, col];
    NSNumber* number = [self.zonerValueDictionary objectForKey:(key)];
    return number.intValue;
}

- (void)generateRandomCellTypes
{
    int totalPossibleMechanics = 6;
    int mechanicCount = arc4random()%3; // Max 2 mechanics
    NSMutableArray* mechanicsList = [[NSMutableArray alloc] init];
    
    int i = 0;
    while (i < mechanicCount)
    {
        int mechanic = arc4random()%totalPossibleMechanics;
        
        if ([mechanicsList containsObject:[NSNumber numberWithInt:mechanic]])
        {
            continue;
        }
        
        [mechanicsList addObject:[NSNumber numberWithInt:mechanic]];
        
        switch (mechanic)
        {
            case 0:
                [self addReflectorMechanic:mechanicCount];
                break;
            case 1:
                [self addZonerMechanic:mechanicCount];
                break;
            case 2:
                [self addDiverterMechanic:mechanicCount];
                break;
            case 3:
                [self addSplitterMechanic:mechanicCount];
                break;
            case 4:
                [self addConnectorMechanic:mechanicCount];
                break;
            case 5:
                [self addConverterMechanic:mechanicCount];
                break;
        }
            
        i++;
    }
    
    [self logBoardCellState];
}

- (void)addConverterMechanic:(int)mechanicCount
{
    // Get number of cells to generate
    int upperBound = self.boardParameters.splitterMechanicUpperBound;
    int lowerBound = self.boardParameters.splitterMechanicLowerBound;
    int specialCellsCount = arc4random()%(upperBound - lowerBound + 1) + lowerBound;
    
    // Adjust for number of other mechanics
    specialCellsCount = specialCellsCount / mechanicCount;
    if (specialCellsCount < 0)
    {
        specialCellsCount = 1;
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
        
        // Do not allow converter in the last row/col
        if (randomRow == self.boardParameters.gridSize - 1 &&
            randomCol == self.boardParameters.gridSize - 1)
        {
            continue;
        }
        
        // Replace with special cell
        [row replaceObjectAtIndex:randomCol withObject:[NSNumber numberWithInt:Converter]];
        i++;
    }
}

- (void)addSplitterMechanic:(int)mechanicCount
{
    // Get number of cells to generate
    int upperBound = self.boardParameters.splitterMechanicUpperBound;
    int lowerBound = self.boardParameters.splitterMechanicLowerBound;
    int specialCellsCount = arc4random()%(upperBound - lowerBound + 1) + lowerBound;
    
    // Adjust for number of other mechanics
    specialCellsCount = specialCellsCount / mechanicCount;
    if (specialCellsCount < 0)
    {
        specialCellsCount = 1;
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
        
        // Replace with special cell
        [row replaceObjectAtIndex:randomCol withObject:[NSNumber numberWithInt:Splitter]];
        i++;
    }
}


- (void)addDiverterMechanic:(int)mechanicCount
{
    // Get number of cells to generate
    int upperBound = self.boardParameters.diverterMechanicUpperBound;
    int lowerBound = self.boardParameters.diverterMechanicLowerBound;
    int specialCellsCount = arc4random()%(upperBound - lowerBound + 1) + lowerBound;
    
    // Adjust for number of other mechanics
    specialCellsCount = specialCellsCount / mechanicCount;
    if (specialCellsCount < 0)
    {
        specialCellsCount = 1;
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
        
        // Do not allow Diverter mechanic on bottom row
        if (randomRow == self.boardParameters.gridSize - 1)
        {
            continue;
        }
        
        // Do not allow Diverter mechanic on right column
        if (randomCol == self.boardParameters.gridSize - 1)
        {
            continue;
        }
        
        // Make sure we don't have TtR to the right of Diverter
        if ([self hasCellOfTypeOnRight:randomRow col:randomCol cellType:ReflectorTopToRight])
        {
            continue;
        }
        
        // Make sure we don't have LtD below Diverter
        if ([self hasCellOfTypeOnBottom:randomRow col:randomCol cellType:ReflectorLeftToDown])
        {
            continue;
        }
        
        // Make sure there is a connection from the top
        if (![self hasConnectionFromTop:randomRow col:randomCol])
        {
            continue;
        }
        
        // Make sure there is a connection from the left
        if (![self hasConnectionFromLeft:randomRow col:randomCol])
        {
            continue;
        }
        
        // Replace with special cell
        [row replaceObjectAtIndex:randomCol withObject:[NSNumber numberWithInt:Diverter]];
        i++;
    }
}

- (void)addReflectorMechanic:(int)mechanicCount
{
    // Get number of cells to generate
    int upperBound = self.boardParameters.reflectorMechanicUpperBound;
    int lowerBound = self.boardParameters.reflectorMechanicLowerBound;
    int specialCellsCount = arc4random()%(upperBound - lowerBound + 1) + lowerBound;
    
    // Adjust for number of other mechanics
    specialCellsCount = specialCellsCount / mechanicCount;
    if (specialCellsCount < 0)
    {
        specialCellsCount = 1;
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
            if ([self hasHorizontalAdjacentCellOfType:randomRow col:randomCol cellType:ReflectorTopToRight])
            {
                continue;
            }
            
            // Make sure we don't have TtR to the right of Diverter
            if ([self hasCellOfTypeOnLeft:randomRow col:randomCol cellType:Diverter])
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
            if ([self hasVerticalAdjacentCellOfType:randomRow col:randomCol cellType:ReflectorLeftToDown])
            {
                continue;
            }
            
            // Make sure we don't have LtD below Diverter
            if ([self hasCellOfTypeOnTop:randomRow col:randomCol cellType:Diverter])
            {
                continue;
            }
        }
        
        // Replace with special cell
        [row replaceObjectAtIndex:randomCol withObject:[NSNumber numberWithInt:reflectorType]];
        i++;
    }
}

- (void)addZonerMechanic:(int)mechanicCount
{
    // Get number of cells to generate
    int upperBound = self.boardParameters.zonerMechanicUpperBound;
    int lowerBound = self.boardParameters.zonerMechanicLowerBound;
    int specialCellsCount = arc4random()%(upperBound - lowerBound + 1) + lowerBound;
    
    // Adjust for number of other mechanics
    specialCellsCount = specialCellsCount / mechanicCount;
    if (specialCellsCount < 0)
    {
        specialCellsCount = 1;
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
        
        // Replace with special cell
        [row replaceObjectAtIndex:randomCol withObject:[NSNumber numberWithInt:Zoner]];
        i++;
    }
}

- (void)addConnectorMechanic:(int)mechanicCount
{
    // Get number of cells to generate
    int upperBound = self.boardParameters.connectorMechanicUpperBound;
    int lowerBound = self.boardParameters.connectorMechanicLowerBound;
    int specialCellsCount = arc4random()%(upperBound - lowerBound + 1) + lowerBound;
    
    // Adjust for number of other mechanics
    specialCellsCount = specialCellsCount / mechanicCount;
    if (specialCellsCount < 2)
    {
        // Connector needs a minium of 2
        specialCellsCount = 2;
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
        
        // Replace with special cell
        [row replaceObjectAtIndex:randomCol withObject:[NSNumber numberWithInt:Connector]];
        i++;
    }
    
    self.connectorCellInput = arc4random()%4;
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
        
        if (tempCellType.intValue == ReflectorTopToRight || tempCellType.intValue == Diverter)
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
        
        if (tempCellType.intValue == ReflectorLeftToDown || tempCellType.intValue == Diverter)
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

- (bool)hasHorizontalAdjacentCellOfType:(int)row col:(int)col cellType:(CellType)cellType
{
    // Check both sides for cell type
    if ([self hasCellOfTypeOnLeft:row col:col cellType:cellType])
    {
        return true;
    }
    
    if ([self hasCellOfTypeOnRight:row col:col cellType:cellType])
    {
        return true;
    }
    
    return false;
}

- (bool)hasVerticalAdjacentCellOfType:(int)row col:(int)col cellType:(CellType)cellType
{
    // Check top and bottom for cell type
    if ([self hasCellOfTypeOnTop:row col:col cellType:cellType])
    {
        return true;
    }
    
    if ([self hasCellOfTypeOnBottom:row col:col cellType:cellType])
    {
        return true;
    }
    
    return false;
}

- (bool)hasCellOfTypeOnLeft:(int)row col:(int)col cellType:(CellType)cellType
{
    NSMutableArray *currentRow = [self.colorCellSections objectAtIndex:row];
    if (col > 0)
    {
        NSNumber *leftCellType = [currentRow objectAtIndex:col - 1];
        return leftCellType.intValue == cellType;
    }
    
    return false;
}

- (bool)hasCellOfTypeOnRight:(int)row col:(int)col cellType:(CellType)cellType
{
    NSMutableArray *currentRow = [self.colorCellSections objectAtIndex:row];
    if (col < self.boardParameters.gridSize - 1)
    {
        NSNumber *rightCellType = [currentRow objectAtIndex:col + 1];
        return rightCellType.intValue == cellType;
    }
    
    return false;
}

- (bool)hasCellOfTypeOnTop:(int)row col:(int)col cellType:(CellType)cellType
{
    if (row > 0)
    {
        NSMutableArray *topRow = [self.colorCellSections objectAtIndex:row - 1];
        NSNumber *topCellType = [topRow objectAtIndex:col];
        return topCellType.intValue == cellType;
    }
    
    return false;
}

- (bool)hasCellOfTypeOnBottom:(int)row col:(int)col cellType:(CellType)cellType
{
    if (row < self.boardParameters.gridSize - 1)
    {
        NSMutableArray *bottomRow = [self.colorCellSections objectAtIndex:row + 1];
        NSNumber *bottomCellType = [bottomRow objectAtIndex:col];
        return bottomCellType.intValue == cellType;
    }
    
    return false;
}

@end
