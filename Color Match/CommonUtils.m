//
//  CommonUtils.m
//  Color Match
//
//  Created by Linda Chen on 1/11/14.
//  Copyright (c) 2014 SunSpark Entertainment. All rights reserved.
//

#import "CommonUtils.h"
#import "UserData.h"
#import "SCLAlertView.h"
#import "PurchaseGameViewController.h"

@implementation CommonUtils

/*------------------------------------------
 Return results:
 0 - white
 1 - blue
 2 - Red
 3 - Yellow
 4 - Purple
 5 - Green
 6 - Orange
 7 - Brown
 ------------------------------------------*/

static NSArray *freeGameTipsList;
static NSMutableArray *tipsList;
static NSArray *winMessageListForThreeStar;
static NSArray *winMessageListForOneTwoStar;
static bool isIphone4S;
static bool isIphone6Plus;
static NSDate *lastTimeAdShown;

+(bool)shouldShowAd
{
    NSDate *now = [NSDate date];
    if (lastTimeAdShown == nil || [now timeIntervalSinceDate:lastTimeAdShown] > 120)
    {
        lastTimeAdShown = now;
        return true;
    }
    
    return false;
}

+(NSString*)GetRandomTip
{
    if (tipsList == nil)
    {
        freeGameTipsList = [[NSArray alloc] initWithObjects:
                            @"Tip: Hate the ads? Permanently remove them for only $0.99!",
                            nil];
        
        // TODO: lindach: Update tips based on tutorial completed
        tipsList = [[NSMutableArray alloc] initWithObjects:
                    @"Tip: Use the white color to clear inputs in the play field.",
                    @"Did You Know: You can change the background music in the settings menu.",
                    @"Tip: Some puzzles require white to finish.",
                    @"Fun Fact: Color Dash was inspired by a Color Theory college class.",
                    @"Tip: The \"Help\" button will show you all the possible color mixes.",
                    @"Fun Fact: Color Dash was made by only two people! We totally got married too!",
                    @"Did You Know: Moves are tracked but not counted against you.",
                    @"Did You Know: You can earn more stars by completing a level faster.",
                    @"Did You Know: The \"Help\" button also acts as a pause to catch your breath.",
                    @"Tip: Tutorials can be skipped. But don't blame us if you get confused later.",
                    @"Tip: Finishing the first 4 levels are required to play the rest of the world.",
                    @"Fun Fact: Ben conceived Color Dash in 2010 as a PC browser game.",
                    @"Tip: Don't remember how a special cell works? Use the \"Help\" button.",
                    @"Did You Know: You can disable sounds and background music on the settings page.",
                    @"Did You Know: The \"credits\" page is awesome! You should check it out.",
                    @"Fun Fact: Cool people read these messages.",
                    @"Fun Fact: Linda built a working prototype of Color Dash from scratch in just two days!",
                    @"Did You Know: Ben reads every rating review on the store. Let us hear from you!",
                    @"Fun Fact: Babies can scream very loudly when they are hungry and/or tired.",
                    @"Fun Fact: Dogs do not see in black and white. They can see yellows, blues, and purples.",
                    @"Tip: If you see a \"plus\" symbol in the play field, that means you can directly add color to it.",
                    @"Fun Fact: There is no actual dashing in Color Dash.",
                    @"Did You Know: If enough people buy the game, we'll add new content. Spread the word!",
                    nil];
    }
    
    // Add completion-based tips
    if ([[UserData sharedUserData] getTutorialComplete:3])
    {
        [tipsList addObject:@"Tip: The little arrows around the Splitter will remind you of the original color added to it."];
    }
    
    if ([[UserData sharedUserData] getTutorialComplete:4])
    {
        [tipsList addObject:@"Tip: The small circles on the Connector will tell you what color they all share."];
    }
    
    if ([[UserData sharedUserData] getTutorialComplete:6])
    {
        [tipsList addObject:@"Tip: The Zoner adds color to all surrounding cells. It can be tricky!"];
    }
    
    if ([[UserData sharedUserData] getTutorialComplete:7])
    {
        [tipsList addObject:@"Tip: Tap the Converter to change the flow of color going through it."];
    }
    
    if ([[UserData sharedUserData] getTutorialComplete:8])
    {
        [tipsList addObject:@"Tip: Transporters change color depending on the colors going in and out of them."];
    }
    
    if ([[UserData sharedUserData] getTutorialComplete:9])
    {
        [tipsList addObject:@"Tip: Shifters always follow the same color sequence; Blue, Red, Yellow, Blue."];
    }
    
    if ([[UserData sharedUserData] getGamePurchased])
    {
        return [self GetRanDomTipFromTipsList];
    }
    else
    {
        // User has not purchased full game yet
        int rand = arc4random()%5;
        if (rand == 0)
        {
            // Show free tip
            int index = arc4random()%freeGameTipsList.count;
            return [@"\n\n" stringByAppendingString:[freeGameTipsList objectAtIndex:index]];
        }
        else
        {
            return [self GetRanDomTipFromTipsList];
        }
    }
}

