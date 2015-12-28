//
//  CMViewController.h
//  Color Match
//
//  Created by Linda Chen on 1/1/14.
//  Copyright (c) 2014 SunSpark Entertainment. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MainGameManager;

@interface MainGameViewController : UIViewController <UIAlertViewDelegate>
- (IBAction)ColorButtonPressed:(id)sender;
- (IBAction)GridButtonPressed:(id)sender;
- (void)SetParametersForNewGame:(int)size worldId:(int)worldId levelId:(int)levelId;
- (void)OnUserActionTaken;
- (void)CloseHelpMenu;
- (void)createGameManagerAndStartNewGame;
- (void)PresentAd;

@property (weak, nonatomic) IBOutlet UIView *GridContainerView;
@property (weak, nonatomic) IBOutlet UIView *GoalContainerView;
@property (weak, nonatomic) IBOutlet UIButton *blueButton;
@property (weak, nonatomic) IBOutlet UIButton *yellowButton;
@property (weak, nonatomic) IBOutlet UIButton *redButton;
@property (weak, nonatomic) IBOutlet UIButton *whiteButton;
@property (weak, nonatomic) IBOutlet UILabel *TimerLabel;
@property (weak, nonatomic) IBOutlet UILabel *MovesLabel;
@property (weak, nonatomic) IBOutlet UILabel *LevelNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *LevelLabel;
@property MainGameManager *mainGameManager;
@property (weak, nonatomic) IBOutlet UILabel *MovesPrefixLabel;
@property (weak, nonatomic) IBOutlet UILabel *TimePrefixLabel;
@property (weak, nonatomic) IBOutlet UIButton *HelpButton;
@property (weak, nonatomic) IBOutlet UIView *topSectionContainer;
@property (weak, nonatomic) IBOutlet UIImageView *ColorButtonBarContainer;
@property int worldId;
@property int levelId;

@end
