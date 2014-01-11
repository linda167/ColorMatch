//
//  ColorBoard.h
//  Color Match
//
//  Created by Linda Chen on 1/11/14.
//  Copyright (c) 2014 SunSpark Entertainment. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ColorBoard : NSObject

@property NSMutableArray *colorCellSections;
@property NSMutableArray *topColorsState;
@property NSMutableArray *leftColorsState;

-(void)updateColorCells;

@end
