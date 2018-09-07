//
//  BZYPlayManager.h
//  BZY
//
//  Created by 周鑫 on 2018/9/5.
//  Copyright © 2018年 ZX. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BZYPlayManager : NSObject
@property (nonatomic, strong) AVPlayer *player;
@property (nonatomic) BOOL isPlay;
+ (instancetype)sharedInstance;
- (void)playWithURL:(NSURL *)url;
- (void)pause;
@end
