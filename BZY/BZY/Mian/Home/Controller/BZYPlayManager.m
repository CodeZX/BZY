//
//  BZYPlayManager.m
//  BZY
//
//  Created by 周鑫 on 2018/9/5.
//  Copyright © 2018年 ZX. All rights reserved.
//

#import "BZYPlayManager.h"
#import "MusicItemModel.h"


@interface BZYPlayManager ()

@property (nonatomic,assign) NSInteger currentIndex;

@end

static BZYPlayManager *_instance = nil;
@implementation BZYPlayManager

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [super allocWithZone:zone];
        
    });
    
    return _instance;
}

+ (instancetype)sharedInstance {
    return [[self alloc]init];
}

- (id)copy {
    return _instance;
}


- (void)addAudioSource:(NSArray<MusicItemModel *> *)musicItemModelArray {
    
    self.musicItemModelArray = musicItemModelArray;
//    if (musicItemModelArray.count == 1) {
//        [self playWithIndex:0];
//    }
    
    
}

- (void)playWithIndex:(NSInteger)index {
    
    self.currentItemModel = self.musicItemModelArray[index];
    
    [self playWithURL:[NSURL URLWithString:self.currentItemModel.url]];
}

- (void)playWithURL:(NSURL *)url {
    
    self.player = [AVPlayer playerWithURL:url];
    [self.player play];
    self.isPlay = YES;
}

- (void)nextAudio {
    
    if (self.musicItemModelArray.count > 1) {
        if (++self.currentIndex <= self.musicItemModelArray.count) {
            self.currentItemModel = self.musicItemModelArray[self.currentIndex];
            [self playWithURL:[NSURL URLWithString:self.currentItemModel.url]];
        }
    }
    
    

}

- (void)lastAudio {
    
    if (self.musicItemModelArray.count > 1) {
        if (--self.currentIndex <= 0) {
            self.currentItemModel = self.musicItemModelArray[self.currentIndex];
            [self playWithURL:[NSURL URLWithString:self.currentItemModel.url]];
        }
    }
    
}

- (void)pause {
    
    [self.player pause];
    self.isPlay = NO;
}
@end
