//
//  MusicHeaderViewCell.m
//  BZY
//
//  Created by 周鑫 on 2018/9/14.
//  Copyright © 2018年 ZX. All rights reserved.
//

#import "MusicHeaderViewCell.h"
#import "MusicHeaderViewItemModel.h"


@interface MusicHeaderViewCell ()

@property (nonatomic,weak) UIImageView *imageV;
@property (nonatomic,weak) UILabel *titleLab;

@end
@implementation MusicHeaderViewCell
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame
            ];
    if (self) {
        [self setupUI];
    }
    return self;
}


- (void)setupUI {

    __weak typeof(self) weakSelf = self;
    UIImageView *imageV = [[UIImageView alloc]init];
//    imageV.backgroundColor = [UIColor redColor];
    [self.contentView addSubview:imageV];
    self.imageV = imageV;
    [self.imageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.contentView);
        make.centerX.equalTo(weakSelf.contentView);
//        make.bottom.equalTo(weakSelf).offset(-30);
        make.height.equalTo(44);
        make.width.equalTo(44);
    }];
    
    
    UILabel *titleLab = [[UILabel alloc]init];
    titleLab.text = @"音乐";
    titleLab.textAlignment = NSTextAlignmentCenter;
//    titleLab.backgroundColor = [UIColor redColor];
    [self.contentView addSubview:titleLab];
    self.titleLab = titleLab;
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(weakSelf.contentView);
//        make.top.equalTo(weakSelf.imageV.bottom).offset(5);
        make.height.equalTo(20);
    }];
    
    
}


- (void)setItemModel:(MusicHeaderViewItemModel *)itemModel {
    _itemModel = itemModel;
    self.imageV.image = [UIImage imageNamed:itemModel.pictureName];
    self.titleLab.text = itemModel.title;
}
@end
