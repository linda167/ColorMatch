//
//  LevelsManager.m
//  Color Match
//
//  Created by Linda Chen on 6/14/14.
//  Copyright (c) 2014 SunSpark Entertainment. All rights reserved.
//

#import "LevelsManager.h"
#import "BoardCells.h"

@implementation LevelsManager

+(int)GetGameSizeForWorld:(int)worldId levelId:(int)levelId
{
    if (worldId == 1)
    {
        if (levelId <= 4)
            return 3;
        else if (levelId <= 8)
            return 4;
        else
            return 5;
    }
    else
    {
        // TODO: modify for other worlds
        return 5;
    }
}

+(int)GetLevelCountForWorld:(int)worldId
{
    if (worldId == 1)
    {
        return 12;
    }
    else
    {
        // TODO: modify for other worlds
        return 20;
    }
}

+(int)IsRandomLevel:(int)worldId levelId:(int)levelId
{
    return worldId == 0 && levelId == 0;
}

+(BoardCells*)LoadBoardCellTypes:(int)worldId levelId:(int)levelId boardParameters:(BoardParameters)boardParameters
{
    BoardCells* boardCells = [[BoardCells alloc] initWithParameters:(boardParameters)];
    
    if ([LevelsManager IsRandomLevel:worldId levelId:levelId])
    {
        // World 0-0 means random board
        [boardCells generateRandomCellTypes];
    }
    else
    {
        // TODO: Need to load board cell types for world 2+
    }
    
    return boardCells;
}

+(int)CalculateStarsEarned:(int)boardSize time:(int)time
{
    if (boardSize == 3)
    {
        if (time <= 10)
        {
            return 4;
        }
        else if (time <= 20)
        {
            return 3;
        }
        else if (time <= 40)
        {
            return 2;
        }
        else
        {
            return 1;
        }
    }
    else if (boardSize == 4)
    {
        if (time <= 15)
        {
            return 4;
        }
        else if (time <= 25)
        {
            return 3;
        }
        else if (time <= 45)
        {
            return 2;
        }
        else
        {
            return 1;
        }
    }
    else if (boardSize == 5)
    {
        if (time <= 20)
        {
            return 4;
        }
        else if (time <= 30)
        {
            return 3;
        }
        else if (time <= 50)
        {
            return 2;
        }
        else
        {
            return 1;
        }
    }
    
    [NSException raise:@"Invalid board size" format:@"Invalid board size"];
    return 1;
}

+(void)GetBoardStatesForLevel:(int)worldId levelId:(int)levelId topColorsState:(NSMutableArray*)topColorsState leftColorsState:(NSMutableArray*)leftColorsState
{
    [topColorsState removeAllObjects];
    [leftColorsState removeAllObjects];
    
    if (worldId == 1 && levelId == 1)
    {
        [topColorsState addObjectsFromArray:[NSArray arrayWithObjects:@"2", @"3", @"1", nil]];
        [leftColorsState addObjectsFromArray:[NSArray arrayWithObjects:@"3", @"1", @"2", nil]];
    }
    else if (worldId == 1 && levelId == 2)
    {
        [topColorsState addObjectsFromArray:[NSArray arrayWithObjects:@"1", @"0", @"3", nil]];
        [leftColorsState addObjectsFromArray:[NSArray arrayWithObjects:@"1", @"2", @"3", nil]];
    }
    else if (worldId == 1 && levelId == 3)
    {
        [topColorsState addObjectsFromArray:[NSArray arrayWithObjects:@"2", @"1", @"3", nil]];
        [leftColorsState addObjectsFromArray:[NSArray arrayWithObjects:@"2", @"3", @"1", nil]];
    }
    else if (worldId == 1 && levelId == 4)
    {
        [topColorsState addObjectsFromArray:[NSArray arrayWithObjects:@"3", @"1", @"2", nil]];
        [leftColorsState addObjectsFromArray:[NSArray arrayWithObjects:@"0", @"3", @"2", nil]];
    }
    else if (worldId == 1 && levelId == 5)
    {
        [topColorsState addObjectsFromArray:[NSArray arrayWithObjects:@"3", @"1", @"1", @"2", nil]];
        [leftColorsState addObjectsFromArray:[NSArray arrayWithObjects:@"2", @"3", @"1", @"3", nil]];
    }
    else if (worldId == 1 && levelId == 6)
    {
        [topColorsState addObjectsFromArray:[NSArray arrayWithObjects:@"1", @"2", @"3", @"2", nil]];
        [leftColorsState addObjectsFromArray:[NSArray arrayWithObjects:@"3", @"1", @"0", @"2", nil]];
    }
    else if (worldId == 1 && levelId == 7)
    {
        [topColorsState addObjectsFromArray:[NSArray arrayWithObjects:@"1", @"2", @"3", @"0", nil]];
        [leftColorsState addObjectsFromArray:[NSArray arrayWithObjects:@"1", @"2", @"3", @"2", nil]];
    }
    else if (worldId == 1 && levelId == 8)
    {
        [topColorsState addObjectsFromArray:[NSArray arrayWithObjects:@"2", @"3", @"2", @"1", nil]];
        [leftColorsState addObjectsFromArray:[NSArray arrayWithObjects:@"1", @"3", @"2", @"1", nil]];
    }
    else if (worldId == 1 && levelId == 9)
    {
        [topColorsState addObjectsFromArray:[NSArray arrayWithObjects:@"3", @"1", @"1", @"2", @"3", nil]];
        [leftColorsState addObjectsFromArray:[NSArray arrayWithObjects:@"2", @"1", @"3", @"2", @"3", nil]];
    }
    else if (worldId == 1 && levelId == 10)
    {
        [topColorsState addObjectsFromArray:[NSArray arrayWithObjects:@"1", @"2", @"3", @"3", @"2", nil]];
        [leftColorsState addObjectsFromArray:[NSArray arrayWithObjects:@"1", @"2", @"3", @"2", @"1", nil]];
    }
    else if (worldId == 1 && levelId == 11)
    {
        [topColorsState addObjectsFromArray:[NSArray arrayWithObjects:@"2", @"3", @"2", @"1", @"3", nil]];
        [leftColorsState addObjectsFromArray:[NSArray arrayWithObjects:@"3", @"1", @"2", @"0", @"1", nil]];
    }
    else if (worldId == 1 && levelId == 12)
    {
        [topColorsState addObjectsFromArray:[NSArray arrayWithObjects:@"2", @"3", @"1", @"2", @"0", nil]];
        [leftColorsState addObjectsFromArray:[NSArray arrayWithObjects:@"2", @"1", @"3", @"2", @"3", nil]];
    }
}

@end
