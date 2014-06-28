//
//  ColorBoard.h
//  Color Match
//
//  Created by Linda Chen on 1/11/14.
//  Copyright (c) 2014 SunSpark Entertainment. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ColorCell.h"
#import "BoardCells.h"

@interface ColorBoard : NSObject

@property NSMutableArray *colorCellSections;
@property NSMutableArray *topColorsState;
@property NSMutableArray *leftColorsState;
@property BoardParameters boardParameters;
@property UIView *containerView;

-(void)updateAllColorCells;
-(void)removeColorForRow:(int)color rowIndex:(int)rowIndex cellsAffected:(NSMutableArray*)cellsAffected;
-(void)removeColorForColumn:(int)color colIndex:(int)colIndex cellsAffected:(NSMutableArray*)cellsAffected;
-(void)addColorForRow:(int)color rowIndex:(int)rowIndex cellsAffected:(NSMutableArray*)cellsAffected;
-(void)addColorForColumn:(int)color colIndex:(int)colIndex cellsAffected:(NSMutableArray*)cellsAffected;
-(ColorCell*) getColorCellForType:(int)cellType xOffset:(int)xOffset yOffset:(int)yOffset size:(int)size row:(int)row col:(int)col boardCells:(BoardCells*)boardCells;
-(UIImage*)GetImageForCellType:(int)cellType;
-(void)applySpecialCell:(ColorCell*)colorCell isAdd:(bool)isAdd cellsAffected:(NSMutableArray*)cellsAffected;
-(UIView*)getUIViewForCell:(int)cellType xOffset:(int)xOffset yOffset:(int)yOffset size:(int)size colorCell:(ColorCell*)colorCell;
- (void)removeExistingGridCells;

@end
