//
//  PlayViewController.h
//  BZY
//
//  Created by 周鑫 on 2018/9/4.
//  Copyright © 2018年 ZX. All rights reserved.
//

#import "BasicViewController.h"

@class AudioModel,DownLoadAudioModel;
@interface PlayViewController : BasicViewController


- (instancetype)initWithAudioModel:(AudioModel *)audioModel;
- (instancetype)initWithAudioDownLoadAudioModel:(DownLoadAudioModel *)downLoadAudioModel;


- (instancetype)initWithAudioModelarray:(NSArray <AudioModel *> *)audioModels currentIndex:(NSInteger)index;
- (instancetype)initWithAudioDownLoadAudioModelarray:(NSArray <DownLoadAudioModel *> *)downLoadAudioModels currentIndex:(NSInteger)index;
@end
