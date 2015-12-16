//
//  DebugModeViewController.m
//  Color Match
//
//  Created by Linda Chen on 6/14/14.
//  Copyright (c) 2014 SunSpark Entertainment. All rights reserved.
//

#import "DebugModeViewController.h"
#import "UserData.h"
#import "LevelsManager.h"

@interface DebugModeViewController ()

@end

@implementation DebugModeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        // Custom initialization
    }
    return self;
}

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

- (IBAction)ResetProgress:(id)sender
{
    [[UserData sharedUserData] wipeData];
}

- (IBAction)CompleteLevelsInWorld:(id)sender
{
    int worldId = [self.completeLevelInWorldInput.text intValue];
    int levelsAbleToBeCompleted = [LevelsManager GetLevelsAbleToBeCompleted:worldId];
    
    for (int i=0; i<levelsAbleToBeCompleted; i++)
    {
        int levelId = i+1;
        [[UserData sharedUserData] storeLevelComplete:worldId levelId:levelId stars:2];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
