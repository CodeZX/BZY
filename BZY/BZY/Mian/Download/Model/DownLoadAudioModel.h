//
//  downLoadAudioModel.h
//  BZY
//
//  Created by 周鑫 on 2018/9/6.
//  Copyright © 2018年 ZX. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DownLoadAudioModel : NSObject
@property (nonatomic,strong) NSString *ID;
@property (nonatomic,strong) NSString *type_alias;
@property (nonatomic,strong) NSString *name;
@property (nonatomic,strong) NSString *author;
@property (nonatomic,strong) NSURL *url;
@property (nonatomic,strong) NSString *pic;
@end
