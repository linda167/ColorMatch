//
//  SingleWorldViewController.m
//  Color Match
//
//  Created by Linda Chen on 6/15/14.
//  Copyright (c) 2014 SunSpark Entertainment. All rights reserved.
//

#import "SingleWorldViewController.h"
#import "LevelSelectButton.h"
#import "UserData.h"
#import "LevelsManager.h"
#import "MainGameViewController.h"
#import "WorldViewController.h"

@interface SingleWorldViewController ()
@property int worldId;
@property bool isFirstTimeViewCreation;
@property NSMutableArray *levelButtons;
@property WorldViewController* parentWorldController;
@end

@implementation SingleWorldViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithWorldId:(int)worldId parentWorldController:(WorldViewController*)parentWorldController
{
    self = [super init];
    if (self)
    {
        // Custom initialization
        self.worldId = worldId;
        self.parentWorldController = parentWorldController;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.levelButtons = [[NSMutableArray alloc] init];
    self.isFirstTimeViewCreation = true;
    
    // Do any additional setup after loading the view.
    [self renderWorldTitleDisplay];
    if (self.worldId < 7)
    {
        // TODO: add support for other worlds
        [self renderLevelsDisplay];
    }
}

-(void)onViewShown
{
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

- (void)renderWorldTitleDisplay
{
    UILabel *worldTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 20)];
    worldTitle.font = [UIFont fontWithName:@"Futura-Medium" size:16.0];
    worldTitle.text = [NSString stringWithFormat: @"World %d", self.worldId];
    [worldTitle sizeToFit];
    [worldTitle setCenter:CGPointMake(self.view.frame.size.width / 2, 23)];
    [self.view addSubview:worldTitle];
}

- (void)renderLevelsDisplay
{
    int rowsToRender = 0;
    int colsToRender = 0;
        
    int levelCount = [LevelsManager GetLevelCountForWorld:self.worldId];
    colsToRender = 4;
    rowsToRender = levelCount % colsToRender;
    
    int totalLevelsToRender = [LevelsManager GetLevelCountForWorld:self.worldId];
    int xOffsetInitial = 15;
    int yOffsetInitial = 48;
    int xOffset = xOffsetInitial;
    int yOffset = yOffsetInitial;
    int size = 60;
    int heightBetweenRows = 95;
    int widthBetweenCols = 75;
    int starYOffset = 57;
    int starXOffset = 8;
    int starWidth=44;
    int starHeight=16;
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
        [self.view addSubview:levelButton];
        
        // Add stars
        int starCount = [[UserData sharedUserData] getStarCount:self.worldId levelId:levelId];
        int starYPosition = yOffset+starYOffset;
        UIImageView *starsImage = [[UIImageView alloc] initWithFrame:CGRectMake(xOffset+starXOffset, starYPosition, starWidth, starHeight)];
        starsImage.image = [self getImageForStars:starCount];
        levelButton.starsImage = starsImage;
        levelButton.starCount = starCount;
        [self.view addSubview:starsImage];
        
        // Add level text
        UILabel *levelName = [[UILabel alloc] initWithFrame:CGRectMake(xOffset+20, starYPosition+15, size, 25)];
        levelName.font = [UIFont fontWithName:@"Futura-Medium" size:12.0];
        NSMutableString *levelString = [UserData getLevelString:self.worldId levelId:levelId];
        levelName.text = levelString;
        [self.view addSubview:levelName];
        
        if ((i+1)%colsToRender == 0)
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

- (UIImage*)getImageForStars:(int)starCount
{
    if (starCount == 1)
        return [UIImage imageNamed:@"1stars@2x.png"];
    else if (starCount == 2)
        return [UIImage imageNamed:@"2stars@2x.png"];
    else if (starCount == 3)
        return [UIImage imageNamed:@"3stars@2x.png"];
    else if (starCount == 4)
        return [UIImage imageNamed:@"rainbow@2x.png"];
    else
        return [UIImage imageNamed:@"0stars@2x.png"];
    
}

- (void)updateProgression
{
    for (int i = 0; i < self.levelButtons.count; i++)
    {
        LevelSelectButton *levelButton = [self.levelButtons objectAtIndex:i];
        int levelId = i+1;
        
        // Update checkmark
        bool isLevelComplete = [[UserData sharedUserData] getLevelCompleteState:self.worldId levelId:levelId];
        if (isLevelComplete != levelButton.isComplete)
        {
            UIImage *buttonImage = [self getImageForLevel:isLevelComplete];
            [levelButton setImage:buttonImage forState:UIControlStateNormal];
            levelButton.isComplete = isLevelComplete;
        }
        
        // Update stars
        int starCount = [[UserData sharedUserData] getStarCount:self.worldId levelId:levelId];
        if (starCount != levelButton.starCount)
        {
            levelButton.starCount = starCount;
            levelButton.starsImage.image = [self getImageForStars:starCount];
        }
    }
}

- (IBAction)levelButtonPressed:(id)sender
{
    [self.parentWorldController performSegueWithIdentifier:@"LoadLevel" sender:sender];
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
