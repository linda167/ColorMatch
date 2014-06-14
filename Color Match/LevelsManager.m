//
//  LevelsManager.m
//  Color Match
//
//  Created by Linda Chen on 6/14/14.
//  Copyright (c) 2014 SunSpark Entertainment. All rights reserved.
//

#import "LevelsManager.h"

@implementation LevelsManager

+(int) GetGameSizeForWorld:(int)worldId levelId:(int)levelId
{
    if (worldId == 1)
    {
        if (levelId <= 2)
            return 3;
        else if (levelId <= 5)
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
@end
