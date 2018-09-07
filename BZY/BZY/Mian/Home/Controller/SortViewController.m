//
//  SortViewController.m
//  BZY
//
//  Created by 周鑫 on 2018/9/3.
//  Copyright © 2018年 ZX. All rights reserved.
//

#import "SortViewController.h"
#import "PlayViewController.h"
#import "AudioModel.h"
#import "HomeSortModel.h"
#import "SortTableViewCell.h"


@interface SortViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,weak) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataSource;
@property (nonatomic,strong) HomeSortModel *sortModel;
@end

@implementation SortViewController
{
    
    NSInteger _page;
}

- (instancetype)initWithSortModel:(HomeSortModel *)sortModel {
    self = [super init];
    if (self) {
        self.sortModel = sortModel;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}

- (void)setupUI {
    
    self.title = @"sort";
    self.view.backgroundColor = [UIColor redColor];
    
    UITableView *tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view addSubview:tableView];
    self.tableView = tableView;
    self.tableView.mj_header =  [MJRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    [self.tableView.mj_header beginRefreshing];
    self.tableView = tableView;
    
    
    
}

- (void)loadNewData {
    
    [self.tableView.mj_header endRefreshing];
    _page++;
    NSDictionary *dic = @{@"type_alias":self.sortModel.type_alias,
                          @"page":[NSString stringWithFormat:@"%ld",_page]
                          };
    [[AFHTTPSessionManager manager] POST:@"http://45.63.35.70:8080/tj_audio/get_audio_by_type" parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if ([responseObject[@"code"] isEqualToString:@"200"]) {
            NSArray *array = [AudioModel mj_objectArrayWithKeyValuesArray:responseObject[@"retData"]];
            [self.dataSource addObjectsFromArray:array];
            [self.tableView reloadData];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    
}
#pragma mark -------------------------- Deletate ----------------------------------------
#pragma mark UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return  self.dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 55;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identifier = @"SortTableViewCell";
    SortTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"SortTableViewCell" owner:nil options:nil] lastObject];
    }
    cell.audioModel = self.dataSource[indexPath.row];
//    AudioModel *audioModel = self.dataSource[indexPath.row];
//    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:audioModel.pic]];
//    cell.textLabel.text = audioModel.name;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
//    PlayViewController *VC = [[PlayViewController alloc]initWithAudioModel:self.dataSource[indexPath.row]];
    PlayViewController *VC = [[PlayViewController alloc]initWithAudioModelarray:self.dataSource currentIndex:indexPath.row];
    [self.navigationController pushViewController:VC animated:YES];
}

#pragma mark --------------------------lazy load ----------------------------------------
- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [[NSMutableArray alloc]init];
    }
    return _dataSource;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    
//    return 60;
//}
@end
