//
//  MainUINavigationController.m
//  Color Match
//
//  Created by Linda Chen on 1/11/14.
//  Copyright (c) 2014 SunSpark Entertainment. All rights reserved.
//

#import "MainUINavigationController.h"

@interface MainUINavigationController ()
@property UIView *logoView;
@end

@implementation MainUINavigationController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (NSUInteger)supportedInterfaceOrientations
{
    // Lock orientation to portrait
    return UIInterfaceOrientationPortrait + UIInterfaceOrientationPortraitUpsideDown;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    // Do any additional setup after loading the view.
    [self showLogo];
}

- (void)showLogo
{
    int viewportWidth = self.view.frame.size.width;
    int viewportHeight = self.view.frame.size.height;
    
    // Create logo image and scale it down to fit screen
    UIImage* image = [UIImage imageNamed:@"logo@2x.png"];
    int imageHeight = image.size.height;
    double proportion = image.size.width / viewportWidth;
    imageHeight = image.size.height / proportion;
    UIImageView *logoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, viewportWidth, imageHeight)];
    logoImageView.image = image;
    
    // Add white background to host the image
    UIView* logoView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, viewportWidth, viewportHeight)];
    logoView.backgroundColor = [UIColor colorWithRed:(235/255.0) green:(235/255.0) blue:(235/255.0) alpha:1];
    
    logoImageView.center = self.view.center;
    [logoView addSubview:logoImageView];
    self.logoView = logoView;
    
    // Center the logo
    logoView.center = self.view.center;
    [self.view addSubview:logoView];
    
    // Set timeout to dismiss the logo
    [NSTimer scheduledTimerWithTimeInterval:2.25
        target:self
        selector:@selector(dismissLogo)
        userInfo:nil
        repeats:NO];
}

- (void)dismissLogo
{
    [self.logoView removeFromSuperview];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
