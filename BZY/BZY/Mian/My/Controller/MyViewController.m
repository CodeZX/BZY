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

#import "AboutViewController.h"
@interface MyViewController ()<UITableViewDelegate,UITableViewDataSource>

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
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view addSubview:tableView];
    self.tableView = tableView;
//    self.tableView.mj_header =  [MJRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
//    [self.tableView.mj_header beginRefreshing];
    self.tableView = tableView;
    
    
    
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identifier = @"UITableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    MyInfoModel *infoModel = self.dataSource[indexPath.row];
    cell.textLabel.text = infoModel.title;
//    cell.audioModel = self.dataSource[indexPath.row];
    //    AudioModel *audioModel = self.dataSource[indexPath.row];
    //    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:audioModel.pic]];
    //    cell.textLabel.text = audioModel.name;
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

#pragma mark -------------------------- lazy laod ----------------------------------------
- (NSArray *)dataSource {
    if (!_dataSource) {
        
        _dataSource = @[
                       
                        [[MyInfoModel alloc]initWithTitle:@"Clean up the cache" actionBlock:^{
                           
                            [MBProgressHUD showSuccess:@"Clean up"];
                        }],
                        [[MyInfoModel alloc]initWithTitle:@"score" actionBlock:^{
                            
                            NSString  * nsStringToOpen = [NSString  stringWithFormat: @"itms-apps://itunes.apple.com/app/id%@?action=write-review",@"1434038476"];//替换为对应的APPID
                            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:nsStringToOpen]];
                        }],
                        [[MyInfoModel alloc]initWithTitle:@"abou" actionBlock:^{
                            
                            AboutViewController *VC = [[AboutViewController alloc]init];
                            [self.navigationController pushViewController:VC animated:YES];
                        }],
                       
                       
                        
                        
                        ];
    }
    return _dataSource;
}
@end
