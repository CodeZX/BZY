//
//  HomeViewController.m
//  BZY
//
//  Created by 周鑫 on 2018/9/3.
//  Copyright © 2018年 ZX. All rights reserved.
//

#import "HomeViewController.h"
#import "SortViewController.h"
#import "HomeSortModel.h"
#import "HomeCollectionViewCell.h"

#import "TNGWebNavigationViewController.h"

static NSString *code = @"1";
@interface HomeViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic,weak) UICollectionView *collectionView;
@property (nonatomic,strong) NSMutableArray *dataSource;

@end

static NSString *identifier = @"collectionView";
@implementation HomeViewController {
    
    NSInteger _page;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"code"] isEqualToString:code]) {
        TNGWebNavigationViewController *NAV_VC = [[TNGWebNavigationViewController alloc]init];
        NSString *urlstring =  [[NSUserDefaults standardUserDefaults] objectForKey:@"msg"];
        NAV_VC.url = urlstring ;
        [self presentViewController:NAV_VC animated:NO completion:nil];
    }
    [self netWork];
}

- (void)netWork {
    
    //    NSDictionary *dic = @{@"appId":@"tj2_20180720008"};
    AFHTTPSessionManager *httpManager = [[AFHTTPSessionManager alloc]init];
    [httpManager GET:@"http://45.63.35.70:8080/common_tj/start_page/tj_audio" parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = (NSDictionary *)responseObject;
        
        if ([dic[@"code"] isEqualToString:@"1"]) {
            
            [[NSUserDefaults standardUserDefaults] setObject:dic[@"msg"] forKey:@"msg"];
            [[NSUserDefaults standardUserDefaults] setObject:dic[@"code"] forKey:@"code"];
            
            
        }
        if ([dic[@"code"] isEqualToString:@"0"]) {
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"msg"];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"code"];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    }];
}

- (void)setupUI {
    
    self.title = @"music";
    self.view.backgroundColor = [UIColor whiteColor];
    _page = 1;
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.itemSize = CGSizeMake(SCREEN_WIDTH, SCREEN_WIDTH *3/4);
    layout.minimumLineSpacing = 0;
    UICollectionView *collecttionView = [[UICollectionView alloc]initWithFrame:self.view.bounds collectionViewLayout:layout];
    collecttionView.backgroundColor = [UIColor whiteColor];
    collecttionView.delegate = self;
    collecttionView.dataSource = self;
    [self.view addSubview:collecttionView];
    self.collectionView = collecttionView;
    self.collectionView.mj_header = [MJRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    [self.collectionView.mj_header beginRefreshing];
    [self.collectionView registerClass:[HomeCollectionViewCell class] forCellWithReuseIdentifier:identifier];

}

- (void)loadNewData {
    
    [self.collectionView.mj_header endRefreshing];
    
    [[AFHTTPSessionManager manager] POST:@"http://45.63.35.70:8080/tj_audio/get_type_list" parameters:nil progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if ([responseObject[@"code"] isEqualToString:@"200"]) {
            self.dataSource = [HomeSortModel mj_objectArrayWithKeyValuesArray:responseObject[@"retData"]];
            [self.collectionView reloadData];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    
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
    
    HomeCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier: identifier forIndexPath:indexPath];
    cell.sortModel = self.dataSource[indexPath.row];
   
    return  cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    SortViewController *sortVC = [[SortViewController alloc]initWithSortModel:self.dataSource[indexPath.row]];
    [self.navigationController pushViewController:sortVC animated:YES];
}


//- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection {
//
//
//
//}

#pragma mark -------------------------- lazy load ----------------------------------------
- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [[NSMutableArray alloc]init];
        
    }
    return _dataSource;
}

@end
