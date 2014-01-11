//
//  CommonUtils.h
//  Color Match
//
//  Created by Linda Chen on 1/11/14.
//  Copyright (c) 2014 SunSpark Entertainment. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommonUtils : NSObject

+(int)CombineColors:(int)color1 color2:(int)color2;
+(UIImage *) GetCellImageForColor:(int)color;

@end
