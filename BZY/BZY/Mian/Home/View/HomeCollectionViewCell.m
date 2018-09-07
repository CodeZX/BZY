//
//  HomeCollectionViewCell.m
//  BZY
//
//  Created by 周鑫 on 2018/9/3.
//  Copyright © 2018年 ZX. All rights reserved.
//

#import "HomeCollectionViewCell.h"
#import "HomeSortModel.h"
@interface HomeCollectionViewCell ()
@property (nonatomic,weak) UIImageView *imageView;
@property (nonatomic,weak) UILabel *titleLabel;

@end

@implementation HomeCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}


- (void)setupUI {
    
    self.contentView.backgroundColor = [UIColor whiteColor];
    __weak typeof(self) weakSelf = self;
    UIImageView *imageView = [[UIImageView alloc]init];
    imageView.backgroundColor = [UIColor lightGrayColor];
    [self.contentView addSubview:imageView];
    self.imageView = imageView;
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(weakSelf.contentView);
        make.bottom.equalTo(weakSelf.contentView);
    }];
    
    UILabel *titleLabel = [[UILabel alloc]init];
    titleLabel.backgroundColor = RGBACOLOR(179, 179, 179, 0.5);
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.text = @"title";
    [self.contentView addSubview:titleLabel];
    self.titleLabel = titleLabel;
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.contentView);
        make.bottom.equalTo(weakSelf.contentView);
        make.left.equalTo(weakSelf.contentView);
        make.right.equalTo(weakSelf.contentView);
    }];
    
}
- (void)setSortModel:(HomeSortModel *)sortModel {
    
    _sortModel = sortModel;
    self.titleLabel.text = sortModel.title;
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:sortModel.pic]];
    
}
@end
