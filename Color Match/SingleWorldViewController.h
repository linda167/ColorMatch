//
//  SingleWorldViewController.h
//  Color Match
//
//  Created by Linda Chen on 6/15/14.
//  Copyright (c) 2014 SunSpark Entertainment. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WorldViewController.h"

@interface SingleWorldViewController : UIViewController
- (id)initWithWorldId:(int)worldId parentWorldController:(WorldViewController*)parentWorldController;
- (void)viewWillAppear;
@end
