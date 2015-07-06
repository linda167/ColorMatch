//
//  MainGameManager.h
//  Color Match
//
//  Created by Linda Chen on 7/3/15.
//  Copyright (c) 2015 SunSpark Entertainment. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserColorBoard.h"
#import "BoardCells.h"

@class MainGameViewController;

@interface MainGameManager : NSObject

@property NSInteger selectedColor;
@property UserColorBoard *userColorBoard;
@property BoardParameters boardParameters;
@property BoardCells *boardCells;
@property MainGameViewController *viewController;
@property int worldId;

- (id)initWithParameters:(MainGameViewController*)viewController size:(int)size worldId:(int)worldId levelId:(int)levelId;
- (void)StartNewGame;
- (void)OnColorButtonPressed:(id)sender;
- (void)OnGridButtonPressed:(id)sender;
- (void)OnShowHelpMenu:(id)sender;
- (void)CloseHelpMenu;
-(void)OnUserActionTaken;
- (void)renderNewBoard;
- (NSArray*)getColorButtons;
- (void)removeExistingBoard;
-(void)resetActionBar;

@end