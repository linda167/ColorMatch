//
//  UserData.m
//  Color Match
//
//  Created by Linda Chen on 6/8/14.
//  Copyright (c) 2014 SunSpark Entertainment. All rights reserved.
//

#import "UserData.h"

@implementation UserData

- (id)init
{
    self = [super init];
    if (self)
    {
        self.userData = [NSUserDefaults standardUserDefaults];
    }
    
    return self;
}

+(id)sharedUserData
{
    static UserData *sharedUserData = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedUserData = [[self alloc] init];
    });
    return sharedUserData;
}

-(void)storeLevelComplete:(int)worldId levelId:(int)levelId
{
    NSMutableString *levelString = [UserData getLevelString:worldId levelId:levelId];
    
    [self.userData setInteger:1 forKey:levelString];
    [self.userData synchronize];
}

-(bool)getLevelCompleteState:(int)worldId levelId:(int)levelId
{
    NSMutableString *levelString = [UserData getLevelString:worldId levelId:levelId];
    NSInteger isComplete = [self.userData integerForKey:levelString];
    return (int)isComplete == 1;
}

+(NSMutableString*)getLevelString:(int)worldId levelId:(int)levelId
{
    NSMutableString *levelString = [[NSMutableString alloc] init];
    [levelString appendString:[NSString stringWithFormat: @"%d-", worldId]];
    [levelString appendString:[NSString stringWithFormat: @"%d", levelId]];
    return  levelString;
}

@end
