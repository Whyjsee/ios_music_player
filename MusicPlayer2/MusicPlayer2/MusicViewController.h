//
//  MusicViewController.h
//  MusicPlayer2
//
//  Created by abujj on 14-1-8.
//  Copyright (c) 2014年 abujj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AVFoundation/AVFoundation.h"
#import "MusicModel.h"
 
@interface MusicViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
{
    AVAudioPlayer *audioPlayer;
    NSMutableArray *musicArray;
    BOOL isPlay;
    BOOL isMusicListHidden;
    MusicModel* currentMusic;
    
    NSMutableArray *LrctimeArray;
    NSMutableDictionary *LrcDictionary;
    
}


@property (weak, nonatomic) IBOutlet UILabel *currentTime;

@property (weak, nonatomic) IBOutlet UILabel *allTime;

- (IBAction)aboveMusic:(id)sender;

- (IBAction)playMusic:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *playBtn;

- (IBAction)nextMusic:(id)sender;

- (IBAction)stopMusic:(id)sender;

@property (weak, nonatomic) IBOutlet UISlider *processSlider;

- (IBAction)processChange:(id)sender;

@property (weak, nonatomic) IBOutlet UISlider *voiceSlider;

- (IBAction)voiceChange:(id)sender;


- (IBAction)voiceOff:(id)sender;

- (IBAction)voiceOn:(id)sender;


@property (weak, nonatomic) IBOutlet UITableView *LrcTableView;
 
@property (weak, nonatomic) IBOutlet UITableView *MusicListTableView;

@end
