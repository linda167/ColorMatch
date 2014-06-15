//
//  LevelsManager.h
//  Color Match
//
//  Created by Linda Chen on 6/14/14.
//  Copyright (c) 2014 SunSpark Entertainment. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BoardCells.h"

@interface LevelsManager : NSObject

+(int) GetGameSizeForWorld:(int)worldId levelId:(int)levelId;
+(int) GetLevelCountForWorld:(int)worldId;
+(int) IsRandomLevel:(int)worldId levelId:(int)levelId;
+(void)GetBoardStatesForLevel:(int)worldId levelId:(int)levelId topColorsState:(NSMutableArray*)topColorsState leftColorsState:(NSMutableArray*)leftColorsState;
+(BoardCells*)LoadBoardCellTypes:(int)worldId levelId:(int)levelId boardParameters:(BoardParameters)boardParameters;
+(int)CalculateStarsEarned:(int)boardSize time:(int)time;

@end
