//
//  CommonUtils.m
//  Color Match
//
//  Created by Linda Chen on 1/11/14.
//  Copyright (c) 2014 SunSpark Entertainment. All rights reserved.
//

#import "CommonUtils.h"

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
             view.transform = CGAffineTransformMakeScale(1.2, 1.2);
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

@end