+(NSString*)GetRanDomTipFromTipsList
{
    int index = arc4random()%tipsList.count;
    return [@"\n\n" stringByAppendingString:[tipsList objectAtIndex:index]];
}

+(NSString*)GetRandomWinMessage:(int)stars
{
    if (stars == 3)
        return [CommonUtils GetRandomWinMessageForThreeStar];
    else
        return [CommonUtils GetRandomWinMessageForOneTwoStar];
}

+(NSString*)GetRandomWinMessageForThreeStar
{
    if (winMessageListForThreeStar == nil)
    {
        winMessageListForThreeStar = [[NSArray alloc] initWithObjects:
                          @"Nicely done!",
                          @"Great job!",
                          @"Amazing!",
                          @"Fantastic!",
                          @"Sublime!",
                          @"Phenomenal!",
                          @"Extraordinary!",
                          @"You're the best!",
                          @"Masterful!",
                          nil];
    }
    
    int index = arc4random()%winMessageListForThreeStar.count;
    return [winMessageListForThreeStar objectAtIndex:index];
}

+(NSString*)GetRandomWinMessageForOneTwoStar
{
    if (winMessageListForOneTwoStar == nil)
    {
        winMessageListForOneTwoStar = [[NSArray alloc] initWithObjects:
                                       @"Not bad.",
                                       @"Good.",
                                       @"A solid performance.",
                                       @"Keep it up.",
                                       @"Rock on.",
                                       @"Way to go.",
                                       @"Tip-top.",
                                       @"Soundly done.",
                                       nil];
    }
    
    int index = arc4random()%winMessageListForOneTwoStar.count;
    return [winMessageListForOneTwoStar objectAtIndex:index];
}

+(int)CombineColorsList:(NSMutableArray*)colorList
{
    NSMutableArray* dedupedColorList = [self RemoveDuplicatesAndWhite:colorList];
    
    if (dedupedColorList.count == 3)
    {
        return 7;
    }
    else if (dedupedColorList.count == 2)
    {
        int color1 = [(NSNumber*)[dedupedColorList objectAtIndex:0] intValue];
        int color2 = [(NSNumber*)[dedupedColorList objectAtIndex:1] intValue];
        return [self CombineTwoColors:color1 color2:color2];
    }
    else if (dedupedColorList.count == 1)
    {
        return [(NSNumber*)[dedupedColorList objectAtIndex:0] intValue];
    }
    else
    {
        return 0;
    }
}

+(NSMutableArray*)RemoveDuplicatesAndWhite:(NSMutableArray*)colorList
{
    NSMutableArray *colorListCopy = [NSMutableArray arrayWithArray:colorList];
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    for (NSNumber* color in colorListCopy)
    {
        if ([dictionary objectForKey:(color)] == nil)
        {
            // We haven't encountered this color yet, add it to dictionary and continue
            [dictionary setObject:[NSNumber numberWithInt:1] forKey:color];
        }
    }
    
    NSMutableArray* colorListWithoutDuplicates = [[NSMutableArray alloc] init];
    for (NSNumber* color in dictionary)
    {
        if (color.intValue != 0)
        {
            [colorListWithoutDuplicates addObject:color];
        }
    }
    
    return colorListWithoutDuplicates;
}

+(int)CombineTwoColors:(int)color1 color2:(int)color2
{
    if (color1 == 0 && color2 == 0)
    {
        return 0;
    }
    else if ((color1 == 1 && color2 == 1) || (color1 == 1 && color2 == 0) || (color1 == 0 && color2 == 1))
    {
        return 1;
    }
    else if ((color1 == 2 && color2 == 2) || (color1 == 2 && color2 == 0) || (color1 == 0 && color2 == 2))
    {
        return 2;
    }
    else if ((color1 == 3 && color2 == 3) || (color1 == 3 && color2 == 0) || (color1 == 0 && color2 == 3))
    {
        return 3;
    }
    else if ((color1 == 1 && color2 == 2) || (color1 == 2 && color2 == 1))
    {
        return 4;
    }
    else if ((color1 == 1 && color2 == 3) || (color1 == 3 && color2 == 1))
    {
        return 5;
    }
    else if ((color1 == 2 && color2 == 3) || (color1 == 3 && color2 == 2))
    {
        return 6;
    }
    
    // Should not be hit
    return 0;
}

