//
//  WorldViewController.m
//  Color Match
//
//  Created by Linda Chen on 5/31/14.
//  Copyright (c) 2014 SunSpark Entertainment. All rights reserved.
//

#import "WorldViewController.h"
#import "MainGameViewController.h"

@interface WorldViewController ()

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
    
    // Do any additional setup after loading the view.
    [self renderLevelsDisplay:1];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)renderLevelsDisplay:(int)worldId
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
        // Add level image
        UIButton *levelButton = [[UIButton alloc] initWithFrame:CGRectMake(xOffset, yOffset, size, size)];
        [levelButton setImage:[UIImage imageNamed:@"incompleteLevel@2x.png"] forState:UIControlStateNormal];
        [levelButton addTarget:self action:@selector(levelButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self.containerView addSubview:levelButton];
        
        // Add level text
        UILabel *levelName = [[UILabel alloc] initWithFrame:CGRectMake(xOffset+20, yOffset+52, size, 25)];
        levelName.font = [UIFont fontWithName:@"Futura-Medium" size:12.0];
        NSMutableString *levelString = [[NSMutableString alloc] init];
        [levelString appendString:[NSString stringWithFormat: @"%d-", worldId]];
        [levelString appendString:[NSString stringWithFormat: @"%d", i+1]];
        levelName.text = levelString;
        [self.containerView addSubview:levelName];
        
        if ((i+1)%rowsToRender == 0)
        {
            // Time to render new line
            xOffset = xOffsetInitial;
            yOffset += heightBetweenRows;
        }
        else
        {
            xOffset += widthBetweenCols;
        }
    }
}
         
- (IBAction)levelButtonPressed:(id)sender
{
    // TODO: lindach
    [self performSegueWithIdentifier:@"LoadLevel" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    MainGameViewController *destinationController = segue.destinationViewController;
    
    if ([[segue identifier] isEqualToString:@"LoadLevel"])
    {
        // TODO: lindach
        [destinationController SetGameSize:5];
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
