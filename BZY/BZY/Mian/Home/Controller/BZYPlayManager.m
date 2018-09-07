//
//  BZYPlayManager.m
//  BZY
//
//  Created by 周鑫 on 2018/9/5.
//  Copyright © 2018年 ZX. All rights reserved.
//

#import "BZYPlayManager.h"


@interface BZYPlayManager ()



@end

static BZYPlayManager *_instance = nil;
@implementation BZYPlayManager


+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    
    return _instance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
//        self.player = [AVPlayer alloc]init
    }
    return self;
}

- (void)playWithURL:(NSURL *)url {
    
    self.player = [AVPlayer playerWithURL:url];
    [self.player play];
    self.isPlay = YES;
}

- (void)pause {
    
    [self.player pause];
    self.isPlay = NO;
}
@end
