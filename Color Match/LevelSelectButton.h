//
//  LevelSelectButton.h
//  Color Match
//
//  Created by Linda Chen on 6/7/14.
//  Copyright (c) 2014 SunSpark Entertainment. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LevelSelectButton : UIButton
@property (nonatomic, assign) int worldId;
@property (nonatomic, assign) int levelId;
@property (nonatomic, assign) bool isComplete;
@property UIImageView *starsImage;
@property int starCount;
@end
