//
//  CommonUtils.h
//  Color Match
//
//  Created by Linda Chen on 1/11/14.
//  Copyright (c) 2014 SunSpark Entertainment. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommonUtils : NSObject

+(int)CombineColorsList:(NSMutableArray*)colorList;
+(int)CombineTwoColors:(int)color1 color2:(int)color2;
+(UIImage *) GetCellImageForColor:(int)color;
+(UIColor *) GetGrayColor;
+(UIColor *) GetBlueColor;
+(UIColor *) GetYellowColor;
+(UIColor *) GetRedColor;
+(void) Log:(NSMutableString*)string;
+(UIImage *) GetConnectorInnerImageForColor:(int)color;
+(UIImage *) GetConnectorOuterImageForColor:(int)color;
+(void)AnimateViewsAffected:(NSMutableArray*)viewsToAnimate;
+(UIColor *) GetUIColorForColor:(int)colorValue;
+(bool) IsTransporterOutput:(CellType)cellType;
+(bool) IsTransporterInput:(CellType)cellType;
+(bool) IsTransporterCell:(CellType)cellType;
+(UIImage *) GetShifterInnerImageForColor:(int)color;
+(void) ShowLockedLevelMessage:(int)worldId levelId:(int)levelId isFromPreviousLevel:(bool)isFromPreviousLevel viewController:(UIViewController*)viewController triggerBackOnDismiss:(bool)triggerBackOnDismiss;
+(void)runBlockAfterDelay:(NSTimeInterval)delay block:(void (^)(void))block;
+(NSString*)GetRandomTip;
+(NSString*)GetRandomWinMessage:(int)stars;
+(void)determineIphone4S:(UIView*)view;
+(bool)IsIphone4S;
+(void)determineIphone6Plus:(UIView*)view;
+(bool)IsIphone6Plus;
+(bool)shouldShowAd;

@end
