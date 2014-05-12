//
//  UserColorBoard.h
//  Color Match
//
//  Created by Linda Chen on 1/11/14.
//  Copyright (c) 2014 SunSpark Entertainment. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ColorBoard.h"
#import "MainGameViewController.h"
#import "BoardCells.h"

@interface UserColorBoard : ColorBoard

@property NSMutableArray *topGridColorButtons;
@property NSMutableArray *leftGridColorButtons;
@property BoardCells *boardCells;

-(id)initWithParameters:
    (BoardParameters)boardParameters
    containerView:(UIView*)userBoardContainerView
    viewController:(MainGameViewController*)viewController
    boardCells:(BoardCells*) boardCells;
-(void)removeExistingBoard;
-(void)resetCells;
-(void)pressGridButtonWithColor:(UIButton *)button :(int)selectedColor;
-(NSNumber*)getCurrentColorForButton:(UIButton *)button;

@end
