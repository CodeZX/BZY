//
//  MyInfoTableViewCell.m
//  BZY
//
//  Created by 周鑫 on 2018/9/14.
//  Copyright © 2018年 ZX. All rights reserved.
//

#import "MyInfoTableViewCell.h"
#import "MyInfoModel.h"



@interface MyInfoTableViewCell ()

@property (nonatomic,weak) UIImageView *pictureImageV;
@property (nonatomic,weak) UILabel *titleLab;
@end
@implementation MyInfoTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self  = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI  {
    
    __weak typeof(self) weakSelf = self;
    UIImageView *imageV = [[UIImageView alloc]init];
    [self.contentView addSubview:imageV];
    self.pictureImageV = imageV;
    [self.pictureImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.contentView).offset(15);
        make.centerY.equalTo(weakSelf.contentView);
        make.size.equalTo(CGSizeMake(30, 30 ));
        
    }];
    
    UILabel *titleLab = [[UILabel alloc]init];
    [self.contentView addSubview:titleLab];
    self.titleLab = titleLab;
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.pictureImageV.right).offset(10);
        make.centerY.equalTo(weakSelf.contentView);
    }];
   
   
}


- (void)setInfoModel:(MyInfoModel *)infoModel {
    _infoModel = infoModel;
    
    self.pictureImageV.image = [UIImage imageNamed:infoModel.pictureName];
    self.titleLab.text = infoModel.title;
    
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
