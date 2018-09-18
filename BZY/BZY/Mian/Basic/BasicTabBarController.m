//
//  BasicTabBarController.m
//  LSJ
//
//  Created by 周鑫 on 2018/8/17.
//  Copyright © 2018年 ZX. All rights reserved.
//

#import "BasicTabBarController.h"
#import "BasicNavigationController.h"
//#import "GramophoneViewControllerTwo.h"
//#import "RecordViewController.h"
//#import "PasswordBoxViewController.h"


#import "HomeViewController.h"
#import "MyViewController.h"
#import "MyDownloadViewController.h"
#import "DownloadViewController.h"
#import "MusicViewController.h"

@interface BasicTabBarController ()

@end

@implementation BasicTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
//    [[UITabBar appearance] setTintColor:[UIColor blackColor]];
   [self addChildViewControllers];
}

- (void)addChildViewControllers
{
    
   
    
//    HomeViewController *HomeVC =  [[HomeViewController alloc]init];
//    [self setChildViewController:HomeVC Image:@"音乐" selectedImage:@"音乐-1" title:@"music"];
    
    MusicViewController *musicVC =  [[MusicViewController alloc]init];
    [self setChildViewController:musicVC Image:@"音乐" selectedImage:@"音乐-1" title:@"music"];
    
    DownloadViewController *downloadVC = [[DownloadViewController alloc]init];
    [self setChildViewController:downloadVC Image:@"下载-11" selectedImage:@"下载-1" title:@"download"];
    
    MyViewController *myVC = [[MyViewController alloc] init];
    [self setChildViewController:myVC Image:@"我的" selectedImage:@"我的-1" title:@"me"];
   
}

#pragma mark - 初始化设置ChildViewControllers
/**
 *
 *  设置单个tabBarButton
 *
 *  @param Vc            每一个按钮对应的控制器
 *  @param image         每一个按钮对应的普通状态下图片
 *  @param selectedImage 每一个按钮对应的选中状态下的图片
 *  @param title         每一个按钮对应的标题
 */
- (void)setChildViewController:(UIViewController *)Vc Image:(NSString *)image selectedImage:(NSString *)selectedImage title:(NSString *)title
{
    BasicNavigationController *NA_VC = [[BasicNavigationController alloc] initWithRootViewController:Vc];
    
    UIImage *myImage = [UIImage imageNamed:image];
    myImage = [myImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    Vc.tabBarItem.image = myImage;
    
    UIImage *mySelectedImage = [UIImage imageNamed:selectedImage];
    mySelectedImage = [mySelectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    Vc.tabBarItem.selectedImage = mySelectedImage;
    
    Vc.title = title;
    
    [self addChildViewController:NA_VC];
    
}




@end
