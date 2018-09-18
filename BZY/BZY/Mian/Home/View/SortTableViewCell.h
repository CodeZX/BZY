//
//  SortTableViewCell.h
//  BZY
//
//  Created by 周鑫 on 2018/9/5.
//  Copyright © 2018年 ZX. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AudioModel,DownLoadAudioModel,MusicItemModel;
@interface SortTableViewCell : UITableViewCell

@property (nonatomic,strong) AudioModel *audioModel;
@property (nonatomic,strong) DownLoadAudioModel *downLoadAudioModel;
@property (nonatomic,strong) MusicItemModel *itemModel;
@end
