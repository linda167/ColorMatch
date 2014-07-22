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
        if (levelId <= 4)
            return 3;
        else if (levelId <= 8)
            return 4;
        else
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
        return 16;
    }
}

+(int)GetTotalWorldCount
{
    return 10;
}

+(int)IsRandomLevel:(int)worldId levelId:(int)levelId
{
    return worldId == 0 && levelId == 0;
}

+(int)CalculateStarsEarned:(int)boardSize time:(int)time worldId:(int)worldId levelId:(int)levelId
{
    if (worldId == 1)
    {
        if (boardSize == 3)
        {
            if (time <= 10) return 4;
            else if (time <= 20) return 3;
            else if (time <= 40) return 2;
            else return 1;
        }
        else if (boardSize == 4)
        {
            if (time <= 15) return 4;
            else if (time <= 25) return 3;
            else if (time <= 45) return 2;
            else return 1;
        }
        else if (boardSize == 5)
        {
            if (time <= 20) return 4;
            else if (time <= 30) return 3;
            else if (time <= 50) return 2;
            else return 1;
        }
    }
    else if (worldId == 2)
    {
        if (boardSize == 3)
        {
            if (time <= 10) return 4;
            else if (time <= 20) return 3;
            else if (time <= 40) return 2;
            else return 1;
        }
        else if (boardSize == 4)
        {
            if (time <= 20) return 4;
            else if (time <= 30) return 3;
            else if (time <= 50) return 2;
            else return 1;
        }
        else if (boardSize == 5)
        {
            if (time <= 25) return 4;
            else if (time <= 35) return 3;
            else if (time <= 55) return 2;
            else return 1;
        }
    }
    else if (worldId == 3)
    {
        if (boardSize == 3)
        {
            if (time <= 10) return 4;
            else if (time <= 20) return 3;
            else if (time <= 40) return 2;
            else return 1;
        }
        else if (boardSize == 4)
        {
            if (time <= 20) return 4;
            else if (time <= 30) return 3;
            else if (time <= 50) return 2;
            else return 1;
        }
        else if (boardSize == 5)
        {
            if (time <= 45) return 4;
            else if (time <= 55) return 3;
            else if (time <= 75) return 2;
            else return 1;
        }
    }
    else if (worldId == 4)
    {
        if (boardSize == 3)
        {
            if (time <= 10) return 4;
            else if (time <= 20) return 3;
            else if (time <= 40) return 2;
            else return 1;
        }
        else if (boardSize == 4)
        {
            if (time <= 20) return 4;
            else if (time <= 30) return 3;
            else if (time <= 50) return 2;
            else return 1;
        }
        else if (boardSize == 5)
        {
            if (time <= 40) return 4;
            else if (time <= 50) return 3;
            else if (time <= 70) return 2;
            else return 1;
        }
    }
    else if (worldId == 5)
    {
        if (levelId <= 4)
        {
            if (time <= 10) return 4;
            else if (time <= 20) return 3;
            else if (time <= 40) return 2;
            else return 1;
        }
        else if (levelId <= 8)
        {
            if (time <= 20) return 4;
            else if (time <= 30) return 3;
            else if (time <= 50) return 2;
            else return 1;
        }
        else if (levelId <= 12)
        {
            if (time <= 35) return 4;
            else if (time <= 45) return 3;
            else if (time <= 65) return 2;
            else return 1;
        }
        else
        {
            if (time <= 45) return 4;
            else if (time <= 55) return 3;
            else if (time <= 75) return 2;
            else return 1;
        }
    }
    else if (worldId == 6)
    {
        if (boardSize == 3)
        {
            if (time <= 10) return 4;
            else if (time <= 20) return 3;
            else if (time <= 40) return 2;
            else return 1;
        }
        else if (boardSize == 4)
        {
            if (time <= 20) return 4;
            else if (time <= 30) return 3;
            else if (time <= 50) return 2;
            else return 1;
        }
        else if (boardSize == 5)
        {
            if (time <= 45) return 4;
            else if (time <= 55) return 3;
            else if (time <= 75) return 2;
            else return 1;
        }
    }
    else if (worldId == 7)
    {
        if (boardSize == 3)
        {
            if (time <= 10) return 4;
            else if (time <= 20) return 3;
            else if (time <= 40) return 2;
            else return 1;
        }
        else if (boardSize == 4)
        {
            if (time <= 20) return 4;
            else if (time <= 30) return 3;
            else if (time <= 50) return 2;
            else return 1;
        }
        else if (boardSize == 5)
        {
            if (time <= 45) return 4;
            else if (time <= 55) return 3;
            else if (time <= 75) return 2;
            else return 1;
        }
    }
    else if (worldId == 8)
    {
        if (boardSize == 3)
        {
            if (time <= 10) return 4;
            else if (time <= 20) return 3;
            else if (time <= 40) return 2;
            else return 1;
        }
        else if (boardSize == 4)
        {
            if (time <= 20) return 4;
            else if (time <= 30) return 3;
            else if (time <= 50) return 2;
            else return 1;
        }
        else if (boardSize == 5)
        {
            if (time <= 45) return 4;
            else if (time <= 55) return 3;
            else if (time <= 75) return 2;
            else return 1;
        }
    }
    
    [NSException raise:@"Invalid board size" format:@"Invalid board size"];
    return 1;
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
        if (worldId == 2 && levelId == 1)
        {
            boardCells.colorCellSections = [NSMutableArray arrayWithObjects:
                [NSArray arrayWithObjects:@"0", @"1", @"0", nil],
                [NSArray arrayWithObjects:@"0", @"0", @"0", nil],
                [NSArray arrayWithObjects:@"0", @"0", @"0", nil],
                nil];
        }
        else if (worldId == 2 && levelId == 2)
        {
            boardCells.colorCellSections = [NSMutableArray arrayWithObjects:
                [NSArray arrayWithObjects:@"0", @"0", @"0", nil],
                [NSArray arrayWithObjects:@"0", @"2", @"0", nil],
                [NSArray arrayWithObjects:@"0", @"0", @"0", nil],
                nil];
        }
        else if (worldId == 2 && levelId == 3)
        {
            boardCells.colorCellSections = [NSMutableArray arrayWithObjects:
                [NSArray arrayWithObjects:@"0", @"0", @"0", nil],
                [NSArray arrayWithObjects:@"0", @"0", @"0", nil],
                [NSArray arrayWithObjects:@"0", @"2", @"0", nil],
                nil];
        }
        else if (worldId == 2 && levelId == 4)
        {
            boardCells.colorCellSections = [NSMutableArray arrayWithObjects:
                [NSArray arrayWithObjects:@"0", @"0", @"0", nil],
                [NSArray arrayWithObjects:@"1", @"0", @"0", nil],
                [NSArray arrayWithObjects:@"0", @"0", @"0", nil],
                nil];
        }
        else if (worldId == 2 && levelId == 5)
        {
            boardCells.colorCellSections = [NSMutableArray arrayWithObjects:
                [NSArray arrayWithObjects:@"0", @"0", @"0", @"0", nil],
                [NSArray arrayWithObjects:@"0", @"0", @"1", @"0", nil],
                [NSArray arrayWithObjects:@"0", @"2", @"0", @"0", nil],
                [NSArray arrayWithObjects:@"0", @"0", @"0", @"0", nil],
                nil];
        }
        else if (worldId == 2 && levelId == 6)
        {
            boardCells.colorCellSections = [NSMutableArray arrayWithObjects:
                [NSArray arrayWithObjects:@"0", @"0", @"0", @"0", nil],
                [NSArray arrayWithObjects:@"0", @"2", @"1", @"0", nil],
                [NSArray arrayWithObjects:@"0", @"0", @"0", @"0", nil],
                [NSArray arrayWithObjects:@"0", @"0", @"0", @"0", nil],
                nil];

        }
        else if (worldId == 2 && levelId == 7)
        {
            boardCells.colorCellSections = [NSMutableArray arrayWithObjects:
                [NSArray arrayWithObjects:@"0", @"0", @"0", @"1", nil],
                [NSArray arrayWithObjects:@"0", @"0", @"0", @"0", nil],
                [NSArray arrayWithObjects:@"0", @"0", @"0", @"0", nil],
                [NSArray arrayWithObjects:@"0", @"2", @"0", @"0", nil],
                nil];
        }
        else if (worldId == 2 && levelId == 8)
        {
            boardCells.colorCellSections = [NSMutableArray arrayWithObjects:
                [NSArray arrayWithObjects:@"0", @"0", @"0", @"0", nil],
                [NSArray arrayWithObjects:@"0", @"1", @"0", @"0", nil],
                [NSArray arrayWithObjects:@"0", @"2", @"0", @"0", nil],
                [NSArray arrayWithObjects:@"0", @"0", @"0", @"0", nil],
                nil];
        }
        else if (worldId == 2 && levelId == 9)
        {
            boardCells.colorCellSections = [NSMutableArray arrayWithObjects:
                [NSArray arrayWithObjects:@"0", @"0", @"1", @"0", @"0", nil],
                [NSArray arrayWithObjects:@"0", @"0", @"0", @"0", @"0", nil],
                [NSArray arrayWithObjects:@"0", @"0", @"2", @"0", @"1", nil],
                [NSArray arrayWithObjects:@"0", @"0", @"0", @"0", @"0", nil],
                [NSArray arrayWithObjects:@"0", @"0", @"0", @"0", @"0", nil],
                nil];
        }
        else if (worldId == 2 && levelId == 10)
        {
            boardCells.colorCellSections = [NSMutableArray arrayWithObjects:
                [NSArray arrayWithObjects:@"0", @"0", @"0", @"0", @"0", nil],
                [NSArray arrayWithObjects:@"0", @"2", @"0", @"1", @"0", nil],
                [NSArray arrayWithObjects:@"0", @"0", @"0", @"0", @"0", nil],
                [NSArray arrayWithObjects:@"0", @"0", @"2", @"0", @"0", nil],
                [NSArray arrayWithObjects:@"0", @"0", @"0", @"0", @"0", nil],
                nil];
        }
        else if (worldId == 2 && levelId == 11)
        {
            boardCells.colorCellSections = [NSMutableArray arrayWithObjects:
                [NSArray arrayWithObjects:@"0", @"0", @"0", @"0", @"0", nil],
                [NSArray arrayWithObjects:@"0", @"1", @"0", @"0", @"0", nil],
                [NSArray arrayWithObjects:@"0", @"2", @"0", @"0", @"1", nil],
                [NSArray arrayWithObjects:@"0", @"0", @"0", @"0", @"0", nil],
                [NSArray arrayWithObjects:@"0", @"0", @"0", @"0", @"0", nil],
                nil];
        }
        else if (worldId == 2 && levelId == 12)
        {
            boardCells.colorCellSections = [NSMutableArray arrayWithObjects:
                [NSArray arrayWithObjects:@"0", @"0", @"0", @"0", @"0", nil],
                [NSArray arrayWithObjects:@"0", @"0", @"2", @"0", @"1", nil],
                [NSArray arrayWithObjects:@"0", @"0", @"1", @"0", @"0", nil],
                [NSArray arrayWithObjects:@"0", @"0", @"0", @"0", @"0", nil],
                [NSArray arrayWithObjects:@"0", @"0", @"0", @"0", @"0", nil],
                nil];
        }
        else if (worldId == 2 && levelId == 13)
        {
            boardCells.colorCellSections = [NSMutableArray arrayWithObjects:
                [NSArray arrayWithObjects:@"0", @"0", @"0", @"0", @"0", nil],
                [NSArray arrayWithObjects:@"0", @"0", @"1", @"0", @"0", nil],
                [NSArray arrayWithObjects:@"0", @"0", @"0", @"0", @"0", nil],
                [NSArray arrayWithObjects:@"0", @"2", @"0", @"0", @"1", nil],
                [NSArray arrayWithObjects:@"0", @"0", @"0", @"0", @"0", nil],
                nil];
        }
        else if (worldId == 2 && levelId == 14)
        {
            boardCells.colorCellSections = [NSMutableArray arrayWithObjects:
                [NSArray arrayWithObjects:@"0", @"0", @"0", @"0", @"0", nil],
                [NSArray arrayWithObjects:@"0", @"2", @"0", @"1", @"0", nil],
                [NSArray arrayWithObjects:@"0", @"0", @"0", @"2", @"0", nil],
                [NSArray arrayWithObjects:@"0", @"0", @"0", @"0", @"0", nil],
                [NSArray arrayWithObjects:@"0", @"0", @"0", @"0", @"0", nil],
                nil];
        }
        else if (worldId == 2 && levelId == 15)
        {
            boardCells.colorCellSections = [NSMutableArray arrayWithObjects:
                [NSArray arrayWithObjects:@"0", @"0", @"0", @"1", @"0", nil],
                [NSArray arrayWithObjects:@"0", @"0", @"0", @"0", @"0", nil],
                [NSArray arrayWithObjects:@"2", @"0", @"0", @"0", @"0", nil],
                [NSArray arrayWithObjects:@"0", @"0", @"0", @"0", @"0", nil],
                [NSArray arrayWithObjects:@"0", @"2", @"0", @"0", @"0", nil],
                nil];
        }
        else if (worldId == 2 && levelId == 16)
        {
            boardCells.colorCellSections = [NSMutableArray arrayWithObjects:
                [NSArray arrayWithObjects:@"0", @"0", @"0", @"0", @"1", nil],
                [NSArray arrayWithObjects:@"0", @"0", @"0", @"2", @"0", nil],
                [NSArray arrayWithObjects:@"0", @"0", @"0", @"0", @"0", nil],
                [NSArray arrayWithObjects:@"0", @"1", @"0", @"0", @"0", nil],
                [NSArray arrayWithObjects:@"2", @"0", @"0", @"0", @"0", nil],
                nil];
        }
        else if (worldId == 3 && levelId == 1)
        {
            boardCells.colorCellSections = [NSMutableArray arrayWithObjects:
                [NSArray arrayWithObjects:@"0", @"0", @"0", nil],
                [NSArray arrayWithObjects:@"0", @"6", @"0", nil],
                [NSArray arrayWithObjects:@"0", @"0", @"0", nil],
                nil];
            
            [boardCells addSplitterValueAt:1 col:1 value:1];
        }
        else if (worldId == 3 && levelId == 2)
        {
            boardCells.colorCellSections = [NSMutableArray arrayWithObjects:
                [NSArray arrayWithObjects:@"0", @"0", @"0", nil],
                [NSArray arrayWithObjects:@"6", @"0", @"0", nil],
                [NSArray arrayWithObjects:@"0", @"0", @"0", nil],
                nil];
            
            [boardCells addSplitterValueAt:1 col:0 value:3];
        }
        else if (worldId == 3 && levelId == 3)
        {
            boardCells.colorCellSections = [NSMutableArray arrayWithObjects:
                [NSArray arrayWithObjects:@"0", @"0", @"0", nil],
                [NSArray arrayWithObjects:@"6", @"0", @"0", nil],
                [NSArray arrayWithObjects:@"0", @"6", @"0", nil],
                nil];
            
            [boardCells addSplitterValueAt:1 col:0 value:3];
            [boardCells addSplitterValueAt:2 col:1 value:2];
        }
        else if (worldId == 3 && levelId == 4)
        {
            boardCells.colorCellSections = [NSMutableArray arrayWithObjects:
                [NSArray arrayWithObjects:@"6", @"0", @"0", nil],
                [NSArray arrayWithObjects:@"0", @"0", @"0", nil],
                [NSArray arrayWithObjects:@"0", @"0", @"6", nil],
                nil];
            
            [boardCells addSplitterValueAt:0 col:0 value:1];
            [boardCells addSplitterValueAt:2 col:2 value:1];
        }
        else if (worldId == 3 && levelId == 5)
        {
            boardCells.colorCellSections = [NSMutableArray arrayWithObjects:
                [NSArray arrayWithObjects:@"0", @"0", @"0", @"0", nil],
                [NSArray arrayWithObjects:@"0", @"6", @"0", @"0", nil],
                [NSArray arrayWithObjects:@"0", @"0", @"0", @"0", nil],
                [NSArray arrayWithObjects:@"0", @"0", @"0", @"0", nil],
                nil];
            
            [boardCells addSplitterValueAt:1 col:1 value:1];
        }
        else if (worldId == 3 && levelId == 6)
        {
            boardCells.colorCellSections = [NSMutableArray arrayWithObjects:
                [NSArray arrayWithObjects:@"0", @"0", @"0", @"0", nil],
                [NSArray arrayWithObjects:@"0", @"0", @"6", @"0", nil],
                [NSArray arrayWithObjects:@"6", @"0", @"0", @"0", nil],
                [NSArray arrayWithObjects:@"0", @"0", @"0", @"0", nil],
                nil];
            
            [boardCells addSplitterValueAt:1 col:2 value:2];
            [boardCells addSplitterValueAt:2 col:0 value:3];
        }
        else if (worldId == 3 && levelId == 7)
        {
            boardCells.colorCellSections = [NSMutableArray arrayWithObjects:
                [NSArray arrayWithObjects:@"0", @"6", @"0", @"0", nil],
                [NSArray arrayWithObjects:@"0", @"0", @"0", @"0", nil],
                [NSArray arrayWithObjects:@"0", @"0", @"0", @"0", nil],
                [NSArray arrayWithObjects:@"0", @"0", @"6", @"0", nil],
                nil];
            
            [boardCells addSplitterValueAt:0 col:1 value:3];
            [boardCells addSplitterValueAt:3 col:2 value:1];
        }
        else if (worldId == 3 && levelId == 8)
        {
            boardCells.colorCellSections = [NSMutableArray arrayWithObjects:
                [NSArray arrayWithObjects:@"0", @"0", @"0", @"0", nil],
                [NSArray arrayWithObjects:@"0", @"0", @"6", @"0", nil],
                [NSArray arrayWithObjects:@"0", @"6", @"0", @"0", nil],
                [NSArray arrayWithObjects:@"0", @"0", @"0", @"0", nil],
                nil];
            
            [boardCells addSplitterValueAt:1 col:2 value:2];
            [boardCells addSplitterValueAt:2 col:1 value:1];
        }
        else if (worldId == 3 && levelId == 9)
        {
            boardCells.colorCellSections =
            [NSMutableArray arrayWithObjects:
                [NSArray arrayWithObjects:@"0", @"0", @"0", @"0", @"0", nil],
                [NSArray arrayWithObjects:@"0", @"6", @"0", @"0", @"0", nil],
                [NSArray arrayWithObjects:@"0", @"0", @"0", @"0", @"0", nil],
                [NSArray arrayWithObjects:@"0", @"0", @"0", @"6", @"0", nil],
                [NSArray arrayWithObjects:@"0", @"6", @"0", @"0", @"0", nil],
                nil];
            
            [boardCells addSplitterValueAt:1 col:1 value:3];
            [boardCells addSplitterValueAt:3 col:3 value:2];
            [boardCells addSplitterValueAt:4 col:1 value:1];
        }
        else if (worldId == 3 && levelId == 10)
        {
            boardCells.colorCellSections =
            [NSMutableArray arrayWithObjects:
             [NSArray arrayWithObjects:@"0", @"0", @"0", @"0", @"0", nil],
             [NSArray arrayWithObjects:@"0", @"6", @"0", @"6", @"0", nil],
             [NSArray arrayWithObjects:@"0", @"0", @"0", @"0", @"0", nil],
             [NSArray arrayWithObjects:@"0", @"6", @"0", @"6", @"0", nil],
             [NSArray arrayWithObjects:@"0", @"0", @"0", @"0", @"0", nil],
             nil];
            
            [boardCells addSplitterValueAt:1 col:1 value:3];
            [boardCells addSplitterValueAt:1 col:3 value:1];
            [boardCells addSplitterValueAt:3 col:1 value:1];
            [boardCells addSplitterValueAt:3 col:3 value:3];
        }
        else if (worldId == 3 && levelId == 11)
        {
            boardCells.colorCellSections =
            [NSMutableArray arrayWithObjects:
             [NSArray arrayWithObjects:@"0", @"0", @"0", @"0", @"0", nil],
             [NSArray arrayWithObjects:@"6", @"0", @"0", @"0", @"0", nil],
             [NSArray arrayWithObjects:@"0", @"0", @"0", @"0", @"0", nil],
             [NSArray arrayWithObjects:@"0", @"0", @"6", @"0", @"0", nil],
             [NSArray arrayWithObjects:@"0", @"0", @"0", @"0", @"6", nil],
             nil];
            
            [boardCells addSplitterValueAt:1 col:0 value:2];
            [boardCells addSplitterValueAt:3 col:2 value:1];
            [boardCells addSplitterValueAt:4 col:5 value:3];
        }
        else if (worldId == 3 && levelId == 12)
        {
            boardCells.colorCellSections =
            [NSMutableArray arrayWithObjects:
             [NSArray arrayWithObjects:@"0", @"6", @"0", @"0", @"0", nil],
             [NSArray arrayWithObjects:@"0", @"0", @"0", @"0", @"6", nil],
             [NSArray arrayWithObjects:@"0", @"0", @"0", @"0", @"0", nil],
             [NSArray arrayWithObjects:@"6", @"0", @"6", @"0", @"0", nil],
             [NSArray arrayWithObjects:@"0", @"0", @"0", @"0", @"0", nil],
             nil];
            
            [boardCells addSplitterValueAt:0 col:1 value:3];
            [boardCells addSplitterValueAt:1 col:4 value:2];
            [boardCells addSplitterValueAt:3 col:0 value:1];
            [boardCells addSplitterValueAt:3 col:2 value:2];
        }
        else if (worldId == 3 && levelId == 13)
        {
            boardCells.colorCellSections =
            [NSMutableArray arrayWithObjects:
             [NSArray arrayWithObjects:@"0", @"0", @"0", @"0", @"0", nil],
             [NSArray arrayWithObjects:@"0", @"0", @"1", @"0", @"0", nil],
             [NSArray arrayWithObjects:@"0", @"0", @"0", @"0", @"0", nil],
             [NSArray arrayWithObjects:@"0", @"0", @"0", @"6", @"0", nil],
             [NSArray arrayWithObjects:@"0", @"6", @"0", @"0", @"0", nil],
             nil];
            
            [boardCells addSplitterValueAt:3 col:3 value:1];
            [boardCells addSplitterValueAt:4 col:1 value:3];
        }
        else if (worldId == 3 && levelId == 14)
        {
            boardCells.colorCellSections =
            [NSMutableArray arrayWithObjects:
             [NSArray arrayWithObjects:@"0", @"0", @"0", @"0", @"0", nil],
             [NSArray arrayWithObjects:@"0", @"0", @"1", @"0", @"0", nil],
             [NSArray arrayWithObjects:@"0", @"0", @"0", @"6", @"0", nil],
             [NSArray arrayWithObjects:@"0", @"2", @"0", @"0", @"0", nil],
             [NSArray arrayWithObjects:@"0", @"6", @"0", @"0", @"0", nil],
             nil];
            
            [boardCells addSplitterValueAt:2 col:3 value:1];
            [boardCells addSplitterValueAt:4 col:1 value:2];
        }
        else if (worldId == 3 && levelId == 15)
        {
            boardCells.colorCellSections =
            [NSMutableArray arrayWithObjects:
             [NSArray arrayWithObjects:@"0", @"0", @"0", @"0", @"0", nil],
             [NSArray arrayWithObjects:@"0", @"1", @"0", @"2", @"0", nil],
             [NSArray arrayWithObjects:@"0", @"6", @"0", @"0", @"0", nil],
             [NSArray arrayWithObjects:@"0", @"0", @"6", @"0", @"0", nil],
             [NSArray arrayWithObjects:@"0", @"0", @"0", @"0", @"0", nil],
             nil];
            
            [boardCells addSplitterValueAt:2 col:1 value:1];
            [boardCells addSplitterValueAt:3 col:2 value:3];
        }
        else if (worldId == 3 && levelId == 16)
        {
            boardCells.colorCellSections =
            [NSMutableArray arrayWithObjects:
             [NSArray arrayWithObjects:@"0", @"0", @"0", @"0", @"0", nil],
             [NSArray arrayWithObjects:@"0", @"1", @"0", @"2", @"0", nil],
             [NSArray arrayWithObjects:@"0", @"0", @"1", @"0", @"0", nil],
             [NSArray arrayWithObjects:@"6", @"0", @"0", @"6", @"0", nil],
             [NSArray arrayWithObjects:@"0", @"0", @"0", @"0", @"0", nil],
             nil];
            
            [boardCells addSplitterValueAt:1 col:3 value:2];
            [boardCells addSplitterValueAt:3 col:0 value:1];
            [boardCells addSplitterValueAt:3 col:3 value:3];
        }
        else if (worldId == 4 && levelId == 1)
        {
            boardCells.colorCellSections =
            [NSMutableArray arrayWithObjects:
            [NSArray arrayWithObjects:@"0", @"4", @"0", nil],
            [NSArray arrayWithObjects:@"4", @"0", @"4", nil],
            [NSArray arrayWithObjects:@"0", @"0", @"0", nil],
            nil];
            
            boardCells.connectorCellInput = 1;
        }
        else if (worldId == 4 && levelId == 2)
        {
            boardCells.colorCellSections =
            [NSMutableArray arrayWithObjects:
             [NSArray arrayWithObjects:@"4", @"0", @"0", nil],
             [NSArray arrayWithObjects:@"0", @"0", @"0", nil],
             [NSArray arrayWithObjects:@"0", @"4", @"4", nil],
             nil];
            
            boardCells.connectorCellInput = 3;
        }
        else if (worldId == 4 && levelId == 3)
        {
            boardCells.colorCellSections =
            [NSMutableArray arrayWithObjects:
             [NSArray arrayWithObjects:@"4", @"0", @"0", nil],
             [NSArray arrayWithObjects:@"0", @"4", @"0", nil],
             [NSArray arrayWithObjects:@"0", @"0", @"4", nil],
             nil];
            
            boardCells.connectorCellInput = 2;
        }
        else if (worldId == 4 && levelId == 4)
        {
            boardCells.colorCellSections =
            [NSMutableArray arrayWithObjects:
             [NSArray arrayWithObjects:@"0", @"0", @"0", nil],
             [NSArray arrayWithObjects:@"4", @"4", @"4", nil],
             [NSArray arrayWithObjects:@"0", @"0", @"0", nil],
             nil];
            
            boardCells.connectorCellInput = 3;
        }
        else if (worldId == 4 && levelId == 5)
        {
            boardCells.colorCellSections =
            [NSMutableArray arrayWithObjects:
            [NSArray arrayWithObjects:@"0", @"0", @"0", @"4", nil],
            [NSArray arrayWithObjects:@"4", @"0", @"0", @"0", nil],
            [NSArray arrayWithObjects:@"0", @"4", @"0", @"0", nil],
            [NSArray arrayWithObjects:@"0", @"0", @"0", @"0", nil],
            nil];
            
            boardCells.connectorCellInput = 3;
        }
        else if (worldId == 4 && levelId == 6)
        {
            boardCells.colorCellSections =
            [NSMutableArray arrayWithObjects:
             [NSArray arrayWithObjects:@"4", @"0", @"0", @"0", nil],
             [NSArray arrayWithObjects:@"0", @"0", @"0", @"0", nil],
             [NSArray arrayWithObjects:@"0", @"0", @"0", @"4", nil],
             [NSArray arrayWithObjects:@"0", @"0", @"4", @"0", nil],
             nil];
            
            boardCells.connectorCellInput = 1;
        }
        else if (worldId == 4 && levelId == 7)
        {
            boardCells.colorCellSections =
            [NSMutableArray arrayWithObjects:
             [NSArray arrayWithObjects:@"0", @"0", @"0", @"4", nil],
             [NSArray arrayWithObjects:@"4", @"0", @"0", @"0", nil],
             [NSArray arrayWithObjects:@"0", @"0", @"0", @"0", nil],
             [NSArray arrayWithObjects:@"0", @"0", @"4", @"0", nil],
             nil];
            
            boardCells.connectorCellInput = 2;
        }
        else if (worldId == 4 && levelId == 8)
        {
            boardCells.colorCellSections =
            [NSMutableArray arrayWithObjects:
             [NSArray arrayWithObjects:@"0", @"0", @"0", @"0", nil],
             [NSArray arrayWithObjects:@"4", @"0", @"0", @"0", nil],
             [NSArray arrayWithObjects:@"0", @"0", @"4", @"0", nil],
             [NSArray arrayWithObjects:@"4", @"0", @"0", @"0", nil],
             nil];
            
            boardCells.connectorCellInput = 1;
        }
        else if (worldId == 4 && levelId == 9)
        {
            boardCells.colorCellSections =
            [NSMutableArray arrayWithObjects:
             [NSArray arrayWithObjects:@"4", @"0", @"0", @"0", @"0", nil],
             [NSArray arrayWithObjects:@"0", @"0", @"0", @"4", @"0", nil],
             [NSArray arrayWithObjects:@"0", @"0", @"4", @"0", @"0", nil],
             [NSArray arrayWithObjects:@"0", @"0", @"0", @"0", @"0", nil],
             [NSArray arrayWithObjects:@"0", @"4", @"0", @"0", @"0", nil],
             nil];
            
            boardCells.connectorCellInput = 1;
        }
        else if (worldId == 4 && levelId == 10)
        {
            boardCells.colorCellSections =
            [NSMutableArray arrayWithObjects:
             [NSArray arrayWithObjects:@"0", @"0", @"0", @"0", @"4", nil],
             [NSArray arrayWithObjects:@"0", @"4", @"0", @"0", @"0", nil],
             [NSArray arrayWithObjects:@"0", @"0", @"0", @"4", @"0", nil],
             [NSArray arrayWithObjects:@"0", @"0", @"0", @"0", @"0", nil],
             [NSArray arrayWithObjects:@"4", @"0", @"0", @"0", @"0", nil],
             nil];
            
            boardCells.connectorCellInput = 2;
        }
        else if (worldId == 4 && levelId == 11)
        {
            boardCells.colorCellSections =
            [NSMutableArray arrayWithObjects:
             [NSArray arrayWithObjects:@"0", @"4", @"0", @"0", @"0", nil],
             [NSArray arrayWithObjects:@"0", @"0", @"0", @"0", @"0", nil],
             [NSArray arrayWithObjects:@"0", @"0", @"0", @"4", @"0", nil],
             [NSArray arrayWithObjects:@"4", @"0", @"0", @"0", @"0", nil],
             [NSArray arrayWithObjects:@"0", @"0", @"0", @"0", @"4", nil],
             nil];
            
            boardCells.connectorCellInput = 1;
        }
        else if (worldId == 4 && levelId == 12)
        {
            boardCells.colorCellSections =
            [NSMutableArray arrayWithObjects:
             [NSArray arrayWithObjects:@"0", @"0", @"4", @"0", @"0", nil],
             [NSArray arrayWithObjects:@"0", @"0", @"0", @"0", @"0", nil],
             [NSArray arrayWithObjects:@"0", @"4", @"0", @"0", @"0", nil],
             [NSArray arrayWithObjects:@"0", @"0", @"0", @"0", @"0", nil],
             [NSArray arrayWithObjects:@"0", @"0", @"4", @"0", @"4", nil],
             nil];
            
            boardCells.connectorCellInput = 3;
        }
        else if (worldId == 4 && levelId == 13)
        {
            boardCells.colorCellSections =
            [NSMutableArray arrayWithObjects:
             [NSArray arrayWithObjects:@"4", @"0", @"0", @"0", @"1", nil],
             [NSArray arrayWithObjects:@"0", @"0", @"0", @"0", @"0", nil],
             [NSArray arrayWithObjects:@"0", @"6", @"0", @"0", @"0", nil],
             [NSArray arrayWithObjects:@"0", @"0", @"4", @"0", @"0", nil],
             [NSArray arrayWithObjects:@"0", @"0", @"0", @"0", @"4", nil],
             nil];
            
            boardCells.connectorCellInput = 3;
            [boardCells addZonerValueAt:2 col:1 value:1];
        }
        else if (worldId == 4 && levelId == 14)
        {
            boardCells.colorCellSections =
            [NSMutableArray arrayWithObjects:
             [NSArray arrayWithObjects:@"0", @"0", @"0", @"0", @"0", nil],
             [NSArray arrayWithObjects:@"4", @"0", @"0", @"0", @"0", nil],
             [NSArray arrayWithObjects:@"0", @"0", @"2", @"0", @"4", nil],
             [NSArray arrayWithObjects:@"0", @"6", @"4", @"0", @"0", nil],
             [NSArray arrayWithObjects:@"0", @"0", @"0", @"0", @"0", nil],
             nil];
            
            boardCells.connectorCellInput = 1;
            [boardCells addZonerValueAt:3 col:1 value:2];
        }
        else if (worldId == 4 && levelId == 15)
        {
            boardCells.colorCellSections =
            [NSMutableArray arrayWithObjects:
             [NSArray arrayWithObjects:@"4", @"0", @"4", @"0", @"0", nil],
             [NSArray arrayWithObjects:@"0", @"0", @"0", @"6", @"0", nil],
             [NSArray arrayWithObjects:@"0", @"2", @"0", @"0", @"1", nil],
             [NSArray arrayWithObjects:@"0", @"0", @"0", @"0", @"0", nil],
             [NSArray arrayWithObjects:@"0", @"0", @"4", @"0", @"0", nil],
             nil];
            
            boardCells.connectorCellInput = 2;
            [boardCells addZonerValueAt:1 col:3 value:3];
        }
        else if (worldId == 4 && levelId == 16)
        {
            boardCells.colorCellSections =
            [NSMutableArray arrayWithObjects:
             [NSArray arrayWithObjects:@"0", @"0", @"4", @"0", @"1", nil],
             [NSArray arrayWithObjects:@"0", @"6", @"0", @"0", @"0", nil],
             [NSArray arrayWithObjects:@"0", @"4", @"0", @"4", @"0", nil],
             [NSArray arrayWithObjects:@"0", @"0", @"0", @"6", @"0", nil],
             [NSArray arrayWithObjects:@"2", @"0", @"4", @"0", @"0", nil],
             nil];
            
            boardCells.connectorCellInput = 1;
            [boardCells addZonerValueAt:1 col:1 value:3];
            [boardCells addZonerValueAt:3 col:3 value:2];
        }
        else if (worldId == 5 && levelId == 1)
        {
            boardCells.colorCellSections =
            [NSMutableArray arrayWithObjects:
             [NSArray arrayWithObjects:@"0", @"0", @"0", nil],
             [NSArray arrayWithObjects:@"0", @"5", @"0", nil],
             [NSArray arrayWithObjects:@"0", @"0", @"0", nil],
             nil];
        }
        else if (worldId == 5 && levelId == 2)
        {
            boardCells.colorCellSections =
            [NSMutableArray arrayWithObjects:
             [NSArray arrayWithObjects:@"5", @"0", @"0", nil],
             [NSArray arrayWithObjects:@"0", @"0", @"0", nil],
             [NSArray arrayWithObjects:@"0", @"0", @"0", nil],
             nil];
        }
        else if (worldId == 5 && levelId == 3)
        {
            boardCells.colorCellSections =
            [NSMutableArray arrayWithObjects:
             [NSArray arrayWithObjects:@"0", @"0", @"0", nil],
             [NSArray arrayWithObjects:@"5", @"0", @"0", nil],
             [NSArray arrayWithObjects:@"0", @"0", @"0", nil],
             nil];
        }
        else if (worldId == 5 && levelId == 4)
        {
            boardCells.colorCellSections =
            [NSMutableArray arrayWithObjects:
             [NSArray arrayWithObjects:@"0", @"5", @"0", nil],
             [NSArray arrayWithObjects:@"0", @"0", @"0", nil],
             [NSArray arrayWithObjects:@"0", @"0", @"0", nil],
             nil];
        }
        else if (worldId == 5 && levelId == 5)
        {
            boardCells.colorCellSections =
            [NSMutableArray arrayWithObjects:
             [NSArray arrayWithObjects:@"0", @"0", @"0", @"0", nil],
             [NSArray arrayWithObjects:@"0", @"5", @"0", @"0", nil],
             [NSArray arrayWithObjects:@"0", @"0", @"5", @"0", nil],
             [NSArray arrayWithObjects:@"0", @"0", @"0", @"0", nil],
             nil];
        }
        else if (worldId == 5 && levelId == 6)
        {
            boardCells.colorCellSections =
            [NSMutableArray arrayWithObjects:
             [NSArray arrayWithObjects:@"0", @"0", @"0", @"0", nil],
             [NSArray arrayWithObjects:@"5", @"0", @"5", @"0", nil],
             [NSArray arrayWithObjects:@"0", @"0", @"0", @"0", nil],
             [NSArray arrayWithObjects:@"0", @"0", @"0", @"0", nil],
             nil];
        }
        else if (worldId == 5 && levelId == 7)
        {
            boardCells.colorCellSections =
            [NSMutableArray arrayWithObjects:
             [NSArray arrayWithObjects:@"0", @"0", @"0", @"0", nil],
             [NSArray arrayWithObjects:@"0", @"0", @"5", @"0", nil],
             [NSArray arrayWithObjects:@"0", @"0", @"5", @"0", nil],
             [NSArray arrayWithObjects:@"0", @"0", @"0", @"0", nil],
             nil];
        }
        else if (worldId == 5 && levelId == 8)
        {
            boardCells.colorCellSections =
            [NSMutableArray arrayWithObjects:
             [NSArray arrayWithObjects:@"0", @"0", @"0", @"0", nil],
             [NSArray arrayWithObjects:@"0", @"5", @"5", @"0", nil],
             [NSArray arrayWithObjects:@"0", @"0", @"0", @"0", nil],
             [NSArray arrayWithObjects:@"0", @"0", @"0", @"0", nil],
             nil];
        }
        else if (worldId == 5 && levelId == 9)
        {
            boardCells.colorCellSections =
            [NSMutableArray arrayWithObjects:
             [NSArray arrayWithObjects:@"0", @"0", @"0", @"0", @"0", nil],
             [NSArray arrayWithObjects:@"0", @"5", @"0", @"0", @"0", nil],
             [NSArray arrayWithObjects:@"0", @"0", @"0", @"5", @"0", nil],
             [NSArray arrayWithObjects:@"0", @"5", @"0", @"0", @"0", nil],
             [NSArray arrayWithObjects:@"0", @"0", @"0", @"0", @"0", nil],
             nil];
        }
        else if (worldId == 5 && levelId == 10)
        {
            boardCells.colorCellSections =
            [NSMutableArray arrayWithObjects:
             [NSArray arrayWithObjects:@"5", @"0", @"0", @"5", @"0", nil],
             [NSArray arrayWithObjects:@"0", @"0", @"0", @"0", @"0", nil],
             [NSArray arrayWithObjects:@"0", @"0", @"0", @"0", @"0", nil],
             [NSArray arrayWithObjects:@"0", @"0", @"5", @"0", @"0", nil],
             [NSArray arrayWithObjects:@"0", @"0", @"0", @"0", @"0", nil],
             nil];
        }
        else if (worldId == 5 && levelId == 11)
        {
            boardCells.colorCellSections =
            [NSMutableArray arrayWithObjects:
             [NSArray arrayWithObjects:@"0", @"0", @"0", @"0", @"0", nil],
             [NSArray arrayWithObjects:@"0", @"5", @"0", @"0", @"0", nil],
             [NSArray arrayWithObjects:@"0", @"0", @"5", @"0", @"0", nil],
             [NSArray arrayWithObjects:@"0", @"0", @"0", @"5", @"0", nil],
             [NSArray arrayWithObjects:@"0", @"0", @"0", @"0", @"0", nil],
             nil];
        }
        else if (worldId == 5 && levelId == 12)
        {
            boardCells.colorCellSections =
            [NSMutableArray arrayWithObjects:
             [NSArray arrayWithObjects:@"0", @"0", @"0", @"0", @"0", nil],
             [NSArray arrayWithObjects:@"0", @"5", @"5", @"0", @"0", nil],
             [NSArray arrayWithObjects:@"0", @"5", @"5", @"0", @"0", nil],
             [NSArray arrayWithObjects:@"0", @"0", @"0", @"0", @"0", nil],
             [NSArray arrayWithObjects:@"0", @"0", @"0", @"0", @"0", nil],
             nil];
        }
        else if (worldId == 5 && levelId == 13)
        {
            boardCells.colorCellSections =
            [NSMutableArray arrayWithObjects:
             [NSArray arrayWithObjects:@"0", @"0", @"0", @"0", @"4", nil],
             [NSArray arrayWithObjects:@"4", @"0", @"5", @"0", @"1", nil],
             [NSArray arrayWithObjects:@"0", @"0", @"0", @"0", @"0", nil],
             [NSArray arrayWithObjects:@"0", @"6", @"0", @"0", @"0", nil],
             [NSArray arrayWithObjects:@"0", @"0", @"0", @"4", @"0", nil],
             nil];
            
            boardCells.connectorCellInput = 1;
        }
        else if (worldId == 5 && levelId == 14)
        {
            boardCells.colorCellSections =
            [NSMutableArray arrayWithObjects:
             [NSArray arrayWithObjects:@"0", @"0", @"4", @"0", @"0", nil],
             [NSArray arrayWithObjects:@"0", @"5", @"0", @"0", @"0", nil],
             [NSArray arrayWithObjects:@"0", @"0", @"0", @"0", @"4", nil],
             [NSArray arrayWithObjects:@"0", @"0", @"2", @"0", @"0", nil],
             [NSArray arrayWithObjects:@"4", @"0", @"0", @"0", @"0", nil],
             nil];
            
            boardCells.connectorCellInput = 1;
        }
        else if (worldId == 5 && levelId == 15)
        {
            boardCells.colorCellSections =
            [NSMutableArray arrayWithObjects:
             [NSArray arrayWithObjects:@"0", @"0", @"0", @"0", @"0", nil],
             [NSArray arrayWithObjects:@"0", @"5", @"0", @"0", @"4", nil],
             [NSArray arrayWithObjects:@"6", @"0", @"0", @"6", @"0", nil],
             [NSArray arrayWithObjects:@"0", @"0", @"4", @"0", @"0", nil],
             [NSArray arrayWithObjects:@"0", @"4", @"0", @"0", @"0", nil],
             nil];
            
            boardCells.connectorCellInput = 1;
            [boardCells addZonerValueAt:2 col:0 value:3];
            [boardCells addZonerValueAt:2 col:3 value:1];
        }
        else if (worldId == 5 && levelId == 16)
        {
            boardCells.colorCellSections =
            [NSMutableArray arrayWithObjects:
             [NSArray arrayWithObjects:@"5", @"4", @"0", @"0", @"0", nil],
             [NSArray arrayWithObjects:@"0", @"0", @"0", @"6", @"0", nil],
             [NSArray arrayWithObjects:@"0", @"0", @"4", @"0", @"0", nil],
             [NSArray arrayWithObjects:@"0", @"6", @"0", @"0", @"0", nil],
             [NSArray arrayWithObjects:@"2", @"0", @"0", @"0", @"4", nil],
             nil];
            
            boardCells.connectorCellInput = 3;
            [boardCells addZonerValueAt:3 col:1 value:3];
            [boardCells addZonerValueAt:1 col:3 value:3];
        }
        else if (worldId == 6 && levelId == 1)
        {
            boardCells.colorCellSections =
            [NSMutableArray arrayWithObjects:
            [NSArray arrayWithObjects:@"0", @"0", @"0", nil],
            [NSArray arrayWithObjects:@"0", @"0", @"0", nil],
            [NSArray arrayWithObjects:@"0", @"0", @"3", nil],
            nil];

            [boardCells addZonerValueAt:2 col:2 value:1];
        }
        else if (worldId == 6 && levelId == 2)
        {
            boardCells.colorCellSections =
            [NSMutableArray arrayWithObjects:
            [NSArray arrayWithObjects:@"0", @"0", @"0", nil],
            [NSArray arrayWithObjects:@"0", @"3", @"0", nil],
            [NSArray arrayWithObjects:@"0", @"0", @"0", nil],
            nil];
            
            [boardCells addZonerValueAt:1 col:1 value:1];
        }
        else if (worldId == 6 && levelId == 3)
        {
            boardCells.colorCellSections =
            [NSMutableArray arrayWithObjects:
            [NSArray arrayWithObjects:@"0", @"0", @"0", nil],
            [NSArray arrayWithObjects:@"3", @"0", @"0", nil],
            [NSArray arrayWithObjects:@"0", @"0", @"0", nil],
            nil];
            
            [boardCells addZonerValueAt:1 col:0 value:2];
        }
        else if (worldId == 6 && levelId == 4)
        {
            boardCells.colorCellSections =
            [NSMutableArray arrayWithObjects:
            [NSArray arrayWithObjects:@"0", @"0", @"0", nil],
            [NSArray arrayWithObjects:@"0", @"0", @"0", nil],
            [NSArray arrayWithObjects:@"0", @"3", @"0", nil],
            nil];
            
            [boardCells addZonerValueAt:2 col:1 value:3];
        }
        else if (worldId == 6 && levelId == 5)
        {
            boardCells.colorCellSections =
            [NSMutableArray arrayWithObjects:
            [NSArray arrayWithObjects:@"0", @"0", @"0", @"0", nil],
            [NSArray arrayWithObjects:@"0", @"0", @"0", @"0", nil],
            [NSArray arrayWithObjects:@"3", @"0", @"0", @"3", nil],
            [NSArray arrayWithObjects:@"0", @"0", @"0", @"0", nil],
            nil];
            
            [boardCells addZonerValueAt:2 col:0 value:1];
            [boardCells addZonerValueAt:2 col:3 value:3];
        }
        else if (worldId == 6 && levelId == 6)
        {
            boardCells.colorCellSections =
            [NSMutableArray arrayWithObjects:
            [NSArray arrayWithObjects:@"0", @"0", @"0", @"0", nil],
            [NSArray arrayWithObjects:@"3", @"0", @"0", @"0", nil],
            [NSArray arrayWithObjects:@"0", @"0", @"3", @"0", nil],
            [NSArray arrayWithObjects:@"0", @"0", @"0", @"0", nil],
            nil];
            
            [boardCells addZonerValueAt:1 col:0 value:2];
            [boardCells addZonerValueAt:2 col:2 value:3];
        }
        else if (worldId == 6 && levelId == 7)
        {
            boardCells.colorCellSections =
            [NSMutableArray arrayWithObjects:
            [NSArray arrayWithObjects:@"0", @"0", @"0", @"0", nil],
            [NSArray arrayWithObjects:@"0", @"3", @"0", @"0", nil],
            [NSArray arrayWithObjects:@"0", @"0", @"3", @"0", nil],
            [NSArray arrayWithObjects:@"0", @"0", @"0", @"0", nil],
            nil];
            
            [boardCells addZonerValueAt:1 col:1 value:1];
            [boardCells addZonerValueAt:2 col:2 value:2];
        }
        else if (worldId == 6 && levelId == 8)
        {
            boardCells.colorCellSections =
            [NSMutableArray arrayWithObjects:
            [NSArray arrayWithObjects:@"0", @"0", @"0", @"0", nil],
            [NSArray arrayWithObjects:@"0", @"0", @"3", @"0", nil],
            [NSArray arrayWithObjects:@"0", @"0", @"0", @"0", nil],
            [NSArray arrayWithObjects:@"3", @"0", @"0", @"0", nil],
            nil];
            
            [boardCells addZonerValueAt:3 col:0 value:1];
            [boardCells addZonerValueAt:1 col:2 value:2];
        }
        else if (worldId == 6 && levelId == 9)
        {
            boardCells.colorCellSections =
            [NSMutableArray arrayWithObjects:
             [NSArray arrayWithObjects:@"0", @"0", @"0", @"0", @"0", nil],
             [NSArray arrayWithObjects:@"3", @"0", @"0", @"0", @"0", nil],
             [NSArray arrayWithObjects:@"0", @"0", @"3", @"0", @"0", nil],
             [NSArray arrayWithObjects:@"0", @"0", @"0", @"0", @"3", nil],
             [NSArray arrayWithObjects:@"0", @"0", @"0", @"0", @"0", nil],
             nil];
            
            [boardCells addZonerValueAt:1 col:0 value:1];
            [boardCells addZonerValueAt:2 col:2 value:3];
            [boardCells addZonerValueAt:3 col:4 value:1];
        }
        else if (worldId == 6 && levelId == 10)
        {
            boardCells.colorCellSections =
            [NSMutableArray arrayWithObjects:
             [NSArray arrayWithObjects:@"0", @"0", @"0", @"0", @"0", nil],
             [NSArray arrayWithObjects:@"0", @"0", @"0", @"0", @"0", nil],
             [NSArray arrayWithObjects:@"0", @"3", @"3", @"3", @"0", nil],
             [NSArray arrayWithObjects:@"0", @"0", @"0", @"0", @"0", nil],
             [NSArray arrayWithObjects:@"0", @"0", @"0", @"0", @"0", nil],
             nil];
            
            [boardCells addZonerValueAt:2 col:1 value:3];
            [boardCells addZonerValueAt:2 col:2 value:1];
            [boardCells addZonerValueAt:2 col:3 value:2];
        }
        else if (worldId == 6 && levelId == 11)
        {
            boardCells.colorCellSections =
            [NSMutableArray arrayWithObjects:
             [NSArray arrayWithObjects:@"0", @"0", @"0", @"0", @"3", nil],
             [NSArray arrayWithObjects:@"0", @"0", @"0", @"0", @"0", nil],
             [NSArray arrayWithObjects:@"0", @"0", @"0", @"0", @"0", nil],
             [NSArray arrayWithObjects:@"0", @"0", @"3", @"0", @"0", nil],
             [NSArray arrayWithObjects:@"3", @"0", @"0", @"0", @"0", nil],
             nil];
            
            [boardCells addZonerValueAt:1 col:4 value:3];
            [boardCells addZonerValueAt:3 col:2 value:1];
            [boardCells addZonerValueAt:4 col:0 value:2];
        }
        else if (worldId == 6 && levelId == 12)
        {
            boardCells.colorCellSections =
            [NSMutableArray arrayWithObjects:
             [NSArray arrayWithObjects:@"0", @"0", @"0", @"0", @"0", nil],
             [NSArray arrayWithObjects:@"0", @"0", @"0", @"0", @"0", nil],
             [NSArray arrayWithObjects:@"0", @"3", @"0", @"0", @"3", nil],
             [NSArray arrayWithObjects:@"0", @"0", @"3", @"0", @"0", nil],
             [NSArray arrayWithObjects:@"0", @"0", @"0", @"0", @"0", nil],
             nil];
            
            [boardCells addZonerValueAt:2 col:1 value:1];
            [boardCells addZonerValueAt:3 col:2 value:3];
            [boardCells addZonerValueAt:2 col:4 value:2];
        }
        else if (worldId == 6 && levelId == 13)
        {
            boardCells.colorCellSections =
            [NSMutableArray arrayWithObjects:
             [NSArray arrayWithObjects:@"0", @"0", @"0", @"0", @"0", nil],
             [NSArray arrayWithObjects:@"0", @"1", @"3", @"0", @"0", nil],
             [NSArray arrayWithObjects:@"0", @"0", @"0", @"0", @"0", nil],
             [NSArray arrayWithObjects:@"0", @"0", @"0", @"0", @"0", nil],
             [NSArray arrayWithObjects:@"0", @"0", @"0", @"0", @"0", nil],
             nil];
            
            [boardCells addZonerValueAt:1 col:2 value:1];
        }
        else if (worldId == 6 && levelId == 14)
        {
            boardCells.colorCellSections =
            [NSMutableArray arrayWithObjects:
             [NSArray arrayWithObjects:@"0", @"0", @"0", @"0", @"0", nil],
             [NSArray arrayWithObjects:@"2", @"0", @"0", @"0", @"0", nil],
             [NSArray arrayWithObjects:@"0", @"0", @"0", @"0", @"0", nil],
             [NSArray arrayWithObjects:@"0", @"3", @"0", @"1", @"0", nil],
             [NSArray arrayWithObjects:@"0", @"0", @"0", @"0", @"0", nil],
             nil];
            
            [boardCells addZonerValueAt:3 col:1 value:2];
        }
        else if (worldId == 6 && levelId == 15)
        {
            boardCells.colorCellSections =
            [NSMutableArray arrayWithObjects:
             [NSArray arrayWithObjects:@"0", @"0", @"0", @"0", @"0", nil],
             [NSArray arrayWithObjects:@"0", @"2", @"1", @"0", @"0", nil],
             [NSArray arrayWithObjects:@"0", @"0", @"0", @"0", @"0", nil],
             [NSArray arrayWithObjects:@"0", @"0", @"0", @"3", @"0", nil],
             [NSArray arrayWithObjects:@"0", @"0", @"0", @"0", @"0", nil],
             nil];
            
            [boardCells addZonerValueAt:3 col:3 value:1];
        }
        else if (worldId == 6 && levelId == 16)
        {
            boardCells.colorCellSections =
            [NSMutableArray arrayWithObjects:
             [NSArray arrayWithObjects:@"3", @"0", @"0", @"0", @"0", nil],
             [NSArray arrayWithObjects:@"0", @"0", @"0", @"1", @"0", nil],
             [NSArray arrayWithObjects:@"0", @"0", @"3", @"0", @"0", nil],
             [NSArray arrayWithObjects:@"0", @"2", @"0", @"0", @"0", nil],
             [NSArray arrayWithObjects:@"0", @"0", @"0", @"0", @"3", nil],
             nil];
            
            [boardCells addZonerValueAt:0 col:0 value:3];
            [boardCells addZonerValueAt:2 col:2 value:2];
            [boardCells addZonerValueAt:4 col:4 value:1];
        }
        else if (worldId == 7 && levelId == 1)
        {
            boardCells.colorCellSections =
            [NSMutableArray arrayWithObjects:
             [NSArray arrayWithObjects:@"0", @"0", @"0", nil],
             [NSArray arrayWithObjects:@"0", @"7", @"0", nil],
             [NSArray arrayWithObjects:@"0", @"0", @"0", nil],
             nil];
            
            [boardCells setConverterDirectionAt:1 col:1 isDirectionRight:1];
        }
        else if (worldId == 7 && levelId == 2)
        {
            boardCells.colorCellSections =
            [NSMutableArray arrayWithObjects:
             [NSArray arrayWithObjects:@"0", @"0", @"0", nil],
             [NSArray arrayWithObjects:@"0", @"7", @"0", nil],
             [NSArray arrayWithObjects:@"0", @"0", @"0", nil],
             nil];
            
            [boardCells setConverterDirectionAt:1 col:1 isDirectionRight:0];
        }
        else if (worldId == 7 && levelId == 3)
        {
            boardCells.colorCellSections =
            [NSMutableArray arrayWithObjects:
             [NSArray arrayWithObjects:@"0", @"0", @"0", nil],
             [NSArray arrayWithObjects:@"0", @"7", @"0", nil],
             [NSArray arrayWithObjects:@"0", @"0", @"0", nil],
             nil];
        }
        else if (worldId == 7 && levelId == 4)
        {
            boardCells.colorCellSections =
            [NSMutableArray arrayWithObjects:
             [NSArray arrayWithObjects:@"0", @"0", @"0", nil],
             [NSArray arrayWithObjects:@"0", @"7", @"0", nil],
             [NSArray arrayWithObjects:@"0", @"0", @"0", nil],
             nil];
        }
        else if (worldId == 7 && levelId == 5)
        {
            boardCells.colorCellSections =
            [NSMutableArray arrayWithObjects:
             [NSArray arrayWithObjects:@"0", @"0", @"0", @"0", nil],
             [NSArray arrayWithObjects:@"0", @"7", @"0", @"0", nil],
             [NSArray arrayWithObjects:@"0", @"0", @"7", @"0", nil],
             [NSArray arrayWithObjects:@"0", @"0", @"0", @"0", nil],
             nil];
        }
        else if (worldId == 7 && levelId == 6)
        {
            boardCells.colorCellSections =
            [NSMutableArray arrayWithObjects:
             [NSArray arrayWithObjects:@"0", @"0", @"0", @"0", nil],
             [NSArray arrayWithObjects:@"0", @"0", @"0", @"7", nil],
             [NSArray arrayWithObjects:@"0", @"7", @"0", @"0", nil],
             [NSArray arrayWithObjects:@"0", @"0", @"0", @"0", nil],
             nil];
        }
        else if (worldId == 7 && levelId == 7)
        {
            boardCells.colorCellSections =
            [NSMutableArray arrayWithObjects:
             [NSArray arrayWithObjects:@"0", @"0", @"0", @"0", nil],
             [NSArray arrayWithObjects:@"0", @"0", @"7", @"0", nil],
             [NSArray arrayWithObjects:@"0", @"7", @"0", @"0", nil],
             [NSArray arrayWithObjects:@"0", @"0", @"0", @"0", nil],
             nil];
        }
        else if (worldId == 7 && levelId == 8)
        {
            boardCells.colorCellSections =
            [NSMutableArray arrayWithObjects:
             [NSArray arrayWithObjects:@"0", @"0", @"0", @"0", nil],
             [NSArray arrayWithObjects:@"7", @"0", @"7", @"0", nil],
             [NSArray arrayWithObjects:@"0", @"0", @"0", @"0", nil],
             [NSArray arrayWithObjects:@"0", @"0", @"0", @"0", nil],
             nil];
        }
        else if (worldId == 7 && levelId == 9)
        {
            boardCells.colorCellSections =
            [NSMutableArray arrayWithObjects:
             [NSArray arrayWithObjects:@"0", @"0", @"0", @"0", @"0", nil],
             [NSArray arrayWithObjects:@"0", @"7", @"0", @"0", @"0", nil],
             [NSArray arrayWithObjects:@"0", @"0", @"7", @"0", @"0", nil],
             [NSArray arrayWithObjects:@"0", @"0", @"0", @"7", @"0", nil],
             [NSArray arrayWithObjects:@"0", @"0", @"0", @"0", @"0", nil],
             nil];
        }
        else if (worldId == 7 && levelId == 10)
        {
            boardCells.colorCellSections =
            [NSMutableArray arrayWithObjects:
             [NSArray arrayWithObjects:@"0", @"0", @"0", @"0", @"0", nil],
             [NSArray arrayWithObjects:@"0", @"0", @"0", @"0", @"7", nil],
             [NSArray arrayWithObjects:@"0", @"0", @"0", @"0", @"0", nil],
             [NSArray arrayWithObjects:@"0", @"7", @"0", @"0", @"0", nil],
             [NSArray arrayWithObjects:@"0", @"0", @"7", @"0", @"0", nil],
             nil];
        }
        else if (worldId == 7 && levelId == 11)
        {
            boardCells.colorCellSections =
            [NSMutableArray arrayWithObjects:
             [NSArray arrayWithObjects:@"0", @"0", @"0", @"0", @"0", nil],
             [NSArray arrayWithObjects:@"0", @"0", @"7", @"0", @"0", nil],
             [NSArray arrayWithObjects:@"7", @"0", @"0", @"7", @"0", nil],
             [NSArray arrayWithObjects:@"0", @"0", @"0", @"0", @"0", nil],
             [NSArray arrayWithObjects:@"0", @"0", @"0", @"0", @"0", nil],
             nil];
        }
        else if (worldId == 7 && levelId == 12)
        {
            boardCells.colorCellSections =
            [NSMutableArray arrayWithObjects:
             [NSArray arrayWithObjects:@"0", @"0", @"0", @"0", @"0", nil],
             [NSArray arrayWithObjects:@"0", @"7", @"0", @"7", @"0", nil],
             [NSArray arrayWithObjects:@"0", @"0", @"0", @"0", @"0", nil],
             [NSArray arrayWithObjects:@"0", @"7", @"0", @"7", @"0", nil],
             [NSArray arrayWithObjects:@"0", @"0", @"0", @"0", @"0", nil],
             nil];
        }
        else if (worldId == 7 && levelId == 13)
        {
            boardCells.colorCellSections =
            [NSMutableArray arrayWithObjects:
             [NSArray arrayWithObjects:@"0", @"0", @"0", @"0", @"0", nil],
             [NSArray arrayWithObjects:@"0", @"7", @"0", @"5", @"0", nil],
             [NSArray arrayWithObjects:@"0", @"0", @"0", @"0", @"0", nil],
             [NSArray arrayWithObjects:@"0", @"0", @"3", @"0", @"4", nil],
             [NSArray arrayWithObjects:@"4", @"0", @"0", @"0", @"0", nil],
             nil];
            
            [boardCells addZonerValueAt:3 col:2 value:3];
            boardCells.connectorCellInput = 3;
        }
        else if (worldId == 7 && levelId == 14)
        {
            boardCells.colorCellSections =
            [NSMutableArray arrayWithObjects:
             [NSArray arrayWithObjects:@"0", @"0", @"0", @"0", @"0", nil],
             [NSArray arrayWithObjects:@"0", @"0", @"2", @"0", @"6", nil],
             [NSArray arrayWithObjects:@"0", @"7", @"0", @"0", @"0", nil],
             [NSArray arrayWithObjects:@"0", @"0", @"7", @"0", @"0", nil],
             [NSArray arrayWithObjects:@"0", @"0", @"0", @"0", @"0", nil],
             nil];
            
            [boardCells addSplitterValueAt:1 col:4 value:1];
        }
        else if (worldId == 7 && levelId == 15)
        {
            boardCells.colorCellSections =
            [NSMutableArray arrayWithObjects:
             [NSArray arrayWithObjects:@"0", @"0", @"0", @"0", @"0", nil],
             [NSArray arrayWithObjects:@"0", @"5", @"7", @"0", @"0", nil],
             [NSArray arrayWithObjects:@"0", @"7", @"0", @"0", @"0", nil],
             [NSArray arrayWithObjects:@"0", @"0", @"0", @"3", @"0", nil],
             [NSArray arrayWithObjects:@"0", @"0", @"0", @"0", @"0", nil],
             nil];
            
            [boardCells addZonerValueAt:3 col:3 value:2];
        }
        else if (worldId == 7 && levelId == 16)
        {
            boardCells.colorCellSections =
            [NSMutableArray arrayWithObjects:
             [NSArray arrayWithObjects:@"4", @"0", @"0", @"0", @"0", nil],
             [NSArray arrayWithObjects:@"7", @"0", @"1", @"0", @"0", nil],
             [NSArray arrayWithObjects:@"0", @"0", @"0", @"0", @"4", nil],
             [NSArray arrayWithObjects:@"0", @"2", @"7", @"0", @"0", nil],
             [NSArray arrayWithObjects:@"0", @"4", @"0", @"0", @"0", nil],
             nil];
            
            boardCells.connectorCellInput = 2;
        }
        else if (worldId == 8 && levelId == 1)
        {
            boardCells.colorCellSections =
            [NSMutableArray arrayWithObjects:
             [NSArray arrayWithObjects:@"0", @"0", @"11", nil],
             [NSArray arrayWithObjects:@"0", @"8", @"0", nil],
             [NSArray arrayWithObjects:@"0", @"0", @"0", nil],
             nil];
        }
        else if (worldId == 8 && levelId == 2)
        {
            boardCells.colorCellSections =
            [NSMutableArray arrayWithObjects:
             [NSArray arrayWithObjects:@"0", @"11", @"0", nil],
             [NSArray arrayWithObjects:@"0", @"0", @"0", nil],
             [NSArray arrayWithObjects:@"9", @"0", @"0", nil],
             nil];
        }
        else if (worldId == 8 && levelId == 3)
        {
            boardCells.colorCellSections =
            [NSMutableArray arrayWithObjects:
             [NSArray arrayWithObjects:@"0", @"0", @"8", nil],
             [NSArray arrayWithObjects:@"10", @"0", @"0", nil],
             [NSArray arrayWithObjects:@"0", @"0", @"0", nil],
             nil];
        }
        else if (worldId == 8 && levelId == 4)
        {
            boardCells.colorCellSections =
            [NSMutableArray arrayWithObjects:
             [NSArray arrayWithObjects:@"0", @"11", @"0", nil],
             [NSArray arrayWithObjects:@"0", @"0", @"0", nil],
             [NSArray arrayWithObjects:@"9", @"0", @"9", nil],
             nil];
        }
        else if (worldId == 8 && levelId == 5)
        {
            boardCells.colorCellSections =
            [NSMutableArray arrayWithObjects:
             [NSArray arrayWithObjects:@"0", @"0", @"0", @"0", nil],
             [NSArray arrayWithObjects:@"0", @"0", @"8", @"0", nil],
             [NSArray arrayWithObjects:@"0", @"10", @"0", @"0", nil],
             [NSArray arrayWithObjects:@"0", @"0", @"0", @"0", nil],
             nil];
        }
        else if (worldId == 8 && levelId == 6)
        {
            boardCells.colorCellSections =
            [NSMutableArray arrayWithObjects:
             [NSArray arrayWithObjects:@"0", @"0", @"11", @"0", nil],
             [NSArray arrayWithObjects:@"0", @"9", @"0", @"0", nil],
             [NSArray arrayWithObjects:@"0", @"0", @"0", @"0", nil],
             [NSArray arrayWithObjects:@"0", @"0", @"0", @"0", nil],
             nil];
        }
        else if (worldId == 8 && levelId == 7)
        {
            boardCells.colorCellSections =
            [NSMutableArray arrayWithObjects:
             [NSArray arrayWithObjects:@"0", @"8", @"0", @"11", nil],
             [NSArray arrayWithObjects:@"0", @"0", @"0", @"0", nil],
             [NSArray arrayWithObjects:@"0", @"0", @"0", @"0", nil],
             [NSArray arrayWithObjects:@"0", @"8", @"0", @"0", nil],
             nil];
        }
        else if (worldId == 8 && levelId == 8)
        {
            boardCells.colorCellSections =
            [NSMutableArray arrayWithObjects:
             [NSArray arrayWithObjects:@"0", @"0", @"0", @"0", nil],
             [NSArray arrayWithObjects:@"11", @"11", @"11", @"0", nil],
             [NSArray arrayWithObjects:@"0", @"0", @"0", @"0", nil],
             [NSArray arrayWithObjects:@"0", @"0", @"0", @"9", nil],
             nil];
        }
        else if (worldId == 8 && levelId == 9)
        {
            boardCells.colorCellSections =
            [NSMutableArray arrayWithObjects:
             [NSArray arrayWithObjects:@"0", @"0", @"0", @"11", @"0", nil],
             [NSArray arrayWithObjects:@"11", @"0", @"0", @"0", @"0", nil],
             [NSArray arrayWithObjects:@"0", @"0", @"8", @"0", @"0", nil],
             [NSArray arrayWithObjects:@"0", @"0", @"0", @"0", @"0", nil],
             [NSArray arrayWithObjects:@"0", @"0", @"0", @"0", @"0", nil],
             nil];
        }
        else if (worldId == 8 && levelId == 10)
        {
            boardCells.colorCellSections =
            [NSMutableArray arrayWithObjects:
             [NSArray arrayWithObjects:@"0", @"0", @"0", @"0", @"0", nil],
             [NSArray arrayWithObjects:@"0", @"0", @"10", @"0", @"0", nil],
             [NSArray arrayWithObjects:@"9", @"0", @"0", @"0", @"0", nil],
             [NSArray arrayWithObjects:@"0", @"0", @"10", @"0", @"0", nil],
             [NSArray arrayWithObjects:@"0", @"0", @"0", @"0", @"0", nil],
             nil];
        }
        else if (worldId == 8 && levelId == 11)
        {
            boardCells.colorCellSections =
            [NSMutableArray arrayWithObjects:
             [NSArray arrayWithObjects:@"0", @"0", @"10", @"0", @"0", nil],
             [NSArray arrayWithObjects:@"0", @"0", @"0", @"0", @"0", nil],
             [NSArray arrayWithObjects:@"0", @"9", @"0", @"11", @"0", nil],
             [NSArray arrayWithObjects:@"0", @"0", @"0", @"0", @"0", nil],
             [NSArray arrayWithObjects:@"0", @"0", @"8", @"0", @"0", nil],
             nil];
        }
        else if (worldId == 8 && levelId == 12)
        {
            boardCells.colorCellSections =
            [NSMutableArray arrayWithObjects:
             [NSArray arrayWithObjects:@"0", @"0", @"0", @"0", @"8", nil],
             [NSArray arrayWithObjects:@"9", @"0", @"0", @"0", @"0", nil],
             [NSArray arrayWithObjects:@"0", @"0", @"0", @"11", @"0", nil],
             [NSArray arrayWithObjects:@"0", @"0", @"0", @"0", @"0", nil],
             [NSArray arrayWithObjects:@"10", @"0", @"0", @"0", @"0", nil],
             nil];
        }
        else if (worldId == 8 && levelId == 13)
        {
            boardCells.colorCellSections =
            [NSMutableArray arrayWithObjects:
             [NSArray arrayWithObjects:@"0", @"0", @"0", @"0", @"8", nil],
             [NSArray arrayWithObjects:@"0", @"0", @"0", @"11", @"0", nil],
             [NSArray arrayWithObjects:@"0", @"0", @"5", @"0", @"0", nil],
             [NSArray arrayWithObjects:@"0", @"10", @"0", @"0", @"0", nil],
             [NSArray arrayWithObjects:@"9", @"0", @"0", @"0", @"0", nil],
             nil];
        }
        else if (worldId == 8 && levelId == 14)
        {
            boardCells.colorCellSections =
            [NSMutableArray arrayWithObjects:
             [NSArray arrayWithObjects:@"11", @"0", @"0", @"0", @"0", nil],
             [NSArray arrayWithObjects:@"0", @"0", @"0", @"8", @"0", nil],
             [NSArray arrayWithObjects:@"0", @"3", @"0", @"0", @"0", nil],
             [NSArray arrayWithObjects:@"0", @"0", @"0", @"8", @"0", nil],
             [NSArray arrayWithObjects:@"0", @"0", @"0", @"0", @"0", nil],
             nil];
            
            [boardCells addZonerValueAt:2 col:1 value:2];
        }
        else if (worldId == 8 && levelId == 15)
        {
            boardCells.colorCellSections =
            [NSMutableArray arrayWithObjects:
             [NSArray arrayWithObjects:@"0", @"0", @"0", @"0", @"0", nil],
             [NSArray arrayWithObjects:@"0", @"10", @"7", @"0", @"0", nil],
             [NSArray arrayWithObjects:@"0", @"0", @"0", @"0", @"0", nil],
             [NSArray arrayWithObjects:@"0", @"0", @"0", @"9", @"0", nil],
             [NSArray arrayWithObjects:@"0", @"8", @"0", @"0", @"0", nil],
             nil];
        }
        else if (worldId == 8 && levelId == 16)
        {
            boardCells.colorCellSections =
            [NSMutableArray arrayWithObjects:
             [NSArray arrayWithObjects:@"8", @"0", @"0", @"0", @"0", nil],
             [NSArray arrayWithObjects:@"0", @"0", @"11", @"0", @"4", nil],
             [NSArray arrayWithObjects:@"0", @"0", @"0", @"0", @"0", nil],
             [NSArray arrayWithObjects:@"4", @"8", @"0", @"0", @"0", nil],
             [NSArray arrayWithObjects:@"0", @"0", @"4", @"0", @"0", nil],
             nil];
            
            boardCells.connectorCellInput = 3;
        }
    }
    
    return boardCells;
}

