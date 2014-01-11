//
//  GoalBoard.h
//  Color Match
//
//  Created by Linda Chen on 1/11/14.
//  Copyright (c) 2014 SunSpark Entertainment. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ColorBoard.h"

@interface GoalBoard : ColorBoard

-(id)initWithParameters: (BoardParameters)boardParameters goalContainerView:(UIView*)goalContainerView;
-(void)removeExistingGoalColorCells;
-(void)generateNewGoalBoardStates;
-(void)removeExistingGoalColorsState;

@end
