//
//  DebugModeViewController.h
//  Color Match
//
//  Created by Linda Chen on 6/14/14.
//  Copyright (c) 2014 SunSpark Entertainment. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DebugModeViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIButton *resetProgressButton;
@property (weak, nonatomic) IBOutlet UITextField *completeLevelInWorldInput;
@property (weak, nonatomic) IBOutlet UIButton *completeLevelsButton;

- (IBAction)ResetProgress:(id)sender;

@end
