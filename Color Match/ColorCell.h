//
//  ColorCell.h
//  Color Match
//
//  Created by Linda Chen on 1/26/14.
//  Copyright (c) 2014 SunSpark Entertainment. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ColorCell : NSObject

@property (nonatomic, strong) UIView *image;
@property (nonatomic, strong) UIImageView *specialImage;
@property NSMutableArray *colorInputs;
@property int cellType;
@property int currentColor;

+(bool)doesCellSupportCombineColor:(CellType)cellType;
-(id)init:(int)cellType;
-(void)addInputColor: (NSNumber *)color cellsAffected:(NSMutableArray*)cellsAffected;
-(void)removeInputColor: (NSNumber *)color cellsAffected:(NSMutableArray*)cellsAffected;
-(void)removeAllInputColors;
-(void)recalculateSpecialCellImage;

@end
