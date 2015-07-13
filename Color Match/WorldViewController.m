//
//  WorldViewController.m
//  Color Match
//
//  Created by Linda Chen on 5/31/14.
//  Copyright (c) 2014 SunSpark Entertainment. All rights reserved.
//

#import "WorldViewController.h"
#import "LevelsManager.h"
#import "SingleWorldViewController.h"
#import "MainGameViewController.h"
#import "LevelSelectButton.h"
#import "UserData.h"
#import "SoundManager.h"

@interface WorldViewController ()
@property int pageCount;
@property BOOL pageControlUsed;
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
    
    // Start music if not already playing
    if (![SoundManager sharedManager].playingMusic)
    {
        [[SoundManager sharedManager] playMusic:@"Crazy Candy Highway.mp3" looping:YES];
    }
    
    self.viewControllers = [[NSMutableArray alloc] init];
    self.pageCount = [LevelsManager GetTotalWorldCount];
    for (int i = 0; i < self.pageCount; i++)
    {
        [self.viewControllers addObject:[NSNull null]];
    }
    
    self.scrollView.pagingEnabled = YES;
    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width * self.pageCount, self.scrollView.frame.size.height);
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.scrollsToTop = NO;
    self.scrollView.delegate = self;
    
    self.pageControl.userInteractionEnabled = YES;
    self.pageControl.numberOfPages = self.pageCount;
    self.pageControl.currentPage = 0;
    self.pageControl.enabled = TRUE;
    
    self.pageControl.frame = CGRectMake(0, self.view.frame.size.height - 45, self.view.frame.size.width, 35);
    [self.pageControl setNeedsLayout];
    
    // Set background image
    UIGraphicsBeginImageContext(self.view.frame.size);
    [[UIImage imageNamed:@"backgroundImage.png"] drawInRect:self.view.bounds];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:image];
    
    // Get last world that we completed a level
    int lastLevelCompletedInWorld = [[UserData sharedUserData] getLastLevelCompletedInWorld];
    if (lastLevelCompletedInWorld > 1)
    {
        self.pageControl.currentPage = lastLevelCompletedInWorld-1;
    }
    
    // Load views around current page
    [self loadScrollViewAroundPage:self.pageControl.currentPage];
    
    // Scroll to world to show
    if (lastLevelCompletedInWorld > 1)
    {
        [self scrollToCurrentPage:false /* animated */ ];
    }
    
    // Change navigation bar appearance
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
}

- (void)viewWillAppear:(BOOL)animated
{
    // Change navigation bar appearance
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    
    [super viewWillAppear:animated];
    [[self getCurrentPageViewController] onViewShown];
}

- (void)viewWillDisappear:(BOOL)animated
{
    // Change navigation bar appearance
    [self.navigationController.navigationBar setTintColor:nil];
    
    // Play back button sound
    if (self.isMovingFromParentViewController)
    {
        [[SoundManager sharedManager] playSound:@"backSelect.mp3" looping:NO];
    }
    
    [super viewDidDisappear:animated];
}

- (SingleWorldViewController*)getCurrentPageViewController
{
    return [self.viewControllers objectAtIndex:self.pageControl.currentPage];
}

- (void)loadScrollViewWithPage:(int)page
{
    if (page < 0) return;
    if (page >= self.pageCount) return;
    
    SingleWorldViewController *controller = [self.viewControllers objectAtIndex:page];
    
    if ((NSNull *) controller == [NSNull null])
    {
        controller = [[SingleWorldViewController alloc] initWithWorldId:page+1 parentWorldController:self];
        [self.viewControllers replaceObjectAtIndex:page withObject:controller];
    }
    
    if (nil == controller.view.superview)
    {
        CGRect frame = self.scrollView.frame;
        frame.origin.x = frame.size.width * page;
        frame.origin.y = 0;
        controller.view.frame = frame;
        [self.scrollView addSubview:controller.view];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)sender
{
    if (self.pageControlUsed)
        return;
    
    CGFloat pageWidth = self.scrollView.frame.size.width;
    int page = floor((self.scrollView.contentOffset.x - pageWidth / 3) / pageWidth) + 1;
    
    if (self.pageControl.currentPage != page)
    {
        self.pageControl.currentPage = page;
        [self loadScrollViewAroundPage:page];
        
        // Let single world page controller know it's about to be shown
        [[self getCurrentPageViewController] onViewShown];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *) scrollView
{
    self.pageControlUsed = NO;
}

- (IBAction)changePage:(id)sender
{
    int page = (int)self.pageControl.currentPage;
    [self loadScrollViewAroundPage:page];
    [self scrollToCurrentPage:true /* animated */ ];
    
    // Let single world page controller know it's about to be shown
    [[self getCurrentPageViewController] onViewShown];
}

- (void)loadScrollViewAroundPage:(int)page
{
    [self loadScrollViewWithPage:page - 1];
    [self loadScrollViewWithPage:page];
    [self loadScrollViewWithPage:page + 1];
}

- (void)scrollToCurrentPage:(bool)animated
{
    CGRect frame = self.scrollView.frame;
    frame.origin.x = frame.size.width * self.pageControl.currentPage;
    frame.origin.y = 0;
    [self.scrollView scrollRectToVisible:frame animated:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    MainGameViewController *destinationController = segue.destinationViewController;
    
    if ([[segue identifier] isEqualToString:@"LoadLevel"])
    {
        LevelSelectButton *levelSelectButton = (LevelSelectButton*)sender;
        int worldId = levelSelectButton.worldId;
        int levelId = levelSelectButton.levelId;
        
        int gameSize = [LevelsManager GetGameSizeForWorld:worldId levelId:levelId];
        [destinationController SetParametersForNewGame:gameSize worldId:worldId levelId:levelId];
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
