//
//  GoalBoard.h
//  Color Match
//
//  Created by Linda Chen on 1/11/14.
//  Copyright (c) 2014 SunSpark Entertainment. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ColorBoard.h"
#import "BoardCells.h"

@interface GoalBoard : ColorBoard

-(id)initWithParameters:(BoardParameters)boardParameters containerView:(UIView*)containerView boardCells:(BoardCells*)boardCells;
-(void)generateNewGoalBoardStates:(int)worldId levelId:(int)levelId;
-(void)removeExistingGoalColorsState;
-(void)removeExistingBoard;

@end
