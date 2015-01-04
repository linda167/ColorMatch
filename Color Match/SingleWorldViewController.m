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
        
        UIGraphicsBeginImageContext(self.view.frame.size);
        [[UIImage imageNamed:@"backgroundImage.png"] drawInRect:self.view.bounds];
        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        self.view.backgroundColor = [UIColor colorWithPatternImage:image];
        
        // Uncomment if we want colored wrolds in future
        // self.view.backgroundColor = [self getBackgroundColorForWorld:worldId];
    }
    return self;
}

- (UIColor*)getBackgroundColorForWorld:(int)worldId
{
    switch (worldId)
    {
        case 1:
        case 7:
            // Aqua
            return [UIColor colorWithRed:(124/255.0) green:(190/255.0) blue:(204/255.0) alpha:1];
            break;
            
        case 2:
        case 8:
            // Yellow
            return [UIColor colorWithRed:(255/255.0) green:(233/255.0) blue:(127/255.0) alpha:1];
            break;
            
        case 3:
        case 9:
            // Red
            return [UIColor colorWithRed:(255/255.0) green:(186/255.0) blue:(186/255.0) alpha:1];
            break;
            
        case 4:
        case 10:
            // Green
            return [UIColor colorWithRed:(161/255.0) green:(204/255.0) blue:(142/255.0) alpha:1];
            break;
        
        case 5:
            // Orange
            return [UIColor colorWithRed:(255/255.0) green:(178/255.0) blue:(147/255.0) alpha:1];
            break;
        
        case 6:
            // Purple
            return [UIColor colorWithRed:(190/255.0) green:(163/255.0) blue:(204/255.0) alpha:1];
            break;
            
        default:
            return [UIColor colorWithRed:(255/255.0) green:(255/255.0) blue:(255/255.0) alpha:1];;
            break;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.levelButtons = [[NSMutableArray alloc] init];
    self.isFirstTimeViewCreation = true;
    
    // Change navigation bar appearance
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    
    // Do any additional setup after loading the view.
    [self renderWorldTitleDisplay];
    if (self.worldId < 10)
    {
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
    if (self.worldId != 1)
    {
        UILabel *worldTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
        worldTitle.font = [UIFont fontWithName:@"Harrington" size:26.0];
        worldTitle.textColor = [UIColor colorWithRed:(255/255.0) green:(255/255.0) blue:(255/255.0) alpha:1];
        worldTitle.text = [NSString stringWithFormat: @"World %d", self.worldId];
        [worldTitle sizeToFit];
        [worldTitle setCenter:CGPointMake(self.view.frame.size.width / 2, 97)];
        
        [self.view addSubview:worldTitle];
    }
    else
    {
        // TODO: lindach
        UIImageView *worldTitle = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 123, 34)];
        worldTitle.image = [UIImage imageNamed:@"World1@2x.png"];
        [worldTitle setCenter:CGPointMake(self.view.frame.size.width / 2, 100)];
        [self.view addSubview:worldTitle];
    }
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
    int yOffsetInitial = 135;
    int xOffset = xOffsetInitial;
    int yOffset = yOffsetInitial;
    int size = 60;
    int heightBetweenRows = 95;
    int widthBetweenCols = 75;
    int levelNameYOffset = 55;
    for (int i=0; i<totalLevelsToRender; i++)
    {
        // Figure out if level is complete
        int levelId = i+1;
        bool isLevelComplete = [[UserData sharedUserData] getLevelCompleteState:self.worldId levelId:levelId];
        UIImage *buttonImage = [self getImageForLevel:isLevelComplete levelId:levelId];
        
        // Add level button
        LevelSelectButton *levelButton = [[LevelSelectButton alloc] initWithFrame:CGRectMake(xOffset, yOffset, size, size)];
        [levelButton setImage:buttonImage forState:UIControlStateNormal];
        [levelButton addTarget:self action:@selector(levelButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        levelButton.worldId = self.worldId;
        levelButton.levelId = levelId;
        levelButton.isComplete = isLevelComplete;
        [self.levelButtons addObject:levelButton];
        [self.view addSubview:levelButton];
        
        int textXOffset = levelId < 10 ? 19 : 15;
        
        // Add level text
        UILabel *levelName = [[UILabel alloc] initWithFrame:CGRectMake(xOffset+textXOffset, yOffset+levelNameYOffset, size, 25)];
        levelName.font = [UIFont fontWithName:@"Futura-Medium" size:14.0];
        levelName.textColor = [UIColor whiteColor];
        levelName.shadowColor = [UIColor colorWithRed:(64/255.0) green:(64/255.0) blue:(64/255.0) alpha:1];
        levelName.shadowOffset = CGSizeMake(1,1);
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

- (UIImage*)getImageForLevel:(bool)isComplete levelId:(int)levelId
{
    if (!isComplete)
    {
        return [UIImage imageNamed:@"incompleteLevel@2x.png"];
    }
    else
    {
        int starCount = [[UserData sharedUserData] getStarCount:self.worldId levelId:levelId];
        return [self getImageForStars:starCount];
    }
}

- (UIImage*)getImageForStars:(int)starCount
{
    if (starCount == 1)
        return [UIImage imageNamed:@"1stars@2x.png"];
    else if (starCount == 2 || starCount == 3)
        return [UIImage imageNamed:@"2stars@2x.png"];
    else 
        return [UIImage imageNamed:@"3stars@2x.png"];
    
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
            UIImage *buttonImage = [self getImageForLevel:isLevelComplete levelId:levelId];
            [levelButton setImage:buttonImage forState:UIControlStateNormal];
            levelButton.isComplete = isLevelComplete;
        }
        
        // Update stars
        int starCount = [[UserData sharedUserData] getStarCount:self.worldId levelId:levelId];
        if (starCount != levelButton.starCount)
        {
            levelButton.starCount = starCount;
            [levelButton setImage:[self getImageForStars:starCount] forState:UIControlStateNormal];
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
