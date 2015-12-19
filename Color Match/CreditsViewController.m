//
//  CreditsViewController.m
//  Color Match
//
//  Created by Linda Chen on 12/17/15.
//  Copyright © 2015 SunSpark Entertainment. All rights reserved.
//

#import "CreditsViewController.h"

@interface CreditsViewController ()
@property int yOffset;
@property UILabel *text1;
@property UILabel *text2;
@property UILabel *text3;
@end

@implementation CreditsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Credits";
    
    // Hide scroll view
    self.scrollView.alpha = 0;
    
    void (^removeLabels)(void) = ^(void)
    {
        if (self.text1 != NULL)
        {
            [self.text1 removeFromSuperview];
        }
        
        if (self.text2 != NULL)
        {
            [self.text2 removeFromSuperview];
        }
        
        if (self.text3 != NULL)
        {
            [self.text3 removeFromSuperview];
        }
    };
    
    void (^showCredtis5)(void) = ^(void)
    {
        removeLabels();
        [self populateScrollView];
        [self autoScroll];
    };
    
    void (^showCredtis4)(void) = ^(void)
    {
        removeLabels();
        self.yOffset = self.view.frame.size.height / 2;
        self.text1 = [self addTextRow:@"UX DESIGN" bold:false size:17 yOffset:26 addToSelfView:true];
        self.text2 = [self addTextRow:@"Linda Chen Gray" bold:true size:18 yOffset:26 addToSelfView:true];
        self.text3 = [self addTextRow:@"Ben Gray" bold:true size:18 yOffset:26 addToSelfView:true];
        
        [self runBlockAfterDelay:2.5 block:showCredtis5];
    };
    
    void (^showCredtis3)(void) = ^(void)
    {
        removeLabels();
        self.yOffset = self.view.frame.size.height / 2;
        self.text1 = [self addTextRow:@"LOGO DESIGN" bold:false size:17 yOffset:26 addToSelfView:true];
        self.text2 = [self addTextRow:@"Eric Stover" bold:true size:18 yOffset:26 addToSelfView:true];
        self.text3 = [self addTextRow:@"ericjstover.com" bold:false size:16 yOffset:26 addToSelfView:true];
        
        [self runBlockAfterDelay:2.5 block:showCredtis4];
    };
    
    void (^showCredtis2)(void) = ^(void)
    {
        removeLabels();
        self.yOffset = self.view.frame.size.height / 2;
        self.text1 = [self addTextRow:@"GAME CONCEPT AND DESIGN" bold:false size:17 yOffset:26 addToSelfView:true];
        self.text2 = [self addTextRow:@"Ben Gray" bold:true size:18 yOffset:26 addToSelfView:true];
        
        [self runBlockAfterDelay:2.5 block:showCredtis3];
    };
    
    self.yOffset = self.view.frame.size.height / 2;
    self.text1 = [self addTextRow:@"SOFTWARE ENGINEERING" bold:false size:17 yOffset:26 addToSelfView:true];
    self.text2 = [self addTextRow:@"Linda Chen Gray" bold:true size:18 yOffset:26 addToSelfView:true];
    
    [self runBlockAfterDelay:2.5 block:showCredtis2];
}

- (void)runBlockAfterDelay:(NSTimeInterval)delay block:(void (^)(void))block
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, NSEC_PER_SEC*delay),
        dispatch_get_main_queue(), block);
}