+(UIImage *) GetCellImageForColor:(int)color
{
    switch (color)
    {
        case 0:
            return [UIImage imageNamed:@"BlockWhite.png"];
            break;
        case 1:
            return [UIImage imageNamed:@"BlockBlue.png"];
            break;
        case 2:
            return [UIImage imageNamed:@"BlockRed.png"];
            break;
        case 3:
            return [UIImage imageNamed:@"BlockYellow.png"];
            break;
        case 4:
            return [UIImage imageNamed:@"BlockPurple.png"];
            break;
        case 5:
            return [UIImage imageNamed:@"BlockGreen.png"];
            break;
        case 6:
            return [UIImage imageNamed:@"BlockOrange.png"];
            break;
        case 7:
            return [UIImage imageNamed:@"BlockBrown.png"];
            break;
        default:
            return [UIImage imageNamed:@"BlockWhite.png"];
            break;
    }
}

+(UIColor *) GetGrayColor
{
    return [UIColor colorWithRed:(192/255.0) green:(192/255.0) blue:(192/255.0) alpha:1];
}

+(UIColor *) GetBlueColor
{
    return [UIColor colorWithRed:(41/255.0) green:(71/255.0) blue:(242/255.0) alpha:1];
}

+(UIColor *) GetYellowColor
{
    return [UIColor colorWithRed:(247/255.0) green:(206/255.0) blue:(0/255.0) alpha:1];
}

+(UIColor *) GetRedColor
{
    return [UIColor colorWithRed:(221/255.0) green:(37/255.0) blue:(37/255.0) alpha:1];
}

+(UIColor *) GetPurpleColor
{
    return [UIColor colorWithRed:(155/255.0) green:(51/255.0) blue:(204/255.0) alpha:1];
}

+(UIColor *) GetGreenColor
{
    return [UIColor colorWithRed:(79/255.0) green:(175/255.0) blue:(38/255.0) alpha:1];
}

+(UIColor *) GetOrangeColor
{
    return [UIColor colorWithRed:(255/255.0) green:(125/255.0) blue:(56/255.0) alpha:1];
}

+(UIColor *) GetBrownColor
{
    return [UIColor colorWithRed:(173/255.0) green:(98/255.0) blue:(0/255.0) alpha:1];
}

+(UIColor *) GetUIColorForColor:(int)colorValue
{
    UIColor *color;
    if (colorValue == 0)
    {
        color = [CommonUtils GetGrayColor];
    }
    else if (colorValue == 1)
    {
        color = [CommonUtils GetBlueColor];
    }
    else if (colorValue == 2)
    {
        color = [CommonUtils GetRedColor];
    }
    else if (colorValue == 3)
    {
        color = [CommonUtils GetYellowColor];
    }
    else if (colorValue == 4)
    {
        color = [CommonUtils GetPurpleColor];
    }
    else if (colorValue == 5)
    {
        color = [CommonUtils GetGreenColor];
    }
    else if (colorValue == 6)
    {
        color = [CommonUtils GetOrangeColor];
    }
    else if (colorValue == 7)
    {
        color = [CommonUtils GetBrownColor];
    }
    
    return color;
}

+(void) Log:(NSMutableString*)string
{
    NSLog(@"%@", string);
}

+(UIImage *) GetConnectorInnerImageForColor:(int)color
{
    switch (color)
    {
        case 0:
            return [UIImage imageNamed:@"connectorInnerWhite@2x.png"];
            break;
        case 1:
            return [UIImage imageNamed:@"connectorInnerBlue@2x.png"];
            break;
        case 2:
            return [UIImage imageNamed:@"connectorInnerRed@2x.png"];
            break;
        case 3:
            return [UIImage imageNamed:@"connectorInnerYellow@2x.png"];
            break;
        case 4:
            return [UIImage imageNamed:@"connectorInnerPurple@2x.png"];
            break;
        case 5:
            return [UIImage imageNamed:@"connectorInnerGreen@2x.png"];
            break;
        case 6:
            return [UIImage imageNamed:@"connectorInnerOrange@2x.png"];
            break;
        case 7:
            return [UIImage imageNamed:@"connectorInnerBrown@2x.png"];
            break;
        default:
            return [UIImage imageNamed:@"BlockWhite.png"];
            break;
    }
}

