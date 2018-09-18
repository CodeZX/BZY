//
//  AboutViewController.m
//  BZY
//
//  Created by 周鑫 on 2018/9/6.
//  Copyright © 2018年 ZX. All rights reserved.
//

#import "AboutViewController.h"
#import <WebKit/WebKit.h>

@interface AboutViewController ()
@property (nonatomic,weak) WKWebView *webView;
@end

@implementation AboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}


- (void)setupUI {
    
    self.title = @"about";
    self.view.backgroundColor = [UIColor whiteColor];
    
//    WKWebView *webView = [[WKWebView alloc]initWithFrame:self.view.bounds];
//    [self.view addSubview:webView];
//    self.webView = webView;
    
//    relo
    
    __weak typeof(self) weakSelf = self;
    UILabel *label = [[UILabel alloc]init];
    label.text = @"Hear the best voice and be the best of yourself";
    label.font = [UIFont systemFontOfSize:12];
    label.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(weakSelf.view);
    }];
    
    
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
