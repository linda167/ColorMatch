//
//  LevelId.h
//  Color Match
//
//  Created by Linda Chen on 8/19/15.
//  Copyright (c) 2015 SunSpark Entertainment. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FullLevelId : NSObject
@property int levelId;
@property int worldId;

-(id)init:(int)worldId levelId:(int)levelId;

@end
