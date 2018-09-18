//
//  MusicItemCell.m
//  BZY
//
//  Created by 周鑫 on 2018/9/14.
//  Copyright © 2018年 ZX. All rights reserved.
//

#import "MusicItemCell.h"
#import "MusicItemModel.h"



@interface MusicItemCell ()

@property (nonatomic,weak) UIImageView *imageV;
@property (nonatomic,weak) UILabel *titleLab;
@property (nonatomic,weak) UILabel *subheadLab;
@property (nonatomic,weak) UIButton *auditionBtn;
@property (nonatomic,weak) UIButton *downloadBtn;
@end
@implementation MusicItemCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI  {
    
    __weak typeof(self) weakSelf = self;
    UIImageView *imageV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"音频-3"]];
    imageV.backgroundColor = [UIColor jk_colorWithHex:0xE1E1E1];
    imageV.layer.cornerRadius = 16;
    imageV.layer.masksToBounds = YES;
    [self.contentView addSubview:imageV];
    self.imageV = imageV;
    [self.imageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.contentView).offset(15);
        make.centerY.equalTo(weakSelf.contentView);
        make.size.equalTo(CGSizeMake(32, 32));
    }];
    
    UILabel *titleLab = [[UILabel alloc]init];
    titleLab.text = @"标题";
    titleLab.textColor = [UIColor jk_colorWithHex:0x272727];
    titleLab.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
//    titleLab.backgroundColor = [UIColor redColor];
    [self.contentView addSubview:titleLab];
    self.titleLab = titleLab;
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.imageV.right).offset(20);
        make.bottom.equalTo(weakSelf.contentView.centerY).offset(-0);
        make.right.equalTo(weakSelf.right).offset(-100);
    }];
    
    
    UILabel *subheadLab = [[UILabel alloc]init];
    subheadLab.text = @"副标题";
    subheadLab.textColor = [UIColor jk_colorWithHex:0x272727];
    subheadLab.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
//    subheadLab.backgroundColor = [UIColor redColor];
    [self.contentView addSubview:subheadLab];
    self.subheadLab = subheadLab;
    [self.subheadLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.imageV.right).offset(20);
        make.top.equalTo(weakSelf.contentView.centerY).offset(5);
        make.right.equalTo(weakSelf.right).offset(-100);
    }];
    
    
    
    UIButton *auditionBtn = [[UIButton alloc]init];
//    auditionBtn.backgroundColor = [UIColor redColor];
//    [auditionBtn setTitle:@"试听" forState:UIControlStateNormal];
    [auditionBtn setImage:[UIImage imageNamed:@"试听中"] forState:UIControlStateNormal];
    [auditionBtn addTarget:self action:@selector(auditionBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:auditionBtn];
    self.auditionBtn = auditionBtn;
    [self.auditionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf.contentView);
        make.right.equalTo(weakSelf.contentView).offset(-50);
        make.size.equalTo(CGSizeMake(20, 20));
    }];
    
    
    UIButton *downloadBtn = [[UIButton alloc]init];
//    downloadBtn.backgroundColor = [UIColor redColor];
    [downloadBtn setImage:[UIImage imageNamed:@"下载-2"] forState:UIControlStateNormal];
    [downloadBtn addTarget:self action:@selector(downloadBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
//    [downloadBtn setTitle:@"试听" forState:UIControlStateNormal];
    [self.contentView addSubview:downloadBtn];
    self.downloadBtn = downloadBtn;
    [self.downloadBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf.contentView);
        make.right.equalTo(weakSelf.contentView).offset(-20);
        make.size.equalTo(CGSizeMake(20, 20));
    }];
    
    
}

- (void)auditionBtnClicked:(UIButton *)btn {
    
    if ([self.delegate respondsToSelector:@selector(musicItemCell:didAudition:)]) {
        [self.delegate musicItemCell:self didAudition:self.itemModel];
    }
    
}

- (void)downloadBtnClicked:(UIButton *)btn {
    
    if ([self.delegate respondsToSelector:@selector(musicItemCell:didDownload:)]) {
        [self.delegate musicItemCell:self didDownload:self.itemModel];
    }
}


- (void)setItemModel:(MusicItemModel *)itemModel {
    
    _itemModel = itemModel;
    
    self.titleLab.text = itemModel.name;
    self.subheadLab.text = itemModel.author;
    [self.imageV sd_setImageWithURL:[NSURL URLWithString:itemModel.pic]];
    
    
    
    
    
    
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
