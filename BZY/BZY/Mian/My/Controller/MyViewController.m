//
//  MyViewController.m
//  BZY
//
//  Created by 周鑫 on 2018/9/3.
//  Copyright © 2018年 ZX. All rights reserved.
//

#import "MyViewController.h"
#import "MyInfoModel.h"
#import "MyDownloadViewController.h"
#import "MyheaederView.h"
#import "MyInfoTableViewCell.h"
#import "MyCollectViewController.h"
#import "PlayViewController.h"

#import "AboutViewController.h"
@interface MyViewController ()<UITableViewDelegate,UITableViewDataSource,MyheaederViewDelegate>

@property (nonatomic,weak) UITableView *tableView;
@property (nonatomic,strong) NSArray *dataSource;
@end

static NSString *identifier = @"collectionView";
@implementation MyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}

- (void)setupUI {
    
    self.title = @"me";
    self.view.backgroundColor = [UIColor redColor];
    
    UITableView *tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
//    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view addSubview:tableView];
    self.tableView = tableView;
//    self.tableView.mj_header =  [MJRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
//    [self.tableView.mj_header beginRefreshing];
    self.tableView = tableView;
    MyheaederView *headerView = [[MyheaederView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 200)];
    self.tableView.tableHeaderView = headerView;
    headerView.delegate = self;
    
    
    
}

- (void)loadNewData {
    
    [self.tableView.mj_header endRefreshing];
    
   
    
}
#pragma mark -------------------------- Deletate ----------------------------------------
#pragma mark UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return  self.dataSource.count;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [[UIView alloc]init];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identifier = @"UITableViewCell";
    MyInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[MyInfoTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    MyInfoModel *infoModel = self.dataSource[indexPath.row];
    cell.infoModel = infoModel;

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
     MyInfoModel *infoModel = self.dataSource[indexPath.row];
    infoModel.block();

}

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//
//    return 60;
//}

#pragma mark MyheaederViewDelegate

- (void)heaederView:(MyheaederView *)headerView didTapPortraitImaV:(UIImageView *)PortraitImaV {
    
//    PlayViewController *playVC = [[PlayViewController alloc]init];
//    [self presentViewController:playVC animated:YES completion:^{
//
//    }];
    
    PlayViewController *playVC = [[PlayViewController alloc]initWithAudioSource:nil currentItemModelAtIndex:0];
    [self presentViewController:playVC animated:YES completion:nil];
}


- (void)heaederView:(MyheaederView *)headerView didTapCollect:(UIButton *)collectBtn {
    
    MyCollectViewController *VC = [[MyCollectViewController alloc]init];
    [self.navigationController pushViewController:VC animated:YES];
}

#pragma mark -------------------------- lazy laod ----------------------------------------
- (NSArray *)dataSource {
    if (!_dataSource) {
        
        _dataSource = @[
                       
                        [[MyInfoModel alloc]initWithTitle:@"Clean up the cache" pictureName:@"清理缓存" actionBlock:^{
                           
                            [MBProgressHUD showSuccess:@"Clean up"];
                        }],
                        [[MyInfoModel alloc]initWithTitle:@"score" pictureName:@"评价" actionBlock:^{
                            
                            NSString  * nsStringToOpen = [NSString  stringWithFormat: @"itms-apps://itunes.apple.com/app/id%@?action=write-review",@"1434038476"];//替换为对应的APPID
                            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:nsStringToOpen]];
                        }],
                        [[MyInfoModel alloc]initWithTitle:@"abou" pictureName:@"关于" actionBlock:^{
                            
                            AboutViewController *VC = [[AboutViewController alloc]init];
                            [self.navigationController pushViewController:VC animated:YES];
                        }],
                       
                       
                        
                        
                        ];
    }
    return _dataSource;
}
@end
