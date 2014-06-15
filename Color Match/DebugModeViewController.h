//
//  DebugModeViewController.h
//  Color Match
//
//  Created by Linda Chen on 6/14/14.
//  Copyright (c) 2014 SunSpark Entertainment. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DebugModeViewController : UIViewController

- (IBAction)ResetProgress:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *resetProgressButton;

@end