+(UIImage *) GetShifterInnerImageForColor:(int)color
{
    switch (color)
    {
        case 0:
            return [UIImage imageNamed:@"shifterInnerWhite@2x.png"];
            break;
        case 1:
            return [UIImage imageNamed:@"shifterInnerBlue@2x.png"];
            break;
        case 2:
            return [UIImage imageNamed:@"shifterInnerRed@2x.png"];
            break;
        case 3:
            return [UIImage imageNamed:@"shifterInnerYellow@2x.png"];
            break;
        case 4:
            return [UIImage imageNamed:@"shifterInnerPurple@2x.png"];
            break;
        case 5:
            return [UIImage imageNamed:@"shifterInnerGreen@2x.png"];
            break;
        case 6:
            return [UIImage imageNamed:@"shifterInnerOrange@2x.png"];
            break;
        case 7:
            return [UIImage imageNamed:@"shifterInnerBrown@2x.png"];
            break;
        default:
            return [UIImage imageNamed:@"BlockWhite.png"];
            break;
    }
}

+(UIImage *) GetConnectorOuterImageForColor:(int)color
{
    switch (color)
    {
        case 0:
            return [UIImage imageNamed:@"connectorOuterWhite@2x.png"];
            break;
        case 1:
            return [UIImage imageNamed:@"connectorOuterBlue@2x.png"];
            break;
        case 2:
            return [UIImage imageNamed:@"connectorOuterRed@2x.png"];
            break;
        case 3:
            return [UIImage imageNamed:@"connectorOuterYellow@2x.png"];
            break;
        default:
            return [UIImage imageNamed:@"BlockWhite.png"];
            break;
    }
}

+(void)AnimateViewsAffected:(NSMutableArray*)viewsToAnimate
{
    [UIView
     animateWithDuration:.07
     delay:0
     options:UIViewAnimationOptionCurveLinear
     animations:^
     {
         for (UIView* view in viewsToAnimate)
         {
             view.transform = CGAffineTransformMakeScale(1.3, 1.3);
         }
     }
     completion:^(BOOL finished)
     {
         [UIView
          animateWithDuration:.07
          delay:0
          options:UIViewAnimationOptionCurveLinear
          animations:^
          {
              for (UIView* view in viewsToAnimate)
              {
                  view.transform = CGAffineTransformIdentity;
              }
          }
          completion:^(BOOL finished){}];
         
     }];
}

+(bool) IsTransporterCell:(CellType)cellType
{
    return [CommonUtils IsTransporterInput:cellType] ||
        [CommonUtils IsTransporterOutput:cellType];
}

+(bool) IsTransporterOutput:(CellType)cellType
{
    switch (cellType)
    {
        case TransporterOutputDown:
            return true;
        case TransporterOutputRight:
            return true;
        default:
            return false;
    }
    
    return false;
}

+(bool) IsTransporterInput:(CellType)cellType
{
    switch (cellType)
    {
        case TransporterInputLeft:
            return true;
        case TransporterInputTop:
            return true;
        default:
            return false;
    }
    
    return false;
}

+(void) ShowLockedLevelMessage:(int)worldId levelId:(int)levelId isFromPreviousLevel:(bool)isFromPreviousLevel viewController:(UIViewController*)viewController triggerBackOnDismiss:(bool)triggerBackOnDismiss
{
    NSString* lockString = [[UserData sharedUserData] getLevelLockedMessage:worldId levelId:levelId isFromPreviousLevel:isFromPreviousLevel];
    
    SCLAlertView *alert = [[SCLAlertView alloc] init];
    
    [alert alertIsDismissed:^{
        if (triggerBackOnDismiss)
        {
            [viewController.navigationController popViewControllerAnimated:YES];
        }
    }];
    
    [alert showNotice:viewController title:@"Level Locked" subTitle:lockString closeButtonTitle:@"OK" duration:0.0f];
}

+(void)runBlockAfterDelay:(NSTimeInterval)delay block:(void (^)(void))block
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, NSEC_PER_SEC*delay),
                   dispatch_get_main_queue(), block);
}

+(void)determineIphone4S:(UIView*)view
{
    isIphone4S = view.frame.size.height == 480;
}

+(bool)IsIphone4S
{
    return isIphone4S;
}

+(void)determineIphone6Plus:(UIView*)view
{
    isIphone6Plus = view.frame.size.height == 736;
}

+(bool)IsIphone6Plus
{
    return isIphone6Plus;
}

@end
