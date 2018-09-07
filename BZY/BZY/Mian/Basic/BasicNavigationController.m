//
//  BasicNavigationController.m
//  LSJ
//
//  Created by 周鑫 on 2018/8/17.
//  Copyright © 2018年 ZX. All rights reserved.
//

#import "BasicNavigationController.h"

@interface BasicNavigationController ()

@end

@implementation BasicNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[UINavigationBar appearance] setTintColor:[UIColor blackColor]];
//    [[UIBarButtonItem appearance] setBackgroundVerticalPositionAdjustment:cg forBarMetrics:UIBarMetricsDefault];
//    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(NSIntegerMin, NSIntegerMin) forBarMetrics:UIBarMetricsDefault];
  
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
    if (self.viewControllers.count > 0) {
         viewController.hidesBottomBarWhenPushed=YES;
    }
    if (self.viewControllers == 0) {
         viewController.hidesBottomBarWhenPushed = NO;
    }
    [super pushViewController:viewController
                     animated:animated];
   
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
