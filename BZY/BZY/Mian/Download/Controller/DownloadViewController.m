//
//  DownloadViewController.m
//  BZY
//
//  Created by 周鑫 on 2018/9/6.
//  Copyright © 2018年 ZX. All rights reserved.
//

#import "DownloadViewController.h"
#import "SortTableViewCell.h"
#import "PlayViewController.h"
#import "AudioModel.h"
#import "LocalAudio+CoreDataClass.h"
#import "DownLoadAudioModel.h"


@interface DownloadViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,weak) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataSource;
@end

@implementation DownloadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    
}

- (void)setupUI {
    
    self.title = @"download";
    self.view.backgroundColor = [UIColor whiteColor];
    
    __weak typeof(self) weakSelf = self;
    UITableView *tableView = [[UITableView alloc]init];
//    tableView.backgroundColor = [UIColor redColor];
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view addSubview:tableView];
    self.tableView = tableView;
    self.tableView.mj_header =  [MJRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    [self.tableView.mj_header beginRefreshing];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(weakSelf.view);
    }];
}

- (void)loadNewData {
    
    [self.tableView.mj_header endRefreshing];
//    self.dataSource = [self getAllFileByName:PATH_OF_DOCUMENT];
//    [self.tableView reloadData];
//    NSLog(@"%@",self.dataSource);
    
    __weak typeof(self) weakSelf = self;
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
    
    
    // 建立获取数据的请求对象，指明操作的实体为Employee
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"LocalAudio"];
    // 执行获取操作，获取所有Employee托管对象
    NSError *error = nil;
    NSArray *employees = [context executeFetchRequest:request error:&error];
    [employees enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        LocalAudio *loaclAudio = (LocalAudio *)obj;
        DownLoadAudioModel *audioModel = [[DownLoadAudioModel alloc]init];
        audioModel.name = loaclAudio.name;
        audioModel.pic = loaclAudio.pic;
        audioModel.author = loaclAudio.author;
        audioModel.url = loaclAudio.url;
        [weakSelf.dataSource addObject:audioModel];
        [weakSelf.tableView reloadData];
//        NSLog(@"文件名称%@",audioModel.name);
    }];

    // 错误处理
    if (error) {
        NSLog(@"CoreData Ergodic Data Error : %@", error);
    }
    
}

- (NSArray *)getAllFloderByName:(NSString *)path
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSArray * fileAndFloderArr = [self getAllFileByName:path];
    
    NSMutableArray *dirArray = [[NSMutableArray alloc] init];
    BOOL isDir = NO;
    //在上面那段程序中获得的fileList中列出文件夹名
    for (NSString * file in fileAndFloderArr){
        
        NSString *paths = [path stringByAppendingPathComponent:file];
        [fileManager fileExistsAtPath:paths isDirectory:(&isDir)];
        if (isDir) {
            [dirArray addObject:file];
        }
        isDir = NO;
    }
    return dirArray;
}

- (NSArray *)getAllFileByName:(NSString *)path
{
    NSFileManager *defaultManager = [NSFileManager defaultManager];
    NSArray *array = [defaultManager contentsOfDirectoryAtPath:path error:nil];
    NSMutableArray *dirArray = [[NSMutableArray alloc] init];
     BOOL isDir = NO;
    for (NSString *file in array) {
        NSString *paths = [path stringByAppendingPathComponent:file];
        if ([defaultManager fileExistsAtPath:paths isDirectory:(&isDir)]) {
            if (!isDir) {
                [dirArray addObject:paths];
            }
            isDir = NO;
        }
    }
    return dirArray;
}

#pragma mark -------------------------- Delegate ----------------------------------------
#pragma mark UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataSource.count;
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
    cell.downLoadAudioModel = self.dataSource[indexPath.row];
    //    AudioModel *audioModel = self.dataSource[indexPath.row];
    //    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:audioModel.pic]];
    //    cell.textLabel.text = audioModel.name;
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
      
//    DownLoadAudioModel *downLoadAudioModel = self.dataSource[indexPath.row];
//    PlayViewController *playVC = [[PlayViewController alloc]initWithAudioDownLoadAudioModel:downLoadAudioModel];
    PlayViewController *playVC = [[PlayViewController alloc]initWithAudioDownLoadAudioModelarray:self.dataSource currentIndex:indexPath.row];
    [self.navigationController pushViewController:playVC animated:YES];
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

// 定义编辑样式
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

// 进入编辑模式，按下出现的编辑按钮后,进行删除操作
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        DownLoadAudioModel *downLoadAudioModel = self.dataSource[indexPath.row];
        __weak typeof(self) weakSelf = self;
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
        
        // 建立获取数据的请求对象，指明对Employee实体进行删除操作
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"LocalAudio"];
        // 创建谓词对象，过滤出符合要求的对象，也就是要删除的对象
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"url = %@",downLoadAudioModel.url];
        request.predicate = predicate;
        // 执行获取操作，找到要删除的对象
        NSError *error = nil;
        NSArray *employees = [context executeFetchRequest:request error:&error];
        // 遍历符合删除要求的对象数组，执行删除操作
        [employees enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [context deleteObject:obj];
        }];
        // 保存上下文
        if (context.hasChanges) {
            [context save:nil];
        }
        // 错误处理
        if (error) {
            NSLog(@"CoreData Delete Data Error : %@", error);
        }
        [self.dataSource removeObject:downLoadAudioModel];
        [self.tableView reloadData];
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];

    }
}

// 修改编辑按钮文字
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"删除";
    
}

#pragma mark -------------------------- lazy load ----------------------------------------

- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [[NSMutableArray alloc]init];
    }
    return _dataSource;
}


@end