- (void)populateScrollView
{
    self.scrollView.alpha = 1;
    self.scrollView.userInteractionEnabled = false;
    self.yOffset = 440;
    int sectionOffset = 40;
    int smallSectionOffset = 25;
    int bigSectionOffset = 120;
    
    [self addTextRow:@"MUSIC" bold:false size:17 yOffset:26];
    self.yOffset += smallSectionOffset;
    [self addTextRow:@"\"Crazy Candy Highway\"" bold:true size:16 yOffset:22];
    [self addTextRow:@"Eric Matyas" bold:false size:18 yOffset:22];
    [self addTextRow:@"soundimage.org" bold:false size:16 yOffset:22];
    self.yOffset += sectionOffset;
    [self addTextRow:@"\"Curious\"" bold:true size:16 yOffset:22];
    [self addTextRow:@"axtoncrolley" bold:false size:18 yOffset:22];
    [self addTextRow:@"opengameart.org/content/curious" bold:false size:16 yOffset:22];
    self.yOffset += sectionOffset;
    [self addTextRow:@"\"Happy\"" bold:true size:16 yOffset:22];
    [self addTextRow:@"syncopika" bold:false size:18 yOffset:22];
    [self addTextRow:@"opengameart.org/content/syncopika" bold:false size:16 yOffset:22];
    self.yOffset += bigSectionOffset;
    
    [self addTextRow:@"SOUND EFFECTS" bold:false size:17 yOffset:26];
    self.yOffset += smallSectionOffset;
    [self addTextRow:@"Bertrof" bold:true size:16 yOffset:22];
    [self addTextRow:@"freesound.org/people/bertrof" bold:false size:16 yOffset:22];
    self.yOffset += sectionOffset;
    [self addTextRow:@"Broumbroum" bold:true size:16 yOffset:22];
    [self addTextRow:@"b23prodtm.info" bold:false size:16 yOffset:22];
    self.yOffset += sectionOffset;
    [self addTextRow:@"Fins" bold:true size:16 yOffset:22];
    [self addTextRow:@"freesound.org/people/fins" bold:false size:16 yOffset:22];
    self.yOffset += sectionOffset;
    [self addTextRow:@"Fumiya112" bold:true size:16 yOffset:22];
    [self addTextRow:@"freesound.org/people/fumiya112" bold:false size:16 yOffset:22];
    self.yOffset += sectionOffset;
    [self addTextRow:@"Gameaudio" bold:true size:16 yOffset:22];
    [self addTextRow:@"gameaudio101.com" bold:false size:16 yOffset:22];
    self.yOffset += sectionOffset;
    [self addTextRow:@"Grant Stevens BMI" bold:true size:16 yOffset:22];
    [self addTextRow:@"varazuvi.com" bold:false size:16 yOffset:22];
    self.yOffset += sectionOffset;
    [self addTextRow:@"Greencouch" bold:true size:16 yOffset:22];
    [self addTextRow:@"greencouch.nl" bold:false size:16 yOffset:22];
    self.yOffset += sectionOffset;
    [self addTextRow:@"LittleRobotSoundFactory" bold:true size:16 yOffset:22];
    [self addTextRow:@"littlerobotsoundfactory.com" bold:false size:16 yOffset:22];
    self.yOffset += sectionOffset;
    [self addTextRow:@"Rhumphries" bold:true size:16 yOffset:22];
    [self addTextRow:@"sfx.takomamedia.com" bold:false size:16 yOffset:22];
    self.yOffset += sectionOffset;
    [self addTextRow:@"Robni7" bold:true size:16 yOffset:22];
    [self addTextRow:@"freesound.org/people/robni7" bold:false size:16 yOffset:22];
    self.yOffset += sectionOffset;
    [self addTextRow:@"Univ_lyon3" bold:true size:16 yOffset:22];
    [self addTextRow:@"freesound.org/people/univ_lyon3.com" bold:false size:16 yOffset:22];
    self.yOffset += bigSectionOffset;
    
    [self addTextRow:@"PRODUCTION BABY" bold:false size:17 yOffset:26];
    [self addTextRow:@"Abigail Olivia Gray" bold:true size:18 yOffset:26];
    [self addTextRow:@"We love you so much honey!" bold:false size:16 yOffset:26];
    self.yOffset += bigSectionOffset;
    
    [self addTextRow:@"SPECIAL THANKS" bold:false size:17 yOffset:26];
    self.yOffset += smallSectionOffset;
    [self addTextRow:@"Daniel Sweeney" bold:false size:16 yOffset:22];
    [self addTextRow:@"Richard Lico" bold:false size:16 yOffset:22];
    [self addTextRow:@"The rest of the MNC" bold:false size:16 yOffset:22];
    [self addTextRow:@"OWA Triage team" bold:false size:16 yOffset:22];
    [self addTextRow:@"SuAnne Fu" bold:false size:16 yOffset:22];
    [self addTextRow:@"Jack Mamais" bold:false size:16 yOffset:22];
    [self addTextRow:@"Inspiration - Anthony Jones" bold:false size:16 yOffset:22];
    [self addTextRow:@"The PA forums" bold:false size:16 yOffset:22];
    [self addTextRow:@"Daisy the Dog" bold:false size:16 yOffset:22];
    [self addTextRow:@"Our family and friends" bold:false size:16 yOffset:22];
    [self addTextRow:@"And of course, you for playing the game!" bold:false size:16 yOffset:22];
    
    // Set scrollView content size
    self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width, self.yOffset);
}

- (void)autoScroll
{
    // Auto scroll
    int scrollRate = 50;
    CGFloat scrollHeight = self.yOffset + 40;
    [UIView animateWithDuration:scrollHeight/scrollRate
            delay:0
            options:UIViewAnimationOptionCurveLinear
            animations:^
            {
                self.scrollView.contentOffset = CGPointMake(0, scrollHeight);
            }
            completion:^(BOOL finished)
            {
                [self showEndCredits];
            }];
}

- (void)showEndCredits
{
    self.scrollView.alpha = 0;
    
    self.yOffset = self.view.frame.size.height / 2;
    
    int logoWidth = 200;
    UIImage* image = [UIImage imageNamed:@"logo@2x.png"];
    int imageHeight = image.size.height;
    double proportion = image.size.width / logoWidth;
    imageHeight = image.size.height / proportion;
    UIImageView *logoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, logoWidth, imageHeight)];
    [logoImageView setCenter:CGPointMake(self.view.frame.size.width / 2, self.yOffset)];
    logoImageView.image = image;
    [self.view addSubview:logoImageView];
    
    self.yOffset += 90;
    self.text1 = [self addTextRow:@"A SUNSPARK PRODUCTION" bold:false size:17 yOffset:26 addToSelfView:true];
}

- (UILabel*)addTextRow:(NSString*)text bold:(bool)bold size:(int)size yOffset:(int)yOffset
{
    return [self addTextRow:text bold:bold size:size yOffset:yOffset addToSelfView:false];
}

- (UILabel*)addTextRow:(NSString*)text bold:(bool)bold size:(int)size yOffset:(int)yOffset addToSelfView:(bool)addToSelfView
{
    UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.yOffset)];
    
    if (bold)
    {
        textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:size];
    }
    else
    {
        textLabel.textColor = [UIColor colorWithRed:(51/255.0) green:(51/255.0) blue:(51/255.0) alpha:1];;
        textLabel.font = [UIFont fontWithName:@"GillSans" size:size];
    }
    
    textLabel.text = text;
    [textLabel sizeToFit];
    [textLabel setCenter:CGPointMake(self.view.frame.size.width / 2, self.yOffset)];
    
    if (addToSelfView)
    {
        [self.view addSubview:textLabel];
    }
    else
    {
        [self.scrollView addSubview:textLabel];
    }
    
    self.yOffset += yOffset;
    return textLabel;
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
