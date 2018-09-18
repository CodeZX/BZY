//
//  PlayViewController.m
//  BZY
//
//  Created by 周鑫 on 2018/9/4.
//  Copyright © 2018年 ZX. All rights reserved.
//

#import "PlayViewController.h"
#import "AudioModel.h"
#import "BZYPlayManager.h"
#import "LocalAudio+CoreDataClass.h"
#import "downLoadAudioModel.h"
@interface PlayViewController ()<DFPlayerDataSource,DFPlayerDelegate>
@property (nonatomic,strong) AudioModel *audioModel;
@property (nonatomic,strong) DownLoadAudioModel *downLoadAudioModel;
@property (nonatomic,strong) NSMutableArray *dataSource;
@property (nonatomic,strong) AVAudioPlayer *audioPlayer;
@property (nonatomic,strong) AVPlayer *player;
@property (nonatomic,strong) BZYPlayManager *playManager;

@property (nonatomic,strong) UIButton *closeBtn;

@property (nonatomic,weak) UILabel *audioNameLab;
@property (nonatomic,weak) UILabel *authorLab;

@property (nonatomic,weak) UIImageView *picture;
@property (nonatomic,weak) UIButton *playPauseBtn;
@property (nonatomic,weak) UIButton *lastBtn;
@property (nonatomic,weak) UIButton *nextBtn;
@property (nonatomic,weak) UISlider *slider;
@property (nonatomic,weak) UILabel *currentTimeLabel;
@property (nonatomic,weak) UILabel *totalTimeLabel;

@property (nonatomic,weak) UIButton *downloadBtn;
@property (nonatomic,weak) UIButton *sharesBtn;
@property (nonatomic,weak) UIButton *collectBtn;


@property (nonatomic,assign) BOOL isSwitch;
@property (nonatomic,assign) NSInteger currentIndex;
@property (nonatomic,strong) NSArray *audioModels;
@property (nonatomic,strong) NSArray *downLoadAudioModels;
@end

@implementation PlayViewController




- (instancetype)initWithAudioSource:(NSArray<MusicItemModel *> *)itemModels currentItemModelAtIndex:(NSInteger)index {
    
    self = [super init];
    if (self) {
        if (itemModels) {
            [[BZYPlayManager sharedInstance] addAudioSource:itemModels];
            [[BZYPlayManager sharedInstance] playWithIndex:index];
        }
        
        self.playManager = [BZYPlayManager sharedInstance];
    }
    return self;
}


- (instancetype)initWithAudioSource:(NSArray<MusicItemModel *> *)itemModels {
    self = [super init];
    if (self) {
        if (itemModels) {
            [[BZYPlayManager sharedInstance] addAudioSource:itemModels];
        }

        self.playManager = [BZYPlayManager sharedInstance];
    }
    return self;
}




- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self initializePlay];
}

- (void)initializePlay {
    
    __weak typeof(self) weakSelf = self;

    [self.playManager.player addPeriodicTimeObserverForInterval:CMTimeMake(1, 60) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
        weakSelf.currentTimeLabel.text = [weakSelf timeIntervalToMMSSFormat: CMTimeGetSeconds([weakSelf.playManager.player.currentItem currentTime])];
        weakSelf.totalTimeLabel.text = [weakSelf timeIntervalToMMSSFormat: CMTimeGetSeconds([weakSelf.playManager.player.currentItem duration])];
        CGFloat seconds  = CMTimeGetSeconds([weakSelf.playManager.player.currentItem currentTime])/CMTimeGetSeconds([weakSelf.playManager.player.currentItem duration]);
        //        NSLog(@"%f",seconds);
        [weakSelf.slider setValue:seconds *100 animated:YES];
    }];
   
    
    
}

- (void)sharesBtnClicked:(UIButton *)btn {
    
    NSString *textToShare = @"Come listen to music with me!！";
    NSURL *urlToShare = [NSURL URLWithString:self.audioModel.url];
    UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.audioModel.pic]]];
    NSArray *activityItems = @[textToShare, urlToShare,image];
    UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
    //    activityVC.excludedActivityTypes = @[UIActivityTypePostToFacebook,UIActivityTypePostToTwitter, UIActivityTypePostToWeibo,UIActivityTypeMessage,UIActivityTypeMail,UIActivityTypePostToTencentWeibo,UIActivityTypeAirDrop,UIActivityTypeOpenInIBooks];
    activityVC.completionWithItemsHandler = ^(NSString *activityType,BOOL completed,NSArray *returnedItems,NSError *activityError)
    {
        NSLog(@"%@", activityType);
        
        if (completed) { // 确定分享
            NSLog(@"分享成功");
        }
        else {
            NSLog(@"分享失败");
        }
    };
    
    [self presentViewController:activityVC animated:YES completion:nil];
}

