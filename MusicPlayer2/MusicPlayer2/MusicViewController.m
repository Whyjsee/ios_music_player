

#import "MusicViewController.h"
#import "MusicModel.h"

@interface MusicViewController ()

@end

@implementation MusicViewController
@synthesize voiceSlider;
@synthesize processSlider;
@synthesize playBtn;
@synthesize allTime;
@synthesize currentTime;
@synthesize MusicListTableView;
@synthesize LrcTableView;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void) initViewControllerData
{
     
    MusicModel *music1 = [[MusicModel alloc]initWithName:@"梁静茹 - 你还记得我吗" andType:@"mp3"];
    MusicModel *music2 = [[MusicModel alloc]initWithName:@"2" andType:@"mp3"];
    MusicModel *music3 = [[MusicModel alloc]initWithName:@"3" andType:@"mp3"];
    
    
    musicArray = [[NSMutableArray alloc]initWithCapacity:5];
    
    [musicArray addObject:music1];
    [musicArray addObject:music2];
    [musicArray addObject:music3];
    
    currentMusic = music1;
    
    audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:[[NSBundle mainBundle]pathForResource:music1.name ofType:music1.type ]] error:nil];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
   [self initViewControllerData];
    isPlay = NO;
    isMusicListHidden = YES;
    MusicListTableView.hidden = YES;
     
    
//  [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(showTime) userInfo:nil repeats:YES];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeInfoLight];
    
    [btn addTarget:self action:@selector(showMusicList) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:btn];
   
    
    LrctimeArray = [[NSMutableArray alloc]initWithCapacity:10];
    LrcDictionary=[[NSMutableDictionary alloc]initWithCapacity:10];
    
     [self initLRC];
}

-(void) showMusicList
{
    if (isMusicListHidden) {
        MusicListTableView.hidden=NO;
        isMusicListHidden = NO;
    }else
    {
        MusicListTableView.hidden=YES;
        isMusicListHidden = YES;
    }
}
-(void) initLRC
{
    NSString *LrcPath = [[NSBundle mainBundle]pathForResource:currentMusic.name ofType:@"lrc"];
    NSString *contentStr = [NSString stringWithContentsOfFile:LrcPath encoding:NSUTF8StringEncoding error:nil];
    
    NSArray *arry = [contentStr componentsSeparatedByString:@"\n"];
      for (int i=3; i<[arry count]; i++)
    {
        NSString *linStr = [arry objectAtIndex:i];
        NSArray *lineArray = [linStr componentsSeparatedByString:@"]"];
          
        if ([[lineArray objectAtIndex:0] length]>5) {
         
                NSString *lrcStr = [lineArray objectAtIndex:1];
            
            NSString *timeStr = [[lineArray objectAtIndex:0]substringWithRange:NSMakeRange(1, 5)];
         
            [LrcDictionary setObject:lrcStr forKey:timeStr];
            [LrctimeArray addObject:timeStr]; 
        }
    } 
}

-(void) displaySongWord:(NSUInteger)time
{
    NSLog(@"%u",time);
    static int indexq=0;
    NSArray *ary = [[LrctimeArray objectAtIndex:indexq] componentsSeparatedByString:@":"];
    
    NSUInteger currentTimeq = [[ary objectAtIndex:0]intValue]*60+[[ary objectAtIndex:1] intValue];
    
    if (time==currentTimeq) {
        [self updateLrcTableView:indexq];
        indexq++;
    }
}

-(void) updateLrcTableView:(NSUInteger)index
{
    NSLog(@"%@",[LrcDictionary objectForKey:[LrctimeArray objectAtIndex:index]]); 
    NSIndexPath* indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    [LrcTableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionMiddle];
}

- (IBAction)aboveMusic:(id)sender {
    
    MusicModel *abovemusic = [musicArray lastObject];
    audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:[[NSBundle mainBundle]pathForResource:abovemusic.name ofType:abovemusic.type ]] error:nil];
    
    isPlay=false;
    
    [self playMusic:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)showTime
{
    NSString *txtformat = @"%d:%d";
    
    if ((int)audioPlayer.currentTime%60<10) {
        txtformat= @"%d:0%d";
    }
    currentTime.text = [NSString  stringWithFormat:txtformat,(int)audioPlayer.currentTime/60,(int)audioPlayer.currentTime%60];
    
    processSlider.value = audioPlayer.currentTime/audioPlayer.duration;
    
    [self displaySongWord:audioPlayer.currentTime];
}

- (IBAction)playMusic:(id)sender {
    if (!isPlay) {
        isPlay=YES;
        [audioPlayer play];
        [playBtn setTitle:@"playing" forState:UIControlStateNormal];
        [playBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    }else{
        isPlay=NO;
        [audioPlayer pause];
        [playBtn setTitle:@"pause" forState:UIControlStateNormal];
        [playBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    }
    allTime.text = [NSString stringWithFormat:@"%d:%d",(int)audioPlayer.duration/60,(int)audioPlayer.duration%60];
    
    [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(showTime) userInfo:nil repeats:YES];

   
}

- (IBAction)nextMusic:(id)sender {
}

- (IBAction)stopMusic:(id)sender {
    if (isPlay) {
        isPlay=NO;
        [audioPlayer stop];
        [playBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
}


- (IBAction)processChange:(id)sender {
    //audioPlayer.duration all time
    audioPlayer.currentTime= processSlider.value*(audioPlayer.duration);
}
- (IBAction)voiceChange:(id)sender {
    audioPlayer.volume = voiceSlider.value;
}

- (IBAction)voiceOff:(id)sender {
    voiceSlider.value=0.0f;
    audioPlayer.volume = 0.0f;
}

- (IBAction)voiceOn:(id)sender {
    audioPlayer.volume+=0.2f;
    voiceSlider.value=audioPlayer.volume;
}

- (NSInteger)tableView:(UITableView *)_tableView numberOfRowsInSection:(NSInteger)section
{
    if (_tableView.tag==2) {
        return [musicArray count];
    }else
    {
        return [LrctimeArray count];
     }
}


- (UITableViewCell *)tableView:(UITableView *)_tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_tableView.tag==2)
    {
        static NSString *cellIndentifier=@"Cell";
        UITableViewCell *cell = [_tableView dequeueReusableCellWithIdentifier:cellIndentifier];
        if (cell==nil) {
            cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier];
        }
         MusicModel *music = [musicArray objectAtIndex:indexPath.row];
        cell.textLabel.text = music.name;
        cell.textLabel.textColor=[UIColor yellowColor];
        return cell;
    }else
    {
        static NSString *cellIndentifier=@"lrcCell";
        UITableViewCell *cell = [_tableView dequeueReusableCellWithIdentifier:cellIndentifier];
        if (cell==nil) {
            cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier];
        }
        cell.textLabel.text = [LrcDictionary objectForKey:[LrctimeArray objectAtIndex:indexPath.row]];
        cell.textLabel.textColor = [UIColor grayColor];
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
        return cell;
    }
}




















@end
