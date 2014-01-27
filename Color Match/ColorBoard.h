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
@property BoardParameters boardParameters;
@property UIView *containerView;

-(void)updateAllColorCells;
-(void)removeColorForRow:(int)color rowIndex:(int)rowIndex;
-(void)removeColorForColumn:(int)color colIndex:(int)colIndex;
-(void)addColorForRow:(int)color rowIndex:(int)rowIndex;
-(void)addColorForColumn:(int)color colIndex:(int)colIndex;

@end
