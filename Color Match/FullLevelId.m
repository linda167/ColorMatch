//
//  LevelId.m
//  Color Match
//
//  Created by Linda Chen on 8/19/15.
//  Copyright (c) 2015 SunSpark Entertainment. All rights reserved.
//

#import "FullLevelId.h"

@implementation FullLevelId

-(id)init:(int)worldId levelId:(int)levelId
{
    self = [super init];
    if (self)
    {
        self.worldId = worldId;
        self.levelId = levelId;
    }
    
    return self;
}

@end
