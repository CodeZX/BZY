//
//  MusicItemCell.h
//  BZY
//
//  Created by 周鑫 on 2018/9/14.
//  Copyright © 2018年 ZX. All rights reserved.
//

#import <UIKit/UIKit.h>


@class MusicItemModel,MusicItemCell;
@protocol  MusicItemCellDelegate <NSObject>
@optional
- (void)musicItemCell:(MusicItemCell *)musicItemCell didAudition:(MusicItemModel *)itemModel;
- (void)musicItemCell:(MusicItemCell *)musicItemCell didDownload:(MusicItemModel *)itemModel;
@required
@end


@interface MusicItemCell : UITableViewCell
@property (nonatomic,strong) MusicItemModel *itemModel;
@property (nonatomic,weak) id<MusicItemCellDelegate> delegate;
@end
