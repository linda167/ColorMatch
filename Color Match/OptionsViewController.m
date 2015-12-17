//
//  OptionsViewController.m
//  Color Match
//
//  Created by Linda Chen on 8/23/15.
//  Copyright (c) 2015 SunSpark Entertainment. All rights reserved.
//

#import "OptionsViewController.h"
#import "ViewControllerUtils.h"
#import "UserData.h"
#import "SoundManager.h"
#import "PaymentManager.h"
#import <QuartzCore/QuartzCore.h>

@interface OptionsViewController ()
@property UIButton *soundCheckButton;
@property UIButton *musicCheckButton;
@property NSMutableArray *musicData;
@property UITableView *tableView;
@end

@implementation OptionsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Create title
    int titleOffset = 100;
    UILabel *optionsTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 50)];
    optionsTitle.font = [UIFont fontWithName:@"Futura-Medium" size:20.0];
    optionsTitle.textColor = [UIColor blackColor];
    optionsTitle.text = [NSString stringWithFormat: @"Settings"];
    [optionsTitle sizeToFit];
    [optionsTitle setCenter:CGPointMake(self.view.frame.size.width / 2 - 10, titleOffset)];
    [self.view addSubview:optionsTitle];
    
    // Add sound option
    int xOffset = 30;
    int yOffset = titleOffset+50;
    self.soundCheckButton = [self
        addButtonWithText:@"Enable sound effects"
        xOffset:xOffset
        yOffset:yOffset
        checked:[[UserData sharedUserData] getIsSoundEnabled]];
    [self.soundCheckButton addTarget:self action:@selector(soundCheckBoxPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    // Add music option
    yOffset = yOffset+55;
    self.musicCheckButton = [self
        addButtonWithText:@"Enable background music"
        xOffset:xOffset
        yOffset:yOffset
        checked:[[UserData sharedUserData] getIsMusicEnabled]];
    [self.musicCheckButton addTarget:self action:@selector(musicCheckBoxPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    // Add music data
    self.musicData = [[NSMutableArray alloc] init];
    
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    [dictionary setObject:@"Crazy Candy Highway" forKey:@"data"];
    [self.musicData addObject:dictionary];
    
    dictionary = [[NSMutableDictionary alloc] init];
    [dictionary setObject:@"Curious" forKey:@"data"];
    [self.musicData addObject:dictionary];
    
    dictionary = [[NSMutableDictionary alloc] init];
    [dictionary setObject:@"Happy Tune" forKey:@"data"];
    [self.musicData addObject:dictionary];
    
    // Add music selection
    yOffset = yOffset+42;
    CGRect tableFrame = CGRectMake(xOffset+44, yOffset, 240, 130);
    self.tableView = [[UITableView alloc]initWithFrame:tableFrame style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.scrollEnabled = NO;
    self.tableView.separatorColor = [UIColor clearColor];
    [self.tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    [self.view addSubview:self.tableView];
    
    // Add restore purchases option
    bool isPurchased = [[UserData sharedUserData] getGamePurchased];
    if (!isPurchased)
    {
        yOffset = yOffset+120;
        UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [button setFrame:CGRectMake(26, yOffset, 160, 40)];
        [button addTarget:self action:@selector(restorePurchase:) forControlEvents:UIControlEventTouchUpInside];
        button.titleLabel.font = [UIFont fontWithName:@"Futura-Medium" size:18.0];
        [button setTitle:@"Restore purchases" forState:UIControlStateNormal];
        [self.view addSubview:button];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.musicData.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Set music option text
    NSString *musicText = [[self.musicData objectAtIndex:indexPath.row] objectForKey:@"data"];
    cell.textLabel.font = [UIFont fontWithName:@"Futura-Medium" size:16.0];
    cell.textLabel.text = musicText;
    
    // Show checkmark on checked option
    if ([[musicText stringByAppendingString:@".mp3"] isEqualToString:[[UserData sharedUserData] getMusicSelection]])
    {
        cell.textLabel.text = [@"\u2713  " stringByAppendingString:cell.textLabel.text];
    }
    else
    {
        cell.textLabel.text = [@"\u2001  " stringByAppendingString:cell.textLabel.text];
    }
    
    // Disable cell if music option is disabled
    bool musicEnabled = [[UserData sharedUserData] getIsMusicEnabled];
    cell.userInteractionEnabled = musicEnabled;
    cell.textLabel.enabled = musicEnabled;
    cell.detailTextLabel.enabled = musicEnabled;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *songName =[[[self.musicData objectAtIndex:indexPath.row] objectForKey:@"data"]
                         stringByAppendingString:@".mp3"];
    
    if ([songName isEqualToString:[[UserData sharedUserData] getMusicSelection]])
    {
        [self.tableView reloadData];
        return;
    }
    
    [[SoundManager sharedManager] playSound:@"menuSelect.mp3" looping:NO];
    
    // Store new music selection
    [[UserData sharedUserData] storeMusicSelection:songName];
    
    [self.tableView reloadData];
    
    // Play new music
    [[SoundManager sharedManager] playMusic:songName looping:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 34;
}

- (UIButton*)addButtonWithText:(NSString*)text xOffset:(int)xOffset yOffset:(int)yOffset checked:(bool)checked
{
    // Add button
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(xOffset, yOffset, 40, 40)];
    UIImage *buttonImage = [self getCheckBoxImageBasedOnState:checked];
    [button setImage:buttonImage forState:UIControlStateNormal];
    [self.view addSubview:button];
    
    // Add text
    xOffset += 60;
    yOffset += 9;
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(xOffset, yOffset, 100, 50)];
    title.font = [UIFont fontWithName:@"Futura-Medium" size:16.0];
    title.textColor = [UIColor blackColor];
    title.text = text;
    [title sizeToFit];
    [self.view addSubview:title];

    return button;
}

- (UIImage*)getCheckBoxImageBasedOnState:(bool)checked
{
    return checked ?
        [UIImage imageNamed:@"checkedBox@2x.png"] :
        [UIImage imageNamed:@"uncheckedBox@2x.png"];
}

- (IBAction)soundCheckBoxPressed:(id)sender
{
    bool isSoundEnabled = [[UserData sharedUserData] getIsSoundEnabled];
    
    // Toggle sound enabled
    isSoundEnabled = !isSoundEnabled;
    
    UIImage *checkboxImage = [self getCheckBoxImageBasedOnState:isSoundEnabled];
    
    [self.soundCheckButton setImage:checkboxImage forState:UIControlStateNormal];
    
    [[UserData sharedUserData] storeIsSoundEnabled:isSoundEnabled];
    
    [[SoundManager sharedManager] playSound:@"menuSelect.mp3" looping:NO forcePlay:true];
}

- (IBAction)musicCheckBoxPressed:(id)sender
{
    bool isMusicEnabled = [[UserData sharedUserData] getIsMusicEnabled];
    
    // Toggle music enabled
    isMusicEnabled = !isMusicEnabled;
    
    UIImage *checkboxImage = [self getCheckBoxImageBasedOnState:isMusicEnabled];
    
    [self.musicCheckButton setImage:checkboxImage forState:UIControlStateNormal];
    
    [[UserData sharedUserData] storeIsMusicEnabled:isMusicEnabled];
    
    [[SoundManager sharedManager] playSound:@"menuSelect.mp3" looping:NO];
    
    if (isMusicEnabled)
    {
        [[SoundManager sharedManager] playMusic:[[UserData sharedUserData] getMusicSelection] looping:YES];
    }
    else
    {
        [[SoundManager sharedManager] stopMusic];
    }
    
    [self.tableView reloadData];
}

- (IBAction)restorePurchase:(id)sender
{
    [[PaymentManager instance] RestorePurchase];
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
