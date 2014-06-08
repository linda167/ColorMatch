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

-(id)initWithParameters: (BoardParameters)boardParameters;
-(void)logBoardCellState;
-(void)generateRandomCellTypes;

@end
