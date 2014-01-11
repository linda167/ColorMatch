//
//  UserColorBoard.h
//  Color Match
//
//  Created by Linda Chen on 1/11/14.
//  Copyright (c) 2014 SunSpark Entertainment. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ColorBoard.h"
#import "CMViewController.h"

@interface UserColorBoard : ColorBoard

@property NSMutableArray *topGridColorButtons;
@property NSMutableArray *leftGridColorButtons;

-(id)initWithParameters: (BoardParameters)boardParameters containerView:(UIView*)userBoardContainerView viewController:(CMViewController*)viewController;
-(void)removeExistingBoard;
-(void)resetCells;
-(void)pressGridButtonWithColor:(UIButton *)button :(int)selectedColor;
-(NSNumber*)getCurrentColorForButton:(UIButton *)button;

@end
