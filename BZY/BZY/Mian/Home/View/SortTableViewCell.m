//
//  SortTableViewCell.m
//  BZY
//
//  Created by 周鑫 on 2018/9/5.
//  Copyright © 2018年 ZX. All rights reserved.
//

#import "SortTableViewCell.h"
#import "AudioModel.h"
#import "DownLoadAudioModel.h"
#import "MusicItemModel.h"

@interface SortTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLable;
@property (weak, nonatomic) IBOutlet UILabel *authorLabel;

@end

@implementation SortTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setAudioModel:(AudioModel *)audioModel {
    
    _audioModel = audioModel;
    self.titleLable.text = audioModel.name;
    self.authorLabel.text = audioModel.author;
}

- (void)setItemModel:(MusicItemModel *)itemModel {
    
    _itemModel = itemModel;
    self.titleLable.text = itemModel.name;
    self.authorLabel.text = itemModel.author;
}

- (void)setDownLoadAudioModel:(DownLoadAudioModel *)downLoadAudioModel {
    _downLoadAudioModel = downLoadAudioModel;
    self.titleLable.text = downLoadAudioModel.name;
    self.authorLabel.text = downLoadAudioModel.author;
}
- (IBAction)collectBtn:(id)sender {
    
    UIButton *btn = (UIButton *)sender;
    btn.selected = !btn.selected;
}

- (IBAction)playBtn:(id)sender {
    
    
}


@end
