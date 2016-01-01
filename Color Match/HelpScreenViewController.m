//
//  HelpScreenViewController.m
//  Color Match
//
//  Created by Linda Chen on 6/27/15.
//  Copyright (c) 2015 SunSpark Entertainment. All rights reserved.
//

#import "HelpScreenViewController.h"
#import "MainGameViewController.h"
#import "ViewControllerUtils.h"
#import <Google/Analytics.h>

@interface HelpScreenViewController ()
@property int worldId;
@property int pageCount;
@property BOOL pageControlUsed;
@property (nonatomic, retain) NSMutableArray *helpSubViews;
@property (nonatomic) IBOutlet UIScrollView *scrollView;
@end

@implementation HelpScreenViewController

- (id)initWithParameters:(int)worldId
{
    self = [super init];
    if (self)
    {
        self.worldId = worldId;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    int viewportWidth = self.view.frame.size.width;
    int viewportHeight = self.view.frame.size.height;
    int topBarHeight = [ViewControllerUtils GetTopHeaderSectionHeight];
    
    // Initialize the scrollView
    self.helpSubViews = [[NSMutableArray alloc] init];
    self.pageCount = 9;
    for (int i = 0; i < self.pageCount; i++)
    {
        [self.helpSubViews addObject:[NSNull null]];
    }
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,topBarHeight,viewportWidth, viewportHeight - topBarHeight)];
    self.scrollView.pagingEnabled = YES;
    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width * self.pageCount, self.scrollView.frame.size.height);
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.scrollsToTop = NO;
    self.scrollView.delegate = self;
    [self.view addSubview:self.scrollView];
    
    self.pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0,viewportHeight - 80, viewportWidth, 70)];
    self.pageControl.userInteractionEnabled = YES;
    self.pageControl.numberOfPages = self.pageCount;
    self.pageControl.currentPage = 0;
    self.pageControl.enabled = TRUE;
    [self.pageControl addTarget:self action:@selector(changePage:) forControlEvents:UIControlEventTouchUpInside];
    self.pageControl.pageIndicatorTintColor = [UIColor colorWithRed:(224/255.0) green:(224/255.0) blue:(224/255.0) alpha:1];
    self.pageControl.currentPageIndicatorTintColor = [UIColor colorWithRed:(135/255.0) green:(135/255.0) blue:(135/255.0) alpha:1];
    [self.view addSubview:self.pageControl];
    
    // Load views around current page
    if (self.worldId < 10)
    {
        self.pageControl.currentPage = self.worldId - 1;
    }
    
    [self loadScrollViewAroundPage:(int)self.pageControl.currentPage];
    
    // Scroll to page to show
    if (self.pageControl.currentPage > 0)
    {
        [self scrollToCurrentPage:false /* animated */ ];
    }
    
    // Add white background to host the image
    UIView* helpScreen = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, viewportWidth, viewportHeight)];
    helpScreen.backgroundColor = [UIColor colorWithRed:(255/255.0) green:(255/255.0) blue:(255/255.0) alpha:1];
    
    // Center the logo
    helpScreen.center = self.view.center;
    [self.view addSubview:helpScreen];
    [self.view bringSubviewToFront:self.scrollView];
    [self.view bringSubviewToFront:self.pageControl];
    
    // Create top bar
    UIView *topBar = [ViewControllerUtils RenderTopHeaderSection:self.view];
    
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

- (void)loadScrollViewWithPage:(int)page
{
    if (page < 0) return;
    if (page >= self.pageCount) return;
    
    UIImageView *imageView = [self.helpSubViews objectAtIndex:page];
    
    if ((NSNull *) imageView == [NSNull null])
    {
        bool isIphone4S = [CommonUtils IsIphone4S];
        
        UIImage* image = [self getImageForPage:page];
        int viewportWidth = self.view.frame.size.width;
        int imageHeight;
        
        if (isIphone4S)
        {
            viewportWidth = .85 * viewportWidth;
        }
        
        double proportion = image.size.width / viewportWidth;
        imageHeight = image.size.height / proportion;
        
        imageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.scrollView.frame.size.width * page, 0, viewportWidth, imageHeight)];
        [imageView setCenter:CGPointMake(self.view.center.x + self.scrollView.frame.size.width * page, self.view.center.y)];
        CGRect frame = imageView.frame;
        frame.origin.y = 0;
        imageView.frame = frame;
        imageView.image = image;
        [self.helpSubViews replaceObjectAtIndex:page withObject:imageView];
        
        [self.scrollView addSubview:imageView];
    }
}

- (UIImage*)getImageForPage:(int)page
{
    switch (page)
    {
        case 0:
            return [UIImage imageNamed:@"00pauseColorMix@2x.png"];
        case 1:
            return [UIImage imageNamed:@"01pauseReflector@2x.png"];
        case 2:
            return [UIImage imageNamed:@"02pauseSplitter@2x.png"];
        case 3:
            return [UIImage imageNamed:@"03pauseConnector@2x.png"];
        case 4:
            return [UIImage imageNamed:@"04pauseDiverter@2x.png"];
        case 5:
            return [UIImage imageNamed:@"05pauseZoner@2x.png"];
        case 6:
            return [UIImage imageNamed:@"06pauseConverter@2x.png"];
        case 7:
            return [UIImage imageNamed:@"07pauseTransporter@2x.png"];
        case 8:
            return [UIImage imageNamed:@"08pauseShifter@2x.png"];
        default:
            return NULL;
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
}

- (void)loadScrollViewAroundPage:(int)page
{
    [self loadScrollViewWithPage:page - 1];
    [self loadScrollViewWithPage:page];
    [self loadScrollViewWithPage:page + 1];
    
    // Instrument
    NSString *name = [NSString stringWithFormat:@"Help page %d", page+1];
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName value:name];
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
}

- (void)scrollToCurrentPage:(bool)animated
{
    CGRect frame = self.scrollView.frame;
    frame.origin.x = frame.size.width * self.pageControl.currentPage;
    frame.origin.y = 0;
    [self.scrollView scrollRectToVisible:frame animated:animated];
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
