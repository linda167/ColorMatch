//
//  WelcomeScreenViewController.m
//  Color Match
//
//  Created by Linda Chen on 12/28/14.
//  Copyright (c) 2014 SunSpark Entertainment. All rights reserved.
//

#import "WelcomeScreenViewController.h"

@interface WelcomeScreenViewController ()

@end

@implementation WelcomeScreenViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [super viewWillDisappear:animated];
}

@end
