//
//  CMViewController.h
//  Color Match
//
//  Created by Linda Chen on 1/1/14.
//  Copyright (c) 2014 SunSpark Entertainment. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CMViewController : UIViewController <UIAlertViewDelegate>
- (IBAction)ColorButtonPressed:(id)sender;
- (IBAction)ThreePressed:(id)sender;
- (IBAction)FourPressed:(id)sender;
- (IBAction)FivePressed:(id)sender;
- (IBAction)GridButtonPressed:(id)sender;

@property (weak, nonatomic) IBOutlet UIView *GridContainerView;
@property (weak, nonatomic) IBOutlet UIView *GoalContainerView;
@property (weak, nonatomic) IBOutlet UIButton *blueButton;
@property (weak, nonatomic) IBOutlet UIButton *yellowButton;
@property (weak, nonatomic) IBOutlet UIButton *redButton;
@property (weak, nonatomic) IBOutlet UIButton *whiteButton;
@property (weak, nonatomic) IBOutlet UILabel *TimerLabel;
@property (weak, nonatomic) IBOutlet UILabel *MovesLabel;

@end
