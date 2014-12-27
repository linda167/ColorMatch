//
//  BoardCells.h
//  Color Match
//
//  Created by Linda Chen on 5/11/14.
//  Copyright (c) 2014 SunSpark Entertainment. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BoardCells : NSObject

@property NSMutableArray *colorCellSections;
@property int connectorCellInput;
@property int shiftCount;

-(id)initWithParameters: (BoardParameters)boardParameters;
-(void)logBoardCellState;
-(void)generateRandomCellTypes;
-(void)addZonerValueAt:(int)row col:(int)col value:(int)value;
-(int)getZonerValueAt:(int)row col:(int)col;
-(void)addSplitterValueAt:(int)row col:(int)col value:(int)value;
-(int)getSplitterValueAt:(int)row col:(int)col;
-(void)addTransporterGroupMapping:(int)row col:(int)col group:(int)group;
-(int)getTransporterGroupMapping:(int)row col:(int)col;
-(void)setConverterDirectionAt:(int)row col:(int)col isDirectionRight:(int)isDirectionRight;
-(int)getConverterDirectionAt:(int)row col:(int)col;
-(void)setConverterInitialDirectionAt:(int)row col:(int)col isDirectionRight:(int)isDirectionRight;
-(int)getConverterInitialDirectionAt:(int)row col:(int)col;
-(void)addShifterValueAt:(int)row col:(int)col value:(int)value;
-(int)getShifterValueAt:(int)row col:(int)col;

@end
