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

@end
