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

#import "MusicItemModel.h"
#import "MusicItemCell.h"
#import "LocalAudio+CoreDataClass.h"


@interface SortViewController ()<UITableViewDelegate,UITableViewDataSource,MusicItemCellDelegate,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>

@property (nonatomic,weak) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataSource;
@property (nonatomic,strong) HomeSortModel *sortModel;

@property (nonatomic,strong) NSString *alias;
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

- (instancetype)initWithAlias:(NSString *)alias {
    
    self = [super init];
    if (self) {
        self.alias = alias;
    }
    return self;
}




- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}

- (void)rightBarClicked:(id)sender {
    
    PlayViewController *playVC = [[PlayViewController alloc]initWithAudioSource:nil currentItemModelAtIndex:0];
    [self presentViewController:playVC animated:YES completion:^{
        
    }];
    
}

- (void)setupUI {
    
    self.title = @"sort";
    self.view.backgroundColor = [UIColor redColor];
    
    UIImage *rightImage = [[UIImage imageNamed:@"音频-3"] imageWithRenderingMode:(UIImageRenderingModeAlwaysOriginal)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:rightImage style:UIBarButtonItemStylePlain target:self action:@selector(rightBarClicked:)];
    
    UITableView *tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.emptyDataSetSource = self;
    tableView.emptyDataSetDelegate = self;
    [self.view addSubview:tableView];
    self.tableView = tableView;
    self.tableView.mj_header =  [MJRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    [self.tableView.mj_header beginRefreshing];
    self.tableView = tableView;
    
    
    
}

- (void)loadNewData {
    
    [self.tableView.mj_header endRefreshing];
    _page++;
    NSDictionary *dic = @{@"type_alias":self.alias,
                          @"page":[NSString stringWithFormat:@"%ld",_page]
                          };
    [[AFHTTPSessionManager manager] POST:@"http://45.63.35.70:8080/tj_audio/get_audio_by_type" parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if ([responseObject[@"code"] isEqualToString:@"200"]) {
            NSArray *array = [MusicItemModel mj_objectArrayWithKeyValuesArray:responseObject[@"retData"]];
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
    MusicItemCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[MusicItemCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
        cell.delegate = self;
    }
    cell.itemModel = self.dataSource[indexPath.row];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
//    MusicItemModel *itemModel = self.dataSource[indexPath.row];
//    PlayViewController *playVC = [[PlayViewController alloc]initWithAudioSource:@[itemModel]];
    PlayViewController *playVC  = [[PlayViewController alloc]initWithAudioSource:self.dataSource currentItemModelAtIndex:indexPath.row];
    [self presentViewController:playVC animated:YES completion:^{
        
    }];
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

- (void)saveToDataBaseByFilePath:(NSURL *)filePath  itemModel:(MusicItemModel *)itemModel{
    
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
    
    [[BZYPlayManager sharedInstance] addAudioSource:self.dataSource];
    NSInteger index = [self.dataSource indexOfObject:itemModel];
    [[BZYPlayManager sharedInstance] playWithIndex:index];
    
    
}

#pragma mark DZNEmptyDataSetDelegate
- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    
    NSAttributedString *attString = [[NSAttributedString alloc]initWithString:@"No music recommended"];
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