- (void)collectBtnClicked:(UIButton *)btn {
    
//    btn.selected = !btn.selected;
    [MBProgressHUD showMessage:@"加载中..."];
    
    NSDictionary *dic = @{@"id":self.playManager.currentItemModel.ID};
    [[AFHTTPSessionManager manager] POST:@"http://45.63.35.70:8080/tj_audio/join_collect" parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [MBProgressHUD hideHUD];
        if ([responseObject[@"code"] isEqualToString:@"200"]) {
            btn.enabled = NO;
            btn.selected = YES;
            [MBProgressHUD showSuccess:@"收藏成功"];
//            self.items = [MusicItemModel mj_objectArrayWithKeyValuesArray:responseObject[@"retData"]];
//            [self.tableView reloadData];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    
    
    

}

- (void)downloadBtnClicked:(UIButton *)btn  {
    
    btn.enabled = NO;
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    // 1. 创建会话管理者
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    // 2. 创建下载路径和请求对象
    NSURL *URL = [NSURL URLWithString:self.audioModel.url];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    // 3.创建下载任务
    /**
     * 第一个参数 - request：请求对象
     * 第二个参数 - progress：下载进度block
     *      其中： downloadProgress.completedUnitCount：已经完成的大小
     *            downloadProgress.totalUnitCount：文件的总大小
     * 第三个参数 - destination：自动完成文件剪切操作
     *      其中： 返回值:该文件应该被剪切到哪里
     *            targetPath：临时路径 tmp NSURL
     *            response：响应头
     * 第四个参数 - completionHandler：下载完成回调
     *      其中： filePath：真实路径 == 第三个参数的返回值
     *            error:错误信息
     */
    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:^(NSProgress *downloadProgress) {
        
//        // 下载进度
//        self.progressView.progress = 1.0 * downloadProgress.completedUnitCount / downloadProgress.totalUnitCount;
//        self.progressLabel.text = [NSString stringWithFormat:@"当前下载进度:%.2f%%",100.0 * downloadProgress.completedUnitCount / downloadProgress.totalUnitCount];
//        NSLog(@"下载%f",1.0 * downloadProgress.completedUnitCount / downloadProgress.totalUnitCount);
        
    } destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
        
        NSArray *cacPath = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
        NSString *cachePath = [cacPath objectAtIndex:0];
        NSURL *url = [NSURL fileURLWithPath:cachePath];
        
//        NSURL *path = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
        NSDate *date = [NSDate date];
        return [url URLByAppendingPathComponent:[NSString stringWithFormat:@"%.0f.mp3",date.timeIntervalSince1970]];
        
        
    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
//        NSLog(@"File downloaded to: %@", filePath);
        self.downloadBtn.enabled = YES;
        [self saveToDataBaseByFilePath:filePath];
        [MBProgressHUD showSuccess:@"Download completed"];
    }];
    
    // 4. 开启下载任务
    [downloadTask resume];
    
   
}

- (void)saveToDataBaseByFilePath:(NSURL *)filePath {
    
    // 创建上下文对象，并发队列设置为主队列
    NSManagedObjectContext *context = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    // 创建托管对象模型，并使用Company.momd路径当做初始化参数
    NSURL *modelPath = [[NSBundle mainBundle] URLForResource:@"Model" withExtension:@"momd"];
    NSManagedObjectModel *model = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelPath];
    // 创建持久化存储调度器
    NSPersistentStoreCoordinator *coordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:model];
    // 创建并关联SQLite数据库文件，如果已经存在则不会重复创建
    NSString *dataPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject;
    dataPath = [dataPath stringByAppendingFormat:@"/%@.sqlite", @"AudioModel"];
    [coordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:[NSURL fileURLWithPath:dataPath] options:nil error:nil];
    // 上下文对象设置属性为持久化存储器
    context.persistentStoreCoordinator = coordinator;
    
    
    // 创建托管对象，并指明创建的托管对象所属实体名
    LocalAudio *emp = [NSEntityDescription insertNewObjectForEntityForName:@"LocalAudio" inManagedObjectContext:context];
    emp.name = self.audioModel.name;
    emp.url = filePath;
    emp.pic = self.audioModel.pic;
    emp.author = self.audioModel.author;
    // 通过上下文保存对象，并在保存前判断是否有更改
    NSError *error = nil;
    if (context.hasChanges) {
        [context save:&error];
    }
    // 错误处理
    if (error) {
        NSLog(@"CoreData Insert Data Error : %@", error);
    }
    
}

