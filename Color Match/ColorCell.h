//
//  ColorCell.h
//  Color Match
//
//  Created by Linda Chen on 1/26/14.
//  Copyright (c) 2014 SunSpark Entertainment. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ColorCell : NSObject

@property (nonatomic, strong) UIImageView *image;
@property (nonatomic, strong) UIImageView *specialImage;
@property NSMutableArray *colorInputs;
@property int cellType;
@property int currentColor;

-(id)initWithImage: (UIImageView*)image cellType:(int)cellType;
-(void)addInputColor: (NSNumber *)color;
-(void)removeInputColor: (NSNumber *)color;
-(void)removeAllInputColors;

@end
