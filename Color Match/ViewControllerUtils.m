//
//  ViewControllerUtils.m
//  Color Match
//
//  Created by Linda Chen on 8/23/15.
//  Copyright (c) 2015 SunSpark Entertainment. All rights reserved.
//

#import "ViewControllerUtils.h"

@implementation ViewControllerUtils

+(int)GetTopHeaderSectionHeight
{
    return 80;
}

+(UIView*)RenderTopHeaderSection:(UIView*)parentView
{
    int viewportWidth = parentView.frame.size.width;
    int topBarHeight = [self GetTopHeaderSectionHeight];
    
    // Create top bar
    UIView* topBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, viewportWidth, topBarHeight)];
    topBar.backgroundColor = [UIColor colorWithRed:(243/255.0) green:(243/255.0) blue:(242/255.0) alpha:1];
    [parentView addSubview:topBar];
    [parentView bringSubviewToFront:topBar];
    
    return topBar;
}

@end
