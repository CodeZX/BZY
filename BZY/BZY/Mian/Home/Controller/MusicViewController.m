//
//  MusicViewController.m
//  BZY
//
//  Created by 周鑫 on 2018/9/14.
//  Copyright © 2018年 ZX. All rights reserved.
//

#import "MusicViewController.h"
#import "MusicHeaderView.h"
#import "MusicItemCell.h"
#import "MusicItemModel.h"
#import "SortViewController.h"
#import "PlayViewController.h"
#import "LocalAudio+CoreDataClass.h"


#import <TJWebTools/TJWebTools.h>

static NSString *code = @"1";
@interface MusicViewController () <UITableViewDelegate,UITableViewDataSource,MusicHeaderViewDelegate,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate,MusicItemCellDelegate>

@property (nonatomic,weak) UITableView *tableView;
@property (nonatomic,strong) NSArray *items;
@end

@implementation MusicViewController

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
//        if ([dic[@"code"] isEqualToString:@"0"]) {
//            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"msg"];
//            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"code"];
//        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    }];
}

- (void)rightBarClicked:(id)sender {
    
    PlayViewController *playVC = [[PlayViewController alloc]initWithAudioSource:nil];
    [self presentViewController:playVC animated:YES completion:^{
        
    }];
    
}
- (void)setupUI {
    
    self.title  = @"music";
    self.view.backgroundColor = [UIColor whiteColor];
    __weak typeof(self) weakSelf = self;
    
    UIImage *rightImage = [[UIImage imageNamed:@"音频-3"] imageWithRenderingMode:(UIImageRenderingModeAlwaysOriginal)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:rightImage style:UIBarButtonItemStylePlain target:self action:@selector(rightBarClicked:)];
    
    
    
    
    UITableView *tableView = [[UITableView alloc]init];
    tableView.backgroundColor = [UIColor jk_colorWithHex:0xEFEFEF];
    //    tableView.separatorStyle  = UITableViewCellSeparatorStyleNone;
    tableView.delegate  = self;
    tableView.dataSource = self;
    tableView.emptyDataSetSource = self;
    tableView.emptyDataSetDelegate = self;
    [self.view addSubview:tableView];
    self.tableView = tableView;
    MusicHeaderView *headerView = [[MusicHeaderView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 200)];
    headerView.delegate = self;
    self.tableView.tableHeaderView = headerView;
    //    TJUserCenterHeaderView *headerView = [[TJUserCenterHeaderView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH *SCALE_H(375, 278))];
    //    self.tableView.tableHeaderView = headerView;
    self.tableView.mj_header = [MJRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.view);
    }];
    [self.tableView.mj_header beginRefreshing];
    
}

