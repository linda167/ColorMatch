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

-(id)initWithParameters: (BoardParameters)boardParameters;
-(void)logBoardCellState;
-(void)generateRandomCellTypes;
-(void)addZonerValueAt:(int)row col:(int)col value:(int)value;
-(int)getZonerValueAt:(int)row col:(int)col;

@end
