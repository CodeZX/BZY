//
//  MyInfoModel.m
//  BZY
//
//  Created by 周鑫 on 2018/9/5.
//  Copyright © 2018年 ZX. All rights reserved.
//

#import "MyInfoModel.h"

@implementation MyInfoModel
- (instancetype)initWithTitle:(NSString *)title pictureName:(NSString *)pictureName actionBlock:(actionBlock)block {
    
    self = [super init];
    if (self) {
        self.title = title;
        self.pictureName = pictureName;
        self.block = block;
    }
    return self;
}


@end
