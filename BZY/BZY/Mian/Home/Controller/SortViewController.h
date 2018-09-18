//
//  SortViewController.h
//  BZY
//
//  Created by 周鑫 on 2018/9/3.
//  Copyright © 2018年 ZX. All rights reserved.
//

#import "BasicViewController.h"

@class HomeSortModel;
@interface SortViewController : BasicViewController
- (instancetype)initWithSortModel:(HomeSortModel *)sortModel;


- (instancetype)initWithAlias:(NSString *)alias;
@end
