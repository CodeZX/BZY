//
//  BZYPlayManager.h
//  BZY
//
//  Created by 周鑫 on 2018/9/5.
//  Copyright © 2018年 ZX. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MusicItemModel,BZYPlayManager;

@protocol  BZYPlayManagerDelegate <NSObject>
@optional
- (void)playManager:(BZYPlayManager *)playManager didReadyToPlay:(AVPlayer *)player musicItemModel:(MusicItemModel *)itemModel;
@required
@end
@interface BZYPlayManager : NSObject
@property (nonatomic, strong) AVPlayer *player;
@property (nonatomic) BOOL isPlay;
@property (nonatomic,strong) MusicItemModel *currentItemModel;
@property (nonatomic,strong) NSArray *musicItemModelArray;
@property (nonatomic,weak) id<BZYPlayManagerDelegate> delegate;
+ (instancetype)sharedInstance;
- (void)addAudioSource:(NSArray <MusicItemModel *>*)musicItemModelArray;
- (void)playWithIndex:(NSInteger )index;
- (void)playWithURL:(NSURL *)url;
- (void)nextAudio;
- (void)lastAudio;
- (void)pause;
@end
