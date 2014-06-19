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
    
    [self loadScrollViewWithPage:0];
    [self loadScrollViewWithPage:1];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[self getCurrentPageViewController] onViewShown];
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
        
        [self loadScrollViewWithPage:page - 1];
        [self loadScrollViewWithPage:page];
        [self loadScrollViewWithPage:page + 1];
        
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
    int page = self.pageControl.currentPage;
    [self loadScrollViewWithPage:page - 1];
    [self loadScrollViewWithPage:page];
    [self loadScrollViewWithPage:page + 1];
    CGRect frame = self.scrollView.frame;
    frame.origin.x = frame.size.width * page;
    frame.origin.y = 0;
    [self.scrollView scrollRectToVisible:frame animated:YES];
    self.pageControlUsed = YES;
    
    // Let single world page controller know it's about to be shown
    [[self getCurrentPageViewController] onViewShown];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    MainGameViewController *destinationController = segue.destinationViewController;
    LevelSelectButton *levelSelectButton = (LevelSelectButton*)sender;
    
    if ([[segue identifier] isEqualToString:@"LoadLevel"])
    {
        int worldId = levelSelectButton.worldId;
        int levelId = levelSelectButton.levelId;
        int gameSize = [LevelsManager GetGameSizeForWorld:worldId levelId:levelId];
        [destinationController SetParametersForNewGame:gameSize worldId:levelSelectButton.worldId levelId:levelSelectButton.levelId];
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
