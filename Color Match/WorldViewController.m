//
//  WorldViewController.m
//  Color Match
//
//  Created by Linda Chen on 5/31/14.
//  Copyright (c) 2014 SunSpark Entertainment. All rights reserved.
//

#import "WorldViewController.h"
#import "MainGameViewController.h"
#import "LevelSelectButton.h"
#import "UserData.h"

@interface WorldViewController ()
@property bool isFirstTimeViewCreation;
@property NSMutableArray *levelButtons;
@property int worldId;
@end

@implementation WorldViewController

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
    
    self.levelButtons = [[NSMutableArray alloc] init];
    self.isFirstTimeViewCreation = true;
    
    // Do any additional setup after loading the view.
    self.worldId = 1;
    [self renderLevelsDisplay];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (!self.isFirstTimeViewCreation)
    {
        [self updateProgression];
    }
    
    self.isFirstTimeViewCreation = false;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)renderLevelsDisplay
{
    int rowsToRender = 5;
    int colsToRender = 4;
    
    int totalLevelsToRender = rowsToRender * colsToRender;
    int xOffsetInitial = 0;
    int yOffsetInitial = 0;
    int xOffset = xOffsetInitial;
    int yOffset = yOffsetInitial;
    int size = 60;
    int heightBetweenRows = 80;
    int widthBetweenCols = 60;
    for (int i=0; i<totalLevelsToRender; i++)
    {
        // Figure out if level is complete
        int levelId = i+1;
        bool isLevelComplete = [[UserData sharedUserData] getLevelCompleteState:self.worldId levelId:levelId];
        UIImage *buttonImage = [self getImageForLevel:isLevelComplete];
        
        // Add level button
        LevelSelectButton *levelButton = [[LevelSelectButton alloc] initWithFrame:CGRectMake(xOffset, yOffset, size, size)];
        [levelButton setImage:buttonImage forState:UIControlStateNormal];
        [levelButton addTarget:self action:@selector(levelButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        levelButton.worldId = self.worldId;
        levelButton.levelId = levelId;
        levelButton.isComplete = isLevelComplete;
        [self.levelButtons addObject:levelButton];
        [self.containerView addSubview:levelButton];
        
        // Add level text
        UILabel *levelName = [[UILabel alloc] initWithFrame:CGRectMake(xOffset+20, yOffset+52, size, 25)];
        levelName.font = [UIFont fontWithName:@"Futura-Medium" size:12.0];
        NSMutableString *levelString = [UserData getLevelString:self.worldId levelId:levelId];
        levelName.text = levelString;
        [self.containerView addSubview:levelName];
        
        if ((i+1)%rowsToRender == 0)
        {
            // Time to render new line of buttons
            xOffset = xOffsetInitial;
            yOffset += heightBetweenRows;
        }
        else
        {
            xOffset += widthBetweenCols;
        }
    }
}

- (UIImage*)getImageForLevel:(bool)isComplete
{
    return isComplete ?
        [UIImage imageNamed:@"completeLevel@2x.png"] :
        [UIImage imageNamed:@"incompleteLevel@2x.png"];
}

- (void)updateProgression
{
    // TODO: lindach
    for (int i = 0; i < self.levelButtons.count; i++)
    {
        LevelSelectButton *levelButton = [self.levelButtons objectAtIndex:i];
        int levelId = i+1;
        
        bool isLevelComplete = [[UserData sharedUserData] getLevelCompleteState:self.worldId levelId:levelId];
        if (isLevelComplete != levelButton.isComplete)
        {
            UIImage *buttonImage = [self getImageForLevel:isLevelComplete];
            levelButton.imageView.image = buttonImage;
            levelButton.isComplete = isLevelComplete;
        }
    }
}

- (IBAction)levelButtonPressed:(id)sender
{
    [self performSegueWithIdentifier:@"LoadLevel" sender:sender];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    MainGameViewController *destinationController = segue.destinationViewController;
    LevelSelectButton *levelSelectButton = (LevelSelectButton*)sender;
    
    if ([[segue identifier] isEqualToString:@"LoadLevel"])
    {
        int worldId = levelSelectButton.worldId;
        int levelId = levelSelectButton.levelId;
        int gameSize = [self getGameSizeForWorld:worldId levelId:levelId];
        [destinationController SetParametersForNewGame:gameSize worldId:levelSelectButton.worldId levelId:levelSelectButton.levelId];
    }
}

- (int)getGameSizeForWorld:(int)worldId levelId:(int)levelId
{
    if (levelId <= 5)
        return 3;
    else if (levelId <= 10)
        return 4;
    else
        return 5;
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
