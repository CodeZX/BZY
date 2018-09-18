//
//  PlayViewController.h
//  BZY
//
//  Created by 周鑫 on 2018/9/4.
//  Copyright © 2018年 ZX. All rights reserved.
//

#import "BasicViewController.h"
#import "MusicItemModel.h"

@class AudioModel,DownLoadAudioModel;
@interface PlayViewController : BasicViewController


- (instancetype)initWithAudioModel:(AudioModel *)audioModel;
- (instancetype)initWithAudioDownLoadAudioModel:(DownLoadAudioModel *)downLoadAudioModel;


- (instancetype)initWithAudioModelarray:(NSArray <AudioModel *> *)audioModels currentIndex:(NSInteger)index;
- (instancetype)initWithAudioDownLoadAudioModelarray:(NSArray <DownLoadAudioModel *> *)downLoadAudioModels currentIndex:(NSInteger)index;

- (instancetype)initWithAudioSource:(NSArray <MusicItemModel *>*)itemModels;
- (instancetype)initWithAudioSource:(NSArray <MusicItemModel *>*)itemModels currentItemModelAtIndex:(NSInteger)index;

//- (instancetype)initWithAudioSource:(NSArray <MusicItemModel *> *)itemModels;

//- (void)addAudioSource:(NSArray <MusicItemModel *> *)itemModels;
@end
