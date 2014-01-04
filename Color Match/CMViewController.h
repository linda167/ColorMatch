//
//  CMViewController.h
//  Color Match
//
//  Created by Linda Chen on 1/1/14.
//  Copyright (c) 2014 SunSpark Entertainment. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CMViewController : UIViewController
- (IBAction)ColorButtonPressed:(id)sender;
- (IBAction)GridButtonPressed:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *blueButton;
@property (weak, nonatomic) IBOutlet UIButton *yellowButton;
@property (weak, nonatomic) IBOutlet UIButton *redButton;
@property (weak, nonatomic) IBOutlet UIButton *whiteButton;
@property (weak, nonatomic) IBOutlet UIButton *Top1Button;
@property (weak, nonatomic) IBOutlet UIButton *Top2Button;
@property (weak, nonatomic) IBOutlet UIButton *Top3Button;
@property (weak, nonatomic) IBOutlet UIButton *Left1Button;
@property (weak, nonatomic) IBOutlet UIButton *Left2Button;
@property (weak, nonatomic) IBOutlet UIButton *Left3Button;
@property (weak, nonatomic) IBOutlet UIImageView *Cell00;
@property (weak, nonatomic) IBOutlet UIImageView *Cell01;
@property (weak, nonatomic) IBOutlet UIImageView *Cell02;
@property (weak, nonatomic) IBOutlet UIImageView *Cell10;
@property (weak, nonatomic) IBOutlet UIImageView *Cell11;
@property (weak, nonatomic) IBOutlet UIImageView *Cell12;
@property (weak, nonatomic) IBOutlet UIImageView *Cell20;
@property (weak, nonatomic) IBOutlet UIImageView *Cell21;
@property (weak, nonatomic) IBOutlet UIImageView *Cell22;
@property (weak, nonatomic) IBOutlet UIImageView *Goal00;
@property (weak, nonatomic) IBOutlet UIImageView *Goal01;
@property (weak, nonatomic) IBOutlet UIImageView *Goal02;
@property (weak, nonatomic) IBOutlet UIImageView *Goal10;
@property (weak, nonatomic) IBOutlet UIImageView *Goal11;
@property (weak, nonatomic) IBOutlet UIImageView *Goal12;
@property (weak, nonatomic) IBOutlet UIImageView *Goal20;
@property (weak, nonatomic) IBOutlet UIImageView *Goal21;
@property (weak, nonatomic) IBOutlet UIImageView *Goal22;
- (IBAction)NewBoard:(id)sender;

@end
