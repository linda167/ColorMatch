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

@property (weak, nonatomic) IBOutlet UIView *GridContainerView;
@property (weak, nonatomic) IBOutlet UIButton *blueButton;
@property (weak, nonatomic) IBOutlet UIButton *yellowButton;
@property (weak, nonatomic) IBOutlet UIButton *redButton;
@property (weak, nonatomic) IBOutlet UIButton *whiteButton;
@property (weak, nonatomic) IBOutlet UIImageView *Goal00;
@property (weak, nonatomic) IBOutlet UIImageView *Goal01;
@property (weak, nonatomic) IBOutlet UIImageView *Goal02;
@property (weak, nonatomic) IBOutlet UIImageView *Goal10;
@property (weak, nonatomic) IBOutlet UIImageView *Goal11;
@property (weak, nonatomic) IBOutlet UIImageView *Goal12;
@property (weak, nonatomic) IBOutlet UIImageView *Goal20;
@property (weak, nonatomic) IBOutlet UIImageView *Goal21;
@property (weak, nonatomic) IBOutlet UIImageView *Goal22;
@property (weak, nonatomic) IBOutlet UILabel *TimerLabel;
@property (weak, nonatomic) IBOutlet UILabel *MovesLabel;

@end
