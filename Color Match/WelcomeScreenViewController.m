//
//  WelcomeScreenViewController.m
//  Color Match
//
//  Created by Linda Chen on 12/28/14.
//  Copyright (c) 2014 SunSpark Entertainment. All rights reserved.
//

#import "WelcomeScreenViewController.h"

@interface WelcomeScreenViewController ()
@property UIView *logoView;
@end

@implementation WelcomeScreenViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
    
    _divider.alpha = 0;
    _button1.alpha = 0;
    _button2.alpha = 0;
    _button3.alpha = 0;
    
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
    logoView.backgroundColor = [UIColor colorWithRed:(255/255.0) green:(255/255.0) blue:(255/255.0) alpha:1];
    
    logoImageView.center = self.view.center;
    [logoView addSubview:logoImageView];
    self.logoView = logoView;
    
    // Center the logo
    logoView.center = self.view.center;
    [self.view addSubview:logoView];
    
    // Fade out image
    [UIView
     animateWithDuration:.5
     delay:1.5
     options:UIViewAnimationOptionCurveEaseOut
     animations:^
     {
         logoView.alpha = 0.0;
     }
     completion:^(BOOL finished)
     {
         [self.logoView removeFromSuperview];
         [self dropDownLogo];
     }];
}

- (void)dropDownLogo {
    
    // Drop down logo
    [UIView
     animateWithDuration:.80
     delay:0
     usingSpringWithDamping: .4
     initialSpringVelocity: .4
     options:UIViewAnimationOptionCurveLinear
     animations:^
     {
         _logo.center = CGPointMake(_logo.center.x, 182);
     }
     completion:^(BOOL finished)
     {
         [self fadeInDivider];
     }];
}

- (void)fadeInDivider {
    
    // Fade in divider
    [UIView
     animateWithDuration:.5
     delay:0
     options:UIViewAnimationOptionCurveEaseOut
     animations:^
     {
         _divider.alpha = 1.0;
     }
     completion:^(BOOL finished)
     {
         [self fadeInButtons];
     }];
}

- (void)fadeInButtons {
    
    // Fade in divider
    [UIView
     animateWithDuration:.5
     delay:0
     options:UIViewAnimationOptionCurveEaseOut
     animations:^
     {
         _button1.alpha = 1.0;
         _button2.alpha = 1.0;
         _button3.alpha = 1.0;
     }
     completion:^(BOOL finished)
     {
     }];
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
