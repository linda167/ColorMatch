//
//  ChooseGameSizeViewController.m
//  Color Match
//
//  Created by Linda Chen on 1/11/14.
//  Copyright (c) 2014 SunSpark Entertainment. All rights reserved.
//

#import "ChooseGameSizeViewController.h"
#import "MainGameViewController.h"

@interface ChooseGameSizeViewController ()

@end

@implementation ChooseGameSizeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    MainGameViewController *destinationController = segue.destinationViewController;
    
    if ([[segue identifier] isEqualToString:@"SizeThreeSegue"])
    {
        // Same game size to 3x3
        [destinationController SetGameSize:3];
    }
    else if ([[segue identifier] isEqualToString:@"SizeFourSegue"])
    {
        // Same game size to 4x4
        [destinationController SetGameSize:4];
    }
    else if ([[segue identifier] isEqualToString:@"SizeFiveSegue"])
    {
        // Same game size to 5x5
        [destinationController SetGameSize:5];
    }
}

@end
