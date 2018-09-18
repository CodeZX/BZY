//
//  MusicHeaderView.m
//  BZY
//
//  Created by 周鑫 on 2018/9/14.
//  Copyright © 2018年 ZX. All rights reserved.
//

#import "MusicHeaderView.h"
#import "MusicHeaderViewCell.h"
#import "MusicHeaderViewItemModel.h"


@interface MusicHeaderView ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic,weak) UICollectionView *collectionView;
@property (nonatomic,strong) NSArray *dataSource;
@end

static NSString *identifier = @"collectionView";
@implementation MusicHeaderView
{
    
    NSInteger _page;
}


- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    
    self.backgroundColor = [UIColor whiteColor];
    _page = 1;
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.itemSize = CGSizeMake(80, 80);
//    layout.minimumLineSpacing = 0;
    UICollectionView *collecttionView = [[UICollectionView alloc]initWithFrame:self.bounds collectionViewLayout:layout];
    collecttionView.backgroundColor = [UIColor whiteColor];
    collecttionView.delegate = self;
    collecttionView.dataSource = self;
    collecttionView.contentInset = UIEdgeInsetsMake(20, 15, 0, 15);
    [self addSubview:collecttionView];
    self.collectionView = collecttionView;
//    self.collectionView.mj_header = [MJRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
//    [self.collectionView.mj_header beginRefreshing];
    [self.collectionView registerClass:[MusicHeaderViewCell class] forCellWithReuseIdentifier:identifier];
    
}


#pragma mark -------------------------- Delegate ----------------------------------------
#pragma mark UICollectionViewDelegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.dataSource.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    MusicHeaderViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier: identifier forIndexPath:indexPath];
//    cell.sortModel = self.dataSource[indexPath.row];
    cell.itemModel = self.dataSource[indexPath.row];
    return  cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
  
    if ([self.delegate respondsToSelector:@selector(musicHeaderView:didSelectedAlias:)]) {
        MusicHeaderViewItemModel *itemModel = self.dataSource[indexPath.row];
        [self.delegate musicHeaderView:self didSelectedAlias:itemModel.type_alias];
        
    }
}


#pragma mark -------------------------- lazy load ----------------------------------------
- (NSArray *)dataSource {
    if (!_dataSource) {
        _dataSource = @[
                        [[MusicHeaderViewItemModel alloc]initWithTitle:@"nature" alias:@"dzr" pictureName:@"daziran"], //大自然
                        [[MusicHeaderViewItemModel alloc]initWithTitle:@"hypnosis" alias:@"cm" pictureName:@"cuimian"],//催眠
                        [[MusicHeaderViewItemModel alloc]initWithTitle:@"Efficient Learning" alias:@"gxxx" pictureName:@"xuexi"], //高效学习
                        [[MusicHeaderViewItemModel alloc]initWithTitle:@"Relax at home" alias:@"jjfs" pictureName:@"fangsong"], //居家放松
                        [[MusicHeaderViewItemModel alloc]initWithTitle:@"autocriticism" alias:@"zwfx" pictureName:@"fanxing"],  //自我反省
                        [[MusicHeaderViewItemModel alloc]initWithTitle:@"Pot headset" alias:@"zwfx" pictureName:@"baoerji"],  //煲耳机
                        
                        ];
        
    }
    return _dataSource;
}

@end