+(void)GetBoardStatesForLevel:(int)worldId levelId:(int)levelId topColorsState:(NSMutableArray*)topColorsState leftColorsState:(NSMutableArray*)leftColorsState
{
    [topColorsState removeAllObjects];
    [leftColorsState removeAllObjects];
    
    if (worldId == 1 && levelId == 1)
    {
        [topColorsState addObjectsFromArray:[NSArray arrayWithObjects:@"1", @"2", @"3", nil]];
        [leftColorsState addObjectsFromArray:[NSArray arrayWithObjects:@"0", @"0", @"0", nil]];
    }
    else if (worldId == 1 && levelId == 2)
    {
        [topColorsState addObjectsFromArray:[NSArray arrayWithObjects:@"1", @"0", @"3", nil]];
        [leftColorsState addObjectsFromArray:[NSArray arrayWithObjects:@"1", @"0", @"3", nil]];
    }
    else if (worldId == 1 && levelId == 3)
    {
        [topColorsState addObjectsFromArray:[NSArray arrayWithObjects:@"3", @"0", @"3", nil]];
        [leftColorsState addObjectsFromArray:[NSArray arrayWithObjects:@"2", @"2", @"2", nil]];
    }
    else if (worldId == 1 && levelId == 4)
    {
        [topColorsState addObjectsFromArray:[NSArray arrayWithObjects:@"0", @"1", @"2", nil]];
        [leftColorsState addObjectsFromArray:[NSArray arrayWithObjects:@"1", @"2", @"0", nil]];
    }
    else if (worldId == 1 && levelId == 5)
    {
        [topColorsState addObjectsFromArray:[NSArray arrayWithObjects:@"3", @"1", @"1", @"2", nil]];
        [leftColorsState addObjectsFromArray:[NSArray arrayWithObjects:@"2", @"3", @"0", @"0", nil]];
    }
    else if (worldId == 1 && levelId == 6)
    {
        [topColorsState addObjectsFromArray:[NSArray arrayWithObjects:@"1", @"0", @"3", @"2", nil]];
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
    else if (worldId == 2 && levelId == 1)
    {
        [topColorsState addObjectsFromArray:[NSArray arrayWithObjects:@"0", @"0", @"0", nil]];
        [leftColorsState addObjectsFromArray:[NSArray arrayWithObjects:@"3", @"0", @"2", nil]];
    }
    else if (worldId == 2 && levelId == 2)
    {
        [topColorsState addObjectsFromArray:[NSArray arrayWithObjects:@"0", @"3", @"1", nil]];
        [leftColorsState addObjectsFromArray:[NSArray arrayWithObjects:@"2", @"0", @"0", nil]];
    }
    else if (worldId == 2 && levelId == 3)
    {
        [topColorsState addObjectsFromArray:[NSArray arrayWithObjects:@"3", @"2", @"0", nil]];
        [leftColorsState addObjectsFromArray:[NSArray arrayWithObjects:@"1", @"3", @"2", nil]];
    }
    else if (worldId == 2 && levelId == 4)
    {
        [topColorsState addObjectsFromArray:[NSArray arrayWithObjects:@"3", @"1", @"1", nil]];
        [leftColorsState addObjectsFromArray:[NSArray arrayWithObjects:@"2", @"2", @"3", nil]];
    }
    else if (worldId == 2 && levelId == 5)
    {
        [topColorsState addObjectsFromArray:[NSArray arrayWithObjects:@"1", @"2", @"1", @"3", nil]];
        [leftColorsState addObjectsFromArray:[NSArray arrayWithObjects:@"3", @"1", @"1", @"2", nil]];
    }
    else if (worldId == 2 && levelId == 6)
    {
        [topColorsState addObjectsFromArray:[NSArray arrayWithObjects:@"1", @"3", @"3", @"2", nil]];
        [leftColorsState addObjectsFromArray:[NSArray arrayWithObjects:@"2", @"3", @"1", @"2", nil]];
    }
    else if (worldId == 2 && levelId == 7)
    {
        [topColorsState addObjectsFromArray:[NSArray arrayWithObjects:@"3", @"2", @"1", @"0", nil]];
        [leftColorsState addObjectsFromArray:[NSArray arrayWithObjects:@"1", @"2", @"3", @"1", nil]];
    }
    else if (worldId == 2 && levelId == 8)
    {
        [topColorsState addObjectsFromArray:[NSArray arrayWithObjects:@"3", @"2", @"1", @"3", nil]];
        [leftColorsState addObjectsFromArray:[NSArray arrayWithObjects:@"2", @"1", @"0", @"2", nil]];
    }
    else if (worldId == 2 && levelId == 9)
    {
        [topColorsState addObjectsFromArray:[NSArray arrayWithObjects:@"1", @"2", @"0", @"3", @"1", nil]];
        [leftColorsState addObjectsFromArray:[NSArray arrayWithObjects:@"2", @"1", @"3", @"2", @"1", nil]];
    }
    else if (worldId == 2 && levelId == 10)
    {
        [topColorsState addObjectsFromArray:[NSArray arrayWithObjects:@"3", @"1", @"2", @"1", @"2", nil]];
        [leftColorsState addObjectsFromArray:[NSArray arrayWithObjects:@"1", @"3", @"2", @"3", @"2", nil]];
    }
    else if (worldId == 2 && levelId == 11)
    {
        [topColorsState addObjectsFromArray:[NSArray arrayWithObjects:@"2", @"1", @"1", @"2", @"3", nil]];
        [leftColorsState addObjectsFromArray:[NSArray arrayWithObjects:@"3", @"2", @"1", @"3", @"2", nil]];
    }
    else if (worldId == 2 && levelId == 12)
    {
        [topColorsState addObjectsFromArray:[NSArray arrayWithObjects:@"0", @"2", @"3", @"2", @"1", nil]];
        [leftColorsState addObjectsFromArray:[NSArray arrayWithObjects:@"2", @"3", @"2", @"1", @"3", nil]];
    }
    else if (worldId == 2 && levelId == 13)
    {
        [topColorsState addObjectsFromArray:[NSArray arrayWithObjects:@"1", @"3", @"2", @"3", @"2", nil]];
        [leftColorsState addObjectsFromArray:[NSArray arrayWithObjects:@"1", @"2", @"3", @"1", @"2", nil]];
    }
    else if (worldId == 2 && levelId == 14)
    {
        [topColorsState addObjectsFromArray:[NSArray arrayWithObjects:@"2", @"1", @"3", @"2", @"3", nil]];
        [leftColorsState addObjectsFromArray:[NSArray arrayWithObjects:@"3", @"2", @"1", @"1", @"2", nil]];
    }
    else if (worldId == 2 && levelId == 15)
    {
        [topColorsState addObjectsFromArray:[NSArray arrayWithObjects:@"2", @"3", @"2", @"0", @"2", nil]];
        [leftColorsState addObjectsFromArray:[NSArray arrayWithObjects:@"1", @"3", @"0", @"1", @"2", nil]];
    }
    else if (worldId == 2 && levelId == 16)
    {
        [topColorsState addObjectsFromArray:[NSArray arrayWithObjects:@"3", @"1", @"2", @"2", @"0", nil]];
        [leftColorsState addObjectsFromArray:[NSArray arrayWithObjects:@"1", @"3", @"2", @"2", @"0", nil]];
    }
    else if (worldId == 3 && levelId == 1)
    {
        [topColorsState addObjectsFromArray:[NSArray arrayWithObjects:@"3", @"0", @"2", nil]];
        [leftColorsState addObjectsFromArray:[NSArray arrayWithObjects:@"0", @"0", @"0", nil]];
    }
    else if (worldId == 3 && levelId == 2)
    {
        [topColorsState addObjectsFromArray:[NSArray arrayWithObjects:@"0", @"2", @"0", nil]];
        [leftColorsState addObjectsFromArray:[NSArray arrayWithObjects:@"0", @"0", @"0", nil]];
    }
    else if (worldId == 3 && levelId == 3)
    {
        [topColorsState addObjectsFromArray:[NSArray arrayWithObjects:@"0", @"0", @"3", nil]];
        [leftColorsState addObjectsFromArray:[NSArray arrayWithObjects:@"1", @"0", @"0", nil]];
    }
    else if (worldId == 3 && levelId == 4)
    {
        [topColorsState addObjectsFromArray:[NSArray arrayWithObjects:@"0", @"2", @"0", nil]];
        [leftColorsState addObjectsFromArray:[NSArray arrayWithObjects:@"0", @"0", @"0", nil]];
    }
    else if (worldId == 3 && levelId == 5)
    {
        [topColorsState addObjectsFromArray:[NSArray arrayWithObjects:@"2", @"0", @"3", @"0", nil]];
        [leftColorsState addObjectsFromArray:[NSArray arrayWithObjects:@"0", @"0", @"1", @"0", nil]];
    }
    else if (worldId == 3 && levelId == 6)
    {
        [topColorsState addObjectsFromArray:[NSArray arrayWithObjects:@"0", @"1", @"0", @"3", nil]];
        [leftColorsState addObjectsFromArray:[NSArray arrayWithObjects:@"3", @"0", @"0", @"2", nil]];
    }
    else if (worldId == 3 && levelId == 7)
    {
        [topColorsState addObjectsFromArray:[NSArray arrayWithObjects:@"0", @"2", @"0", @"1", nil]];
        [leftColorsState addObjectsFromArray:[NSArray arrayWithObjects:@"0", @"2", @"3", @"0", nil]];
    }
    else if (worldId == 3 && levelId == 8)
    {
        [topColorsState addObjectsFromArray:[NSArray arrayWithObjects:@"1", @"3", @"2", @"1", nil]];
        [leftColorsState addObjectsFromArray:[NSArray arrayWithObjects:@"2", @"3", @"1", @"2", nil]];
    }
    else if (worldId == 3 && levelId == 9)
    {
        [topColorsState addObjectsFromArray:[NSArray arrayWithObjects:@"1", @"3", @"1", @"2", @"3", nil]];
        [leftColorsState addObjectsFromArray:[NSArray arrayWithObjects:@"2", @"3", @"1", @"2", @"3", nil]];
    }
    else if (worldId == 3 && levelId == 10)
    {
        [topColorsState addObjectsFromArray:[NSArray arrayWithObjects:@"2", @"3", @"1", @"2", @"1", nil]];
        [leftColorsState addObjectsFromArray:[NSArray arrayWithObjects:@"3", @"2", @"3", @"1", @"2", nil]];
    }
    else if (worldId == 3 && levelId == 11)
    {
        [topColorsState addObjectsFromArray:[NSArray arrayWithObjects:@"3", @"1", @"2", @"3", @"1", nil]];
        [leftColorsState addObjectsFromArray:[NSArray arrayWithObjects:@"1", @"2", @"3", @"2", @"1", nil]];
    }
    else if (worldId == 3 && levelId == 12)
    {
        [topColorsState addObjectsFromArray:[NSArray arrayWithObjects:@"3", @"2", @"1", @"1", @"2", nil]];
        [leftColorsState addObjectsFromArray:[NSArray arrayWithObjects:@"2", @"3", @"2", @"3", @"1", nil]];
    }
    else if (worldId == 3 && levelId == 13)
    {
        [topColorsState addObjectsFromArray:[NSArray arrayWithObjects:@"2", @"1", @"2", @"3", @"2", nil]];
        [leftColorsState addObjectsFromArray:[NSArray arrayWithObjects:@"3", @"1", @"3", @"1", @"2", nil]];
    }
    else if (worldId == 3 && levelId == 14)
    {
        [topColorsState addObjectsFromArray:[NSArray arrayWithObjects:@"1", @"2", @"3", @"2", @"3", nil]];
        [leftColorsState addObjectsFromArray:[NSArray arrayWithObjects:@"1", @"2", @"1", @"0", @"3", nil]];
    }
    else if (worldId == 3 && levelId == 15)
    {
        [topColorsState addObjectsFromArray:[NSArray arrayWithObjects:@"3", @"2", @"1", @"3", @"1", nil]];
        [leftColorsState addObjectsFromArray:[NSArray arrayWithObjects:@"2", @"3", @"1", @"3", @"2", nil]];
    }
    else if (worldId == 3 && levelId == 16)
    {
        [topColorsState addObjectsFromArray:[NSArray arrayWithObjects:@"2", @"3", @"0", @"1", @"2", nil]];
        [leftColorsState addObjectsFromArray:[NSArray arrayWithObjects:@"3", @"2", @"1", @"3", @"2", nil]];
    }
    else if (worldId == 4 && levelId == 1)
    {
        [topColorsState addObjectsFromArray:[NSArray arrayWithObjects:@"0", @"0", @"0", nil]];
        [leftColorsState addObjectsFromArray:[NSArray arrayWithObjects:@"0", @"0", @"2", nil]];
    }
    else if (worldId == 4 && levelId == 2)
    {
        [topColorsState addObjectsFromArray:[NSArray arrayWithObjects:@"0", @"0", @"2", nil]];
        [leftColorsState addObjectsFromArray:[NSArray arrayWithObjects:@"1", @"3", @"2", nil]];
    }
    else if (worldId == 4 && levelId == 3)
    {
        [topColorsState addObjectsFromArray:[NSArray arrayWithObjects:@"1", @"3", @"3", nil]];
        [leftColorsState addObjectsFromArray:[NSArray arrayWithObjects:@"1", @"3", @"2", nil]];
    }
    else if (worldId == 4 && levelId == 4)
    {
        [topColorsState addObjectsFromArray:[NSArray arrayWithObjects:@"1", @"2", @"1", nil]];
        [leftColorsState addObjectsFromArray:[NSArray arrayWithObjects:@"2", @"2", @"1", nil]];
    }
    else if (worldId == 4 && levelId == 5)
    {
        [topColorsState addObjectsFromArray:[NSArray arrayWithObjects:@"2", @"3", @"1", @"2", nil]];
        [leftColorsState addObjectsFromArray:[NSArray arrayWithObjects:@"2", @"0", @"1", @"3", nil]];
    }
    else if (worldId == 4 && levelId == 6)
    {
        [topColorsState addObjectsFromArray:[NSArray arrayWithObjects:@"1", @"3", @"2", @"3", nil]];
        [leftColorsState addObjectsFromArray:[NSArray arrayWithObjects:@"3", @"2", @"1", @"2", nil]];
    }
    else if (worldId == 4 && levelId == 7)
    {
        [topColorsState addObjectsFromArray:[NSArray arrayWithObjects:@"3", @"2", @"1", @"2", nil]];
        [leftColorsState addObjectsFromArray:[NSArray arrayWithObjects:@"1", @"2", @"1", @"3", nil]];
    }
    else if (worldId == 4 && levelId == 8)
    {
        [topColorsState addObjectsFromArray:[NSArray arrayWithObjects:@"2", @"1", @"3", @"1", nil]];
        [leftColorsState addObjectsFromArray:[NSArray arrayWithObjects:@"1", @"3", @"2", @"3", nil]];
    }
    else if (worldId == 4 && levelId == 9)
    {
        [topColorsState addObjectsFromArray:[NSArray arrayWithObjects:@"1", @"2", @"3", @"3", @"1", nil]];
        [leftColorsState addObjectsFromArray:[NSArray arrayWithObjects:@"2", @"3", @"2", @"1", @"3", nil]];
    }
    else if (worldId == 4 && levelId == 10)
    {
        [topColorsState addObjectsFromArray:[NSArray arrayWithObjects:@"3", @"1", @"2", @"1", @"2", nil]];
        [leftColorsState addObjectsFromArray:[NSArray arrayWithObjects:@"1", @"2", @"1", @"3", @"2", nil]];
    }
    else if (worldId == 4 && levelId == 11)
    {
        [topColorsState addObjectsFromArray:[NSArray arrayWithObjects:@"2", @"3", @"1", @"2", @"3", nil]];
        [leftColorsState addObjectsFromArray:[NSArray arrayWithObjects:@"1", @"2", @"3", @"1", @"2", nil]];
    }
    else if (worldId == 4 && levelId == 12)
    {
        [topColorsState addObjectsFromArray:[NSArray arrayWithObjects:@"3", @"2", @"1", @"3", @"2", nil]];
        [leftColorsState addObjectsFromArray:[NSArray arrayWithObjects:@"1", @"2", @"1", @"3", @"2", nil]];
    }
    else if (worldId == 4 && levelId == 13)
    {
        [topColorsState addObjectsFromArray:[NSArray arrayWithObjects:@"1", @"3", @"2", @"1", @"3", nil]];
        [leftColorsState addObjectsFromArray:[NSArray arrayWithObjects:@"2", @"3", @"1", @"2", @"1", nil]];
    }
    else if (worldId == 4 && levelId == 14)
    {
        [topColorsState addObjectsFromArray:[NSArray arrayWithObjects:@"1", @"2", @"1", @"3", @"2", nil]];
        [leftColorsState addObjectsFromArray:[NSArray arrayWithObjects:@"3", @"2", @"1", @"2", @"3", nil]];
    }
    else if (worldId == 4 && levelId == 15)
    {
        [topColorsState addObjectsFromArray:[NSArray arrayWithObjects:@"2", @"1", @"0", @"3", @"1", nil]];
        [leftColorsState addObjectsFromArray:[NSArray arrayWithObjects:@"1", @"2", @"1", @"2", @"3", nil]];
    }
    else if (worldId == 4 && levelId == 16)
    {
        [topColorsState addObjectsFromArray:[NSArray arrayWithObjects:@"3", @"2", @"3", @"2", @"0", nil]];
        [leftColorsState addObjectsFromArray:[NSArray arrayWithObjects:@"1", @"2", @"3", @"2", @"0", nil]];
    }
    else if (worldId == 5 && levelId == 1)
    {
        [topColorsState addObjectsFromArray:[NSArray arrayWithObjects:@"0", @"3", @"0", nil]];
        [leftColorsState addObjectsFromArray:[NSArray arrayWithObjects:@"0", @"1", @"0", nil]];
    }
    else if (worldId == 5 && levelId == 2)
    {
        [topColorsState addObjectsFromArray:[NSArray arrayWithObjects:@"3", @"0", @"1", nil]];
        [leftColorsState addObjectsFromArray:[NSArray arrayWithObjects:@"2", @"0", @"1", nil]];
    }
    else if (worldId == 5 && levelId == 3)
    {
        [topColorsState addObjectsFromArray:[NSArray arrayWithObjects:@"1", @"2", @"0", nil]];
        [leftColorsState addObjectsFromArray:[NSArray arrayWithObjects:@"0", @"3", @"2", nil]];
    }
    else if (worldId == 5 && levelId == 4)
    {
        [topColorsState addObjectsFromArray:[NSArray arrayWithObjects:@"0", @"3", @"1", nil]];
        [leftColorsState addObjectsFromArray:[NSArray arrayWithObjects:@"1", @"2", @"3", nil]];
    }
    else if (worldId == 5 && levelId == 5)
    {
        [topColorsState addObjectsFromArray:[NSArray arrayWithObjects:@"0", @"3", @"2", @"1", nil]];
        [leftColorsState addObjectsFromArray:[NSArray arrayWithObjects:@"0", @"1", @"3", @"2", nil]];
    }
    else if (worldId == 5 && levelId == 6)
    {
        [topColorsState addObjectsFromArray:[NSArray arrayWithObjects:@"1", @"1", @"2", @"3", nil]];
        [leftColorsState addObjectsFromArray:[NSArray arrayWithObjects:@"3", @"1", @"2", @"0", nil]];
    }
    else if (worldId == 5 && levelId == 7)
    {
        [topColorsState addObjectsFromArray:[NSArray arrayWithObjects:@"3", @"2", @"3", @"1", nil]];
        [leftColorsState addObjectsFromArray:[NSArray arrayWithObjects:@"3", @"2", @"1", @"2", nil]];
    }
    else if (worldId == 5 && levelId == 8)
    {
        [topColorsState addObjectsFromArray:[NSArray arrayWithObjects:@"2", @"3", @"1", @"2", nil]];
        [leftColorsState addObjectsFromArray:[NSArray arrayWithObjects:@"3", @"2", @"1", @"3", nil]];
    }
    else if (worldId == 5 && levelId == 9)
    {
        [topColorsState addObjectsFromArray:[NSArray arrayWithObjects:@"1", @"3", @"2", @"1", @"2", nil]];
        [leftColorsState addObjectsFromArray:[NSArray arrayWithObjects:@"2", @"1", @"3", @"2", @"3", nil]];
    }
    else if (worldId == 5 && levelId == 10)
    {
        [topColorsState addObjectsFromArray:[NSArray arrayWithObjects:@"3", @"1", @"2", @"3", @"2", nil]];
        [leftColorsState addObjectsFromArray:[NSArray arrayWithObjects:@"1", @"2", @"3", @"1", @"2", nil]];
    }
    else if (worldId == 5 && levelId == 11)
    {
        [topColorsState addObjectsFromArray:[NSArray arrayWithObjects:@"3", @"2", @"1", @"2", @"1", nil]];
        [leftColorsState addObjectsFromArray:[NSArray arrayWithObjects:@"3", @"1", @"0", @"2", @"1", nil]];
    }
    else if (worldId == 5 && levelId == 12)
    {
        [topColorsState addObjectsFromArray:[NSArray arrayWithObjects:@"2", @"1", @"3", @"0", @"2", nil]];
        [leftColorsState addObjectsFromArray:[NSArray arrayWithObjects:@"1", @"3", @"1", @"3", @"2", nil]];
    }
    else if (worldId == 5 && levelId == 13)
    {
        [topColorsState addObjectsFromArray:[NSArray arrayWithObjects:@"2", @"3", @"1", @"2", @"3", nil]];
        [leftColorsState addObjectsFromArray:[NSArray arrayWithObjects:@"3", @"2", @"1", @"3", @"2", nil]];
    }
    else if (worldId == 5 && levelId == 14)
    {
        [topColorsState addObjectsFromArray:[NSArray arrayWithObjects:@"1", @"3", @"2", @"3", @"1", nil]];
        [leftColorsState addObjectsFromArray:[NSArray arrayWithObjects:@"1", @"3", @"2", @"3", @"2", nil]];
    }
    else if (worldId == 5 && levelId == 15)
    {
        [topColorsState addObjectsFromArray:[NSArray arrayWithObjects:@"1", @"2", @"3", @"2", @"1", nil]];
        [leftColorsState addObjectsFromArray:[NSArray arrayWithObjects:@"3", @"2", @"2", @"1", @"2", nil]];
    }
    else if (worldId == 5 && levelId == 16)
    {
        [topColorsState addObjectsFromArray:[NSArray arrayWithObjects:@"2", @"2", @"1", @"2", @"1", nil]];
        [leftColorsState addObjectsFromArray:[NSArray arrayWithObjects:@"1", @"3", @"2", @"2", @"0", nil]];
    }
    else if (worldId == 6 && levelId == 1)
    {
        [topColorsState addObjectsFromArray:[NSArray arrayWithObjects:@"2", @"3", @"3", nil]];
        [leftColorsState addObjectsFromArray:[NSArray arrayWithObjects:@"2", @"3", @"3", nil]];
    }
    else if (worldId == 6 && levelId == 2)
    {
        [topColorsState addObjectsFromArray:[NSArray arrayWithObjects:@"0", @"0", @"3", nil]];
        [leftColorsState addObjectsFromArray:[NSArray arrayWithObjects:@"0", @"0", @"3", nil]];
    }
    else if (worldId == 6 && levelId == 3)
    {
        [topColorsState addObjectsFromArray:[NSArray arrayWithObjects:@"0", @"1", @"0", nil]];
        [leftColorsState addObjectsFromArray:[NSArray arrayWithObjects:@"0", @"3", @"0", nil]];
    }
    else if (worldId == 6 && levelId == 4)
    {
        [topColorsState addObjectsFromArray:[NSArray arrayWithObjects:@"2", @"3", @"1", nil]];
        [leftColorsState addObjectsFromArray:[NSArray arrayWithObjects:@"1", @"2", @"3", nil]];
    }
    else if (worldId == 6 && levelId == 5)
    {
        [topColorsState addObjectsFromArray:[NSArray arrayWithObjects:@"0", @"2", @"1", @"0", nil]];
        [leftColorsState addObjectsFromArray:[NSArray arrayWithObjects:@"0", @"0", @"0", @"0", nil]];
    }
    else if (worldId == 6 && levelId == 6)
    {
        [topColorsState addObjectsFromArray:[NSArray arrayWithObjects:@"0", @"0", @"1", @"1", nil]];
        [leftColorsState addObjectsFromArray:[NSArray arrayWithObjects:@"0", @"0", @"0", @"0", nil]];
    }
    else if (worldId == 6 && levelId == 7)
    {
        [topColorsState addObjectsFromArray:[NSArray arrayWithObjects:@"1", @"2", @"0", @"3", nil]];
        [leftColorsState addObjectsFromArray:[NSArray arrayWithObjects:@"2", @"1", @"3", @"2", nil]];
    }
    else if (worldId == 6 && levelId == 8)
    {
        [topColorsState addObjectsFromArray:[NSArray arrayWithObjects:@"3", @"2", @"3", @"1", nil]];
        [leftColorsState addObjectsFromArray:[NSArray arrayWithObjects:@"1", @"3", @"2", @"3", nil]];
    }
    else if (worldId == 6 && levelId == 9)
    {
        [topColorsState addObjectsFromArray:[NSArray arrayWithObjects:@"2", @"3", @"1", @"2", @"3", nil]];
        [leftColorsState addObjectsFromArray:[NSArray arrayWithObjects:@"3", @"2", @"1", @"2", @"3", nil]];
    }
    else if (worldId == 6 && levelId == 10)
    {
        [topColorsState addObjectsFromArray:[NSArray arrayWithObjects:@"3", @"2", @"3", @"1", @"2", nil]];
        [leftColorsState addObjectsFromArray:[NSArray arrayWithObjects:@"1", @"2", @"3", @"1", @"3", nil]];
    }
    else if (worldId == 6 && levelId == 11)
    {
        [topColorsState addObjectsFromArray:[NSArray arrayWithObjects:@"1", @"3", @"2", @"3", @"1", nil]];
        [leftColorsState addObjectsFromArray:[NSArray arrayWithObjects:@"2", @"1", @"3", @"2", @"3", nil]];
    }
    else if (worldId == 6 && levelId == 12)
    {
        [topColorsState addObjectsFromArray:[NSArray arrayWithObjects:@"2", @"3", @"1", @"2", @"1", nil]];
        [leftColorsState addObjectsFromArray:[NSArray arrayWithObjects:@"3", @"1", @"3", @"2", @"1", nil]];
    }
    else if (worldId == 6 && levelId == 13)
    {
        [topColorsState addObjectsFromArray:[NSArray arrayWithObjects:@"1", @"3", @"2", @"3", @"2", nil]];
        [leftColorsState addObjectsFromArray:[NSArray arrayWithObjects:@"2", @"3", @"2", @"1", @"2", nil]];
    }
    else if (worldId == 6 && levelId == 14)
    {
        [topColorsState addObjectsFromArray:[NSArray arrayWithObjects:@"3", @"1", @"2", @"3", @"2", nil]];
        [leftColorsState addObjectsFromArray:[NSArray arrayWithObjects:@"1", @"0", @"1", @"3", @"0", nil]];
    }
    else if (worldId == 6 && levelId == 15)
    {
        [topColorsState addObjectsFromArray:[NSArray arrayWithObjects:@"2", @"1", @"2", @"3", @"1", nil]];
        [leftColorsState addObjectsFromArray:[NSArray arrayWithObjects:@"3", @"2", @"1", @"3", @"2", nil]];
    }
    else if (worldId == 6 && levelId == 16)
    {
        [topColorsState addObjectsFromArray:[NSArray arrayWithObjects:@"2", @"0", @"1", @"3", @"2", nil]];
        [leftColorsState addObjectsFromArray:[NSArray arrayWithObjects:@"1", @"3", @"3", @"1", @"2", nil]];
    }
    else if (worldId == 7 && levelId == 1)
    {
        [topColorsState addObjectsFromArray:[NSArray arrayWithObjects:@"0", @"1", @"0", nil]];
        [leftColorsState addObjectsFromArray:[NSArray arrayWithObjects:@"0", @"2", @"0", nil]];
    }
    else if (worldId == 7 && levelId == 2)
    {
        [topColorsState addObjectsFromArray:[NSArray arrayWithObjects:@"0", @"2", @"0", nil]];
        [leftColorsState addObjectsFromArray:[NSArray arrayWithObjects:@"0", @"3", @"0", nil]];
    }
    else if (worldId == 7 && levelId == 3)
    {
        [topColorsState addObjectsFromArray:[NSArray arrayWithObjects:@"0", @"3", @"0", nil]];
        [leftColorsState addObjectsFromArray:[NSArray arrayWithObjects:@"0", @"1", @"0", nil]];
    }
    else if (worldId == 7 && levelId == 4)
    {
        [topColorsState addObjectsFromArray:[NSArray arrayWithObjects:@"3", @"2", @"1", nil]];
        [leftColorsState addObjectsFromArray:[NSArray arrayWithObjects:@"0", @"2", @"0", nil]];
    }
    else if (worldId == 7 && levelId == 5)
    {
        [topColorsState addObjectsFromArray:[NSArray arrayWithObjects:@"0", @"3", @"1", @"2", nil]];
        [leftColorsState addObjectsFromArray:[NSArray arrayWithObjects:@"0", @"1", @"2", @"3", nil]];
    }
    else if (worldId == 7 && levelId == 6)
    {
        [topColorsState addObjectsFromArray:[NSArray arrayWithObjects:@"0", @"0", @"2", @"1", nil]];
        [leftColorsState addObjectsFromArray:[NSArray arrayWithObjects:@"0", @"1", @"3", @"2", nil]];
    }
    else if (worldId == 7 && levelId == 7)
    {
        [topColorsState addObjectsFromArray:[NSArray arrayWithObjects:@"3", @"1", @"3", @"2", nil]];
        [leftColorsState addObjectsFromArray:[NSArray arrayWithObjects:@"2", @"0", @"1", @"3", nil]];
    }
    else if (worldId == 7 && levelId == 8)
    {
        [topColorsState addObjectsFromArray:[NSArray arrayWithObjects:@"3", @"1", @"3", @"2", nil]];
        [leftColorsState addObjectsFromArray:[NSArray arrayWithObjects:@"2", @"0", @"1", @"3", nil]];
    }
    else if (worldId == 7 && levelId == 9)
    {
        [topColorsState addObjectsFromArray:[NSArray arrayWithObjects:@"1", @"2", @"3", @"2", @"1", nil]];
        [leftColorsState addObjectsFromArray:[NSArray arrayWithObjects:@"2", @"3", @"1", @"3", @"2", nil]];
    }
    else if (worldId == 7 && levelId == 10)
    {
        [topColorsState addObjectsFromArray:[NSArray arrayWithObjects:@"2", @"3", @"2", @"1", @"3", nil]];
        [leftColorsState addObjectsFromArray:[NSArray arrayWithObjects:@"1", @"2", @"3", @"1", @"2", nil]];
    }
    else if (worldId == 7 && levelId == 11)
    {
        [topColorsState addObjectsFromArray:[NSArray arrayWithObjects:@"1", @"3", @"2", @"1", @"2", nil]];
        [leftColorsState addObjectsFromArray:[NSArray arrayWithObjects:@"3", @"1", @"0", @"2", @"3", nil]];
    }
    else if (worldId == 7 && levelId == 12)
    {
        [topColorsState addObjectsFromArray:[NSArray arrayWithObjects:@"3", @"1", @"3", @"1", @"2", nil]];
        [leftColorsState addObjectsFromArray:[NSArray arrayWithObjects:@"2", @"0", @"2", @"3", @"1", nil]];
    }
    else if (worldId == 7 && levelId == 13)
    {
        [topColorsState addObjectsFromArray:[NSArray arrayWithObjects:@"2", @"1", @"2", @"3", @"1", nil]];
        [leftColorsState addObjectsFromArray:[NSArray arrayWithObjects:@"3", @"2", @"1", @"3", @"2", nil]];
    }
    else if (worldId == 7 && levelId == 14)
    {
        [topColorsState addObjectsFromArray:[NSArray arrayWithObjects:@"3", @"1", @"2", @"3", @"2", nil]];
        [leftColorsState addObjectsFromArray:[NSArray arrayWithObjects:@"1", @"3", @"2", @"3", @"2", nil]];
    }
    else if (worldId == 7 && levelId == 15)
    {
        [topColorsState addObjectsFromArray:[NSArray arrayWithObjects:@"1", @"3", @"2", @"3", @"2", nil]];
        [leftColorsState addObjectsFromArray:[NSArray arrayWithObjects:@"2", @"2", @"3", @"1", @"3", nil]];
    }
    else if (worldId == 7 && levelId == 16)
    {
        [topColorsState addObjectsFromArray:[NSArray arrayWithObjects:@"3", @"2", @"1", @"2", @"3", nil]];
        [leftColorsState addObjectsFromArray:[NSArray arrayWithObjects:@"2", @"3", @"1", @"2", @"1", nil]];
    }
    else if (worldId == 8 && levelId == 1)
    {
        [topColorsState addObjectsFromArray:[NSArray arrayWithObjects:@"0", @"0", @"0", nil]];
        [leftColorsState addObjectsFromArray:[NSArray arrayWithObjects:@"0", @"1", @"0", nil]];
    }
    else if (worldId == 8 && levelId == 2)
    {
        [topColorsState addObjectsFromArray:[NSArray arrayWithObjects:@"2", @"0", @"0", nil]];
        [leftColorsState addObjectsFromArray:[NSArray arrayWithObjects:@"0", @"0", @"3", nil]];
    }
    else if (worldId == 8 && levelId == 3)
    {
        [topColorsState addObjectsFromArray:[NSArray arrayWithObjects:@"0", @"1", @"0", nil]];
        [leftColorsState addObjectsFromArray:[NSArray arrayWithObjects:@"3", @"0", @"0", nil]];
    }
    else if (worldId == 8 && levelId == 4)
    {
        [topColorsState addObjectsFromArray:[NSArray arrayWithObjects:@"2", @"0", @"1", nil]];
        [leftColorsState addObjectsFromArray:[NSArray arrayWithObjects:@"0", @"0", @"0", nil]];
    }
    else if (worldId == 8 && levelId == 5)
    {
        [topColorsState addObjectsFromArray:[NSArray arrayWithObjects:@"0", @"0", @"0", @"1", nil]];
        [leftColorsState addObjectsFromArray:[NSArray arrayWithObjects:@"0", @"3", @"0", @"0", nil]];
    }
    else if (worldId == 8 && levelId == 6)
    {
        [topColorsState addObjectsFromArray:[NSArray arrayWithObjects:@"0", @"2", @"0", @"1", nil]];
        [leftColorsState addObjectsFromArray:[NSArray arrayWithObjects:@"0", @"0", @"0", @"3", nil]];
    }
    else if (worldId == 8 && levelId == 7)
    {
        [topColorsState addObjectsFromArray:[NSArray arrayWithObjects:@"0", @"0", @"0", @"0", nil]];
        [leftColorsState addObjectsFromArray:[NSArray arrayWithObjects:@"2", @"0", @"3", @"1", nil]];
    }
    else if (worldId == 8 && levelId == 8)
    {
        [topColorsState addObjectsFromArray:[NSArray arrayWithObjects:@"0", @"0", @"0", @"1", nil]];
        [leftColorsState addObjectsFromArray:[NSArray arrayWithObjects:@"0", @"0", @"2", @"0", nil]];
    }
    else if (worldId == 8 && levelId == 9)
    {
        [topColorsState addObjectsFromArray:[NSArray arrayWithObjects:@"2", @"3", @"1", @"0", @"1", nil]];
        [leftColorsState addObjectsFromArray:[NSArray arrayWithObjects:@"3", @"1", @"2", @"3", @"1", nil]];
    }
    else if (worldId == 8 && levelId == 10)
    {
        [topColorsState addObjectsFromArray:[NSArray arrayWithObjects:@"1", @"2", @"3", @"1", @"2", nil]];
        [leftColorsState addObjectsFromArray:[NSArray arrayWithObjects:@"2", @"1", @"3", @"2", @"3", nil]];
    }
    else if (worldId == 8 && levelId == 11)
    {
        [topColorsState addObjectsFromArray:[NSArray arrayWithObjects:@"3", @"2", @"1", @"2", @"1", nil]];
        [leftColorsState addObjectsFromArray:[NSArray arrayWithObjects:@"2", @"3", @"2", @"3", @"1", nil]];
    }
    else if (worldId == 8 && levelId == 12)
    {
        [topColorsState addObjectsFromArray:[NSArray arrayWithObjects:@"1", @"3", @"2", @"1", @"2", nil]];
        [leftColorsState addObjectsFromArray:[NSArray arrayWithObjects:@"2", @"3", @"2", @"1", @"3", nil]];
    }
    else if (worldId == 8 && levelId == 13)
    {
        [topColorsState addObjectsFromArray:[NSArray arrayWithObjects:@"3", @"2", @"1", @"2", @"1", nil]];
        [leftColorsState addObjectsFromArray:[NSArray arrayWithObjects:@"1", @"2", @"3", @"2", @"1", nil]];
    }
    else if (worldId == 8 && levelId == 14)
    {
        [topColorsState addObjectsFromArray:[NSArray arrayWithObjects:@"1", @"1", @"2", @"1", @"3", nil]];
        [leftColorsState addObjectsFromArray:[NSArray arrayWithObjects:@"2", @"1", @"2", @"3", @"1", nil]];
    }
    else if (worldId == 8 && levelId == 15)
    {
        [topColorsState addObjectsFromArray:[NSArray arrayWithObjects:@"2", @"3", @"1", @"2", @"3", nil]];
        [leftColorsState addObjectsFromArray:[NSArray arrayWithObjects:@"3", @"1", @"2", @"3", @"1", nil]];
    }
    else if (worldId == 8 && levelId == 16)
    {
        [topColorsState addObjectsFromArray:[NSArray arrayWithObjects:@"3", @"1", @"2", @"3", @"1", nil]];
        [leftColorsState addObjectsFromArray:[NSArray arrayWithObjects:@"1", @"2", @"3", @"2", @"3", nil]];
    }
}

@end
