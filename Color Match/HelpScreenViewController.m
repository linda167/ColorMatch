//
//  HelpScreenViewController.m
//  Color Match
//
//  Created by Linda Chen on 6/27/15.
//  Copyright (c) 2015 SunSpark Entertainment. All rights reserved.
//

#import "HelpScreenViewController.h"
#import "MainGameViewController.h"

@interface HelpScreenViewController ()

@end

@implementation HelpScreenViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Show the help image
    int viewportWidth = self.view.frame.size.width;
    int viewportHeight = self.view.frame.size.height;
    
    // Create logo image and scale it down to fit screen
    UIImage* image = [UIImage imageNamed:@"00pauseColorMix@2x.png"];
    int imageHeight = image.size.height;
    double proportion = image.size.width / viewportWidth;
    imageHeight = image.size.height / proportion;
    UIImageView *logoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 80, viewportWidth, imageHeight)];
    logoImageView.image = image;
    
    // Add white background to host the image
    UIView* helpScreen = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, viewportWidth, viewportHeight)];
    helpScreen.backgroundColor = [UIColor colorWithRed:(255/255.0) green:(255/255.0) blue:(255/255.0) alpha:1];
    
    [helpScreen addSubview:logoImageView];
    
    // Center the logo
    helpScreen.center = self.view.center;
    [self.view addSubview:helpScreen];
    
    // Create top bar
    UIView* topBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, viewportWidth, 80)];
    topBar.backgroundColor = [UIColor colorWithRed:(243/255.0) green:(243/255.0) blue:(242/255.0) alpha:1];
    [self.view addSubview:topBar];
    [self.view bringSubviewToFront:topBar];
    
    // Create the close button
    UIImage *closeImage = [UIImage imageNamed:@"closeButton@2x.png"];
    UIButton *closeButton = [[UIButton alloc] initWithFrame:CGRectMake(viewportWidth - closeImage.size.width - 5,33,closeImage.size.width,closeImage.size.height)];
    [closeButton setImage:closeImage forState:UIControlStateNormal];
    [closeButton addTarget:self action:@selector(closeButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:closeButton];
    [self.view bringSubviewToFront:closeButton];
    
    // Create game paused label
    UILabel *gamePausedTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 50)];
    gamePausedTitle.font = [UIFont fontWithName:@"Futura-Medium" size:20.0];
    gamePausedTitle.textColor = [UIColor blackColor];
    gamePausedTitle.text = [NSString stringWithFormat: @"Paused"];
    [gamePausedTitle sizeToFit];
    [gamePausedTitle setCenter:CGPointMake(self.view.frame.size.width / 2, 50)];
    [topBar addSubview:gamePausedTitle];
}

- (IBAction)closeButtonPressed:(id)sender
{
    MainGameViewController* parentViewController = (MainGameViewController*)self.parentViewController;
    [parentViewController CloseHelpMenu];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
