//
//  TeleporterGroup.h
//  Color Match
//
//  Created by Linda Chen on 7/4/14.
//  Copyright (c) 2014 SunSpark Entertainment. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TransporterGroup : NSObject
@property NSMutableArray *teleporterInputs;
@property NSMutableArray *teleporterOutputs;
@property NSMutableArray *colorInputs;
@property int currentColor;

-(void)applyColorToGroup:(NSNumber*)color isAdd:(int)isAdd;

@end