- (void)playPauseBtn:(UIButton *)btn  {
    
    btn.selected = !btn.selected;
    if (btn.selected) {
         [self.playManager.player pause];
    }else {
        [self.playManager.player play];
    }
   
//    if ([self.playManager isPlay]) {
//        [self.playManager pause];
//    }else {
//        [self initializePlay];
////        [self.playManager playWithURL:[NSURL URLWithString:self.audioModel.url]];
//    }
}
- (NSString *)timeIntervalToMMSSFormat:(NSTimeInterval)interval {
    NSInteger ti = (NSInteger)interval;
    NSInteger seconds = ti % 60;
    NSInteger minutes = (ti / 60) % 60;
    return [NSString stringWithFormat:@"%02ld:%02ld", (long)minutes, (long)seconds];
}

- (void)closeBtnClicked:(UIButton *)btn {
    
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}
- (void)setupUI {
    
    
    NSLog(@"屏幕尺寸%f,%f",self.view.frame.size.width,self.view.frame.size.height);
    self.title = self.audioModel.name;
    self.view.backgroundColor = [[UIColor alloc]initWithPatternImage:[UIImage imageNamed:@"毛玻璃背景"]];
    
    __weak typeof(self) weakSelf = self;
    
    
    UIButton *closeBtn = [[UIButton alloc]init];
    [closeBtn setImage:[UIImage imageNamed:@"收起"] forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(closeBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:closeBtn];
    self.closeBtn = closeBtn;
    [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.view).offset(30);
        make.top.equalTo(weakSelf.view).offset(iPhoneX?44:24);
        make.size.equalTo(CGSizeMake(20, 20));
    }];
    
    
    
    UILabel *audioNameLab = [[UILabel alloc]init];
    audioNameLab.text = self.playManager.currentItemModel.name;
    audioNameLab.textAlignment = NSTextAlignmentCenter;
    audioNameLab.textColor = [UIColor whiteColor];
    audioNameLab.font = [UIFont systemFontOfSize:13];
    [self.view addSubview:audioNameLab];
    self.audioNameLab = audioNameLab;
    [self.audioNameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.view).offset(100);
        make.left.equalTo(weakSelf.view).offset(100);
        make.right.equalTo(weakSelf.view).offset(-100);
        
    }];
    
    
    UILabel *authorLab = [[UILabel alloc]init];
    authorLab.text = self.playManager.currentItemModel.author;
    authorLab.textAlignment = NSTextAlignmentCenter;
    authorLab.textColor = [UIColor whiteColor];
    authorLab.font = [UIFont systemFontOfSize:12];
    [self.view addSubview:authorLab];
    self.authorLab = authorLab;
    [self.authorLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.view).offset(130);
        make.left.equalTo(weakSelf.view).offset(100);
        make.right.equalTo(weakSelf.view).offset(-100);
        
    }];
     
    
    
    
    
    UIImageView *picture = [[UIImageView alloc]init];
    if (self.audioModel) {
        [picture sd_setImageWithURL:[NSURL URLWithString:self.audioModel.pic] placeholderImage:[UIImage imageNamed:@"1"]];
    } else {
        [picture sd_setImageWithURL:[NSURL URLWithString:self.downLoadAudioModel.pic] placeholderImage:[UIImage imageNamed:@"1"]];
    }
    
    picture.backgroundColor =[UIColor whiteColor];
    picture.layer.cornerRadius = 100;
    picture.layer.masksToBounds = YES;
    [self.view addSubview:picture];
    self.picture = picture;
    [self.picture mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.view);
        make.bottom.equalTo(weakSelf.view.centerY);
        make.size.equalTo(CGSizeMake(200, 200));
    }];
    
    
    UIButton *downloadBtn = [[UIButton alloc]init];
    //    downloadBtn.backgroundColor = [UIColor redColor];
    [downloadBtn setImage:[UIImage imageNamed:@"下载"] forState:UIControlStateNormal];
    [downloadBtn addTarget:self action:@selector(downloadBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    //    [downloadBtn setImage:[UIImage imageNamed:@"prev_song"] forState:UIControlStateNormal];
    [self.view addSubview:downloadBtn];
    self.downloadBtn = downloadBtn;
    [self.downloadBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.view).offset(-40);
        make.bottom.equalTo(weakSelf.view).offset(-150);
        make.size.equalTo(CGSizeMake(32, 32));
    }];
    
    UIButton *sharesBtn = [[UIButton alloc]init];
    //    sharesBtn.backgroundColor = [UIColor redColor];
    [sharesBtn setImage:[UIImage imageNamed:@"分享"] forState:UIControlStateNormal];
    [sharesBtn addTarget:self action:@selector(sharesBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    //    [downloadBtn setImage:[UIImage imageNamed:@"prev_song"] forState:UIControlStateNormal];
    [self.view addSubview:sharesBtn];
    self.sharesBtn = sharesBtn;
    [self.sharesBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.view);
        make.bottom.equalTo(weakSelf.view).offset(-150);
        make.size.equalTo(CGSizeMake(30, 30));
    }];
    
    UIButton *collectBtn = [[UIButton alloc]init];
    [collectBtn setImage:[UIImage imageNamed:@"empty_heart"] forState:UIControlStateNormal];
    //    collectBtn.backgroundColor = [UIColor redColor];
    [collectBtn addTarget:self action:@selector(collectBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    //    [downloadBtn setImage:[UIImage imageNamed:@"prev_song"] forState:UIControlStateNormal];
    [self.view addSubview:collectBtn];
    self.collectBtn = collectBtn;
    [self.collectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.view).offset(40);
        make.bottom.equalTo(weakSelf.view).offset(-150);
        make.size.equalTo(CGSizeMake(30, 30));
    }];
    
    
    
    CGFloat sliderX = 60;
    CGFloat sliderY = SCREEN_HEIGHT - 110;
    CGFloat sliderW = SCREEN_WIDTH - 120;
    CGFloat sliderH = 0;
    UISlider *slider = [[UISlider alloc]initWithFrame:CGRectMake(sliderX, sliderY, sliderW, sliderH)];
    [slider setMinimumTrackTintColor:[UIColor whiteColor]];
    [slider setThumbImage:[UIImage imageNamed:@"music_slider_circle"] forState:UIControlStateNormal];
    slider.minimumValue = 0;
    slider.maximumValue = 100;
    // 设置UISlider的初始值
    slider.value = 0;
    [self.view addSubview:slider];
    self.slider = slider;
    
    
    
    UILabel *currentTimeLabel = [[UILabel alloc]init];
    //    currentTimeLabel.backgroundColor = [UIColor redColor];
    currentTimeLabel.textColor = [UIColor whiteColor];
    currentTimeLabel.text = @"00:00";
    [self.view addSubview:currentTimeLabel];
    self.currentTimeLabel = currentTimeLabel;
    [self.currentTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.view).offset(10);
        make.bottom.equalTo(weakSelf.view).offset(-100);
        
    }];
    
    
    UILabel *totalTimeLabel = [[UILabel alloc]init];
    //    totalTimeLabel.backgroundColor =[UIColor redColor];
    totalTimeLabel.textColor = [UIColor whiteColor];
    totalTimeLabel.text = @"00:00";
    [self.view addSubview:totalTimeLabel];
    self.totalTimeLabel = totalTimeLabel;
    [self.totalTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.view).offset(-10);
        make.top.equalTo(weakSelf.currentTimeLabel);
        
    }];
    
    
    
    
    if ([BZYPlayManager sharedInstance].player.currentItem) {
        
        UIButton *playPauseBtn = [[UIButton alloc]init];
        //    playPauseBtn.backgroundColor = [UIColor redColor];
        [playPauseBtn setImage:[UIImage imageNamed:@"big_pause_button"] forState:UIControlStateNormal];
        [playPauseBtn setImage:[UIImage imageNamed:@"big_play_button"] forState:UIControlStateSelected];
        [playPauseBtn addTarget:self action:@selector(playPauseBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:playPauseBtn];
        self.playPauseBtn = playPauseBtn;
        [self.playPauseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(weakSelf.view).offset(-39);
            make.centerX.equalTo(weakSelf.view);
            make.size.equalTo(CGSizeMake(60, 60));
        }];
    }
   
    
    if (self.playManager.musicItemModelArray.count > 1) {
        
        UIButton *lastBtn = [[UIButton alloc]init];
        //    lastBtn.backgroundColor = [UIColor redColor];
        [lastBtn setImage:[UIImage imageNamed:@"prev_song"] forState:UIControlStateNormal];
        [lastBtn addTarget:self action:@selector(lastBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:lastBtn];
        self.lastBtn = lastBtn;
        [self.lastBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(weakSelf.playPauseBtn.left).offset(-20);
            make.top.equalTo(weakSelf.playPauseBtn);
            make.size.equalTo(CGSizeMake(60, 60));
        }];
        
        
        UIButton *nextBtn = [[UIButton alloc]init];
        //    nextBtn.backgroundColor = [UIColor redColor];
        [nextBtn setImage:[UIImage imageNamed:@"next_song"] forState:UIControlStateNormal];
        [nextBtn addTarget:self action:@selector(nextBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:nextBtn];
        self.nextBtn = nextBtn;
        [self.nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.playPauseBtn.right).offset(20);
            make.top.equalTo(weakSelf.playPauseBtn);
            make.size.equalTo(CGSizeMake(60, 60));
        }];
    }
   
    
}

- (void)lastBtn:(UIButton *)btn {
    
    [self.playManager lastAudio];
    [self initializePlay];
   

}

- (void)nextBtn:(UIButton *)btn {
    
    [self.playManager nextAudio];
    [self initializePlay];
   
}




- (NSArray<DFPlayerModel *> *)df_playerModelArray {
    return self.dataSource;
}




@end
