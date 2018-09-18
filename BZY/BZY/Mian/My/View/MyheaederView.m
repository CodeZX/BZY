//
//  MyheaederView.m
//  BZY
//
//  Created by 周鑫 on 2018/9/14.
//  Copyright © 2018年 ZX. All rights reserved.
//

#import "MyheaederView.h"
#import "MyCollectViewController.h"
#import "PlayViewController.h"

@interface MyheaederView ()

@property (nonatomic,weak) UIImageView *portraitImaV;
@property (nonatomic,weak) UIButton *collectBtn;

@end
@implementation MyheaederView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    
    self.backgroundColor = [UIColor jk_colorWithHex:0x5d96e3];
    __weak typeof(self) weakSelf = self;
    
    
    UIImageView *portraitImaV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"音频"]];
//    portraitImaV.backgroundColor = [UIColor jk_colorWithHex:0xE1E1E1];
    portraitImaV.backgroundColor = [UIColor whiteColor];
    portraitImaV.layer.cornerRadius = 38;
    portraitImaV.layer.masksToBounds = YES;
    portraitImaV.userInteractionEnabled = YES;
    portraitImaV.layer.cornerRadius = 75/2.0;
    portraitImaV.layer.masksToBounds = YES;
    [self addSubview:portraitImaV];
    self.portraitImaV = portraitImaV;
    [self.portraitImaV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf);
        make.top.equalTo(weakSelf).offset(10);
        make.size.equalTo(CGSizeMake(76, 76));
    }];
    
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(portraitImaVTap:)];
    [portraitImaV addGestureRecognizer:tapGesture];
    
    
    UIButton *collectBtn = [[UIButton alloc]init];
    collectBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [collectBtn setTitle:@"My collect" forState:UIControlStateNormal];
    [collectBtn setImage:[UIImage imageNamed:@"收 藏-5"] forState:UIControlStateNormal];
    [collectBtn jk_setImagePosition:LXMImagePositionRight spacing:5];
//    [collectBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    [self addSubview:collectBtn];
    self.collectBtn = collectBtn;
    [collectBtn addTarget:self action:@selector(collectBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.collectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.portraitImaV.bottom).offset(10);
        make.centerX.equalTo(weakSelf.portraitImaV);
        
    }];
}

- (void)collectBtnClicked:(UIButton *)btn {
    
    if ([self.delegate respondsToSelector:@selector(heaederView:didTapCollect:)]) {
        [self.delegate heaederView:self didTapCollect:btn];
    }
    
    
    
}

- (void)portraitImaVTap:(UITapGestureRecognizer *)tap {
    
    if ([self.delegate respondsToSelector:@selector(heaederView:didTapPortraitImaV:)]) {
        [self.delegate heaederView:self didTapPortraitImaV:self.portraitImaV];
    }
    
}

@end
