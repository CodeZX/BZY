//
//  AudioModel.h
//  BZY
//
//  Created by 周鑫 on 2018/9/4.
//  Copyright © 2018年 ZX. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AudioModel : NSObject
@property (nonatomic,strong) NSString *ID;
@property (nonatomic,strong) NSString *type_alias;
@property (nonatomic,strong) NSString *name;
@property (nonatomic,strong) NSString *author;
@property (nonatomic,strong) NSString *url;
@property (nonatomic,strong) NSString *pic;
@end


//"id": "407248",
//"type_alias": "dzr",
//"name": "anohi",             //音频名称
//"author": "Daisuke Miyatani",   //作者
//"url": "http://music.163.com/song/media/outer/url?id=407248.mp3",
//"pic": "http://local host:8080/tj_audio/file/dzr.jpg"  //图片