- (void)loadNewData {
    
    [self.tableView.mj_header endRefreshing];
    [MBProgressHUD showMessage:@"Loadin....."];
    [[AFHTTPSessionManager manager] POST:@"http://45.63.35.70:8080/tj_audio/get_hot_recommend" parameters:nil progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [MBProgressHUD hideHUD];
        if ([responseObject[@"code"] isEqualToString:@"200"]) {
            self.items = [MusicItemModel mj_objectArrayWithKeyValuesArray:responseObject[@"retData"]];
            [self.tableView reloadData];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    
    
}

#pragma mark -------------------------- Delegate ----------------------------------------
#pragma mark UITableViewSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
//    NSArray *items = self.sectionArray[section];
//    return items.count;
    return self.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identifier = @"TJSettingTableViewCell";
    MusicItemCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[MusicItemCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
        cell.delegate = self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.itemModel = self.items[indexPath.row];
//    NSArray *items = self.sectionArray[indexPath.section];
//    cell.itemModel = items[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 60;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {

    return 35;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *v = [[UIView alloc]init];
    v.backgroundColor = [UIColor jk_colorWithHex:0xE1E1E1];
    UILabel *titlelab = [[UILabel alloc]init];
    titlelab.textColor = [UIColor jk_colorWithHex:0x272727];
    titlelab.text = @"Top Picks";
    [v addSubview:titlelab];
    [titlelab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(v).offset(15);
        make.centerY.equalTo(v);
    }];
    return v;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section  {
    
    return 0.1;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section  {
    
    return [[UIView alloc]init];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
//    MusicItemModel *itemModel = self.items[indexPath.row];
    PlayViewController *playVC = [[PlayViewController alloc]initWithAudioSource:self.items currentItemModelAtIndex:indexPath.row];
//    PlayViewController *playVC = [[PlayViewController alloc]initWithAudioSource:self.items];
    [self presentViewController:playVC animated:YES completion:^{
        
    }];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
//    cell.separatorInset = UIEdgeInsetsZero;
//    
//    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    NSArray *items = self.sectionArray[indexPath.section];
//    TJSettingItemModel *item = items[indexPath.row];
//    if ( item.accessoryType != TJSettingItemAccessoryTypeSwitch) {
//        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//    }else {
//        cell.accessoryType = UITableViewCellAccessoryNone;
//    }
    //    cell.layoutMargins = UIEdgeInsetsZero;
}

#pragma mark MusicItemCellDelegate

- (void)musicItemCell:(MusicItemCell *)musicItemCell didDownload:(MusicItemModel *)itemModel {
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    // 1. 创建会话管理者
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    // 2. 创建下载路径和请求对象
    NSURL *URL = [NSURL URLWithString:itemModel.url];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    // 3.创建下载任务
    /**
     * 第一个参数 - request：请求对象
     * 第二个参数 - progress：下载进度block
     *      其中： downloadProgress.completedUnitCount：已经完成的大小
     *            downloadProgress.totalUnitCount：文件的总大小
     * 第三个参数 - destination：自动完成文件剪切操作
     *      其中： 返回值:该文件应该被剪切到哪里
     *            targetPath：临时路径 tmp NSURL
     *            response：响应头
     * 第四个参数 - completionHandler：下载完成回调
     *      其中： filePath：真实路径 == 第三个参数的返回值
     *            error:错误信息
     */
    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:^(NSProgress *downloadProgress) {
        
        //        // 下载进度
        //        self.progressView.progress = 1.0 * downloadProgress.completedUnitCount / downloadProgress.totalUnitCount;
        //        self.progressLabel.text = [NSString stringWithFormat:@"当前下载进度:%.2f%%",100.0 * downloadProgress.completedUnitCount / downloadProgress.totalUnitCount];
        //        NSLog(@"下载%f",1.0 * downloadProgress.completedUnitCount / downloadProgress.totalUnitCount);
        
    } destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
        
        NSArray *cacPath = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
        NSString *cachePath = [cacPath objectAtIndex:0];
        NSURL *url = [NSURL fileURLWithPath:cachePath];
        
        //        NSURL *path = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
        NSDate *date = [NSDate date];
        return [url URLByAppendingPathComponent:[NSString stringWithFormat:@"%.0f.mp3",date.timeIntervalSince1970]];
        
        
    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
        //        NSLog(@"File downloaded to: %@", filePath);
//        self.downloadBtn.enabled = YES;
        [self saveToDataBaseByFilePath:filePath itemModel:itemModel];
        [MBProgressHUD showSuccess:@"Download completed"];
    }];
    
    // 4. 开启下载任务
    [downloadTask resume];
   
    
}

- (void)saveToDataBaseByFilePath:(NSURL *)filePath  itemModel:(MusicItemModel
                                                               *) itemModel{
    
    // 创建上下文对象，并发队列设置为主队列
    NSManagedObjectContext *context = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    // 创建托管对象模型，并使用Company.momd路径当做初始化参数
    NSURL *modelPath = [[NSBundle mainBundle] URLForResource:@"Model" withExtension:@"momd"];
    NSManagedObjectModel *model = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelPath];
    // 创建持久化存储调度器
    NSPersistentStoreCoordinator *coordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:model];
    // 创建并关联SQLite数据库文件，如果已经存在则不会重复创建
    NSString *dataPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject;
    dataPath = [dataPath stringByAppendingFormat:@"/%@.sqlite", @"AudioModel"];
    [coordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:[NSURL fileURLWithPath:dataPath] options:nil error:nil];
    // 上下文对象设置属性为持久化存储器
    context.persistentStoreCoordinator = coordinator;
    
    
    // 创建托管对象，并指明创建的托管对象所属实体名
    LocalAudio *emp = [NSEntityDescription insertNewObjectForEntityForName:@"LocalAudio" inManagedObjectContext:context];
    emp.name = itemModel.name;
    emp.url = filePath;
    emp.pic = itemModel.pic;
    emp.author = itemModel.author;
    // 通过上下文保存对象，并在保存前判断是否有更改
    NSError *error = nil;
    if (context.hasChanges) {
        [context save:&error];
    }
    // 错误处理
    if (error) {
        NSLog(@"CoreData Insert Data Error : %@", error);
    }
    
}

- (void)musicItemCell:(MusicItemCell *)musicItemCell didAudition:(MusicItemModel *)itemModel {
     [[BZYPlayManager sharedInstance] addAudioSource:self.items];
    NSInteger index = [self.items indexOfObject:itemModel];
    [[BZYPlayManager sharedInstance] playWithIndex:index];
    
}
#pragma mark DZNEmptyDataSetDelegate
- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    
    NSAttributedString *attString = [[NSAttributedString alloc]initWithString:@"No recommended music"];
    return attString;
}

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    
    return [UIImage imageNamed:@"音乐1"];
}

- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView {
    
    return 50;
}


- (BOOL)emptyDataSetShouldAllowTouch:(UIScrollView *)scrollView {
    
    return YES;
}

- (void)emptyDataSet:(UIScrollView *)scrollView didTapView:(UIView *)view {
    
    DEBUG_LOG(@"1111");
    [self.tableView.mj_header beginRefreshing];
}
#pragma mark MusicHeaderViewDelegate
- (void)musicHeaderView:(MusicHeaderView *)musicHeaderView didSelectedAlias:(NSString *)alias {
    
    SortViewController *sortVC = [[SortViewController alloc]initWithAlias:alias];
    [self.navigationController pushViewController:sortVC animated:YES];

}

@end
