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
@property NSMutableDictionary *transporterGroups;
@property BoardCells *boardCells;

-(id)initWithParameters:(BoardCells*) boardCells;
-(void)updateAllColorCells;
-(void)removeColorForRow:(int)color rowIndex:(int)rowIndex cellsAffected:(NSMutableArray*)cellsAffected;
-(void)removeColorForColumn:(int)color colIndex:(int)colIndex cellsAffected:(NSMutableArray*)cellsAffected;
-(void)addColorForRow:(int)color rowIndex:(int)rowIndex cellsAffected:(NSMutableArray*)cellsAffected;
-(void)addColorForColumn:(int)color colIndex:(int)colIndex cellsAffected:(NSMutableArray*)cellsAffected;
-(ColorCell*) getColorCellForType:(int)cellType xOffset:(int)xOffset yOffset:(int)yOffset size:(int)size row:(int)row col:(int)col boardCells:(BoardCells*)boardCells;
-(UIImage*)GetImageForCellType:(ColorCell*)colorCell;
-(void)applySpecialCell:(ColorCell*)colorCell isAdd:(bool)isAdd cellsAffected:(NSMutableArray*)cellsAffected;
-(UIView*)getUIViewForCell:(int)cellType xOffset:(int)xOffset yOffset:(int)yOffset size:(int)size colorCell:(ColorCell*)colorCell;
-(void)removeExistingGridCells;
-(void)resetBoardState;
-(UIImage*)getTransporterImageWithColor:(ColorCell*)colorCell color:(int)color;
-(void)updateSpecialCellImagesOnApplyColor:(ColorCell*)colorCell color:(int)color isHorizontal:(BOOL)isHorizontal cellsAffected:(NSMutableArray*)cellsAffected;
-(void)applyColor:(int)currentRow currentCol:(int)currentCol isHorizontal:(BOOL)isHorizontal color:(int)color isAdd:(BOOL)isAdd cellsAffected:(NSMutableArray*)cellsAffected;
-(int)shiftColor:(int)color backwards:(bool)backwards shiftCount:(int)shiftCount;
-(void)updateSpecialImageVisibility:(ColorCell*)colorCell shouldHide:(bool)shouldHide;

@end
