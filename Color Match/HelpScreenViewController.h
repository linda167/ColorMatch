//
//  HelpScreenViewController.h
//  Color Match
//
//  Created by Linda Chen on 6/27/15.
//  Copyright (c) 2015 SunSpark Entertainment. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HelpScreenViewController : UIViewController

@property (nonatomic) IBOutlet UIPageControl *pageControl;

- (id)initWithParameters:(int)initialPage;

@end
