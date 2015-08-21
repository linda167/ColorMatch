//
//  UserData.h
//  Color Match
//
//  Created by Linda Chen on 6/8/14.
//  Copyright (c) 2014 SunSpark Entertainment. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserData : NSObject

@property (nonatomic, retain) NSUserDefaults *userData;

+(id)sharedUserData;
+(NSMutableString*)getLevelString:(int)worldId levelId:(int)levelId;
-(void)storeLevelComplete:(int)worldId levelId:(int)levelId stars:(int)stars;
-(bool)getLevelCompleteState:(int)worldId levelId:(int)levelId;
-(int)getStarCount:(int)worldId levelId:(int)levelId;
-(void)wipeData;
-(int)getLastLevelCompletedInWorld;
-(void)storeTutorialComplete:(int)worldId;
-(bool)getTutorialComplete:(int)worldId;
-(void)storeGamePurchased:(bool)purchased;
-(bool)getGamePurchased;
-(bool)getIsLevelLocked:(int)worldId levelId:(int)levelId;
-(NSString*)getLevelLockedMessage:(int)worldId levelId:(int)levelId isFromPreviousLevel:(bool)isFromPreviousLevel;

@end
