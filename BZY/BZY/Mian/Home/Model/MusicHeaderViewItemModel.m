//
//  MusicHeaderViewItemModel.m
//  BZY
//
//  Created by 周鑫 on 2018/9/14.
//  Copyright © 2018年 ZX. All rights reserved.
//

#import "MusicHeaderViewItemModel.h"

@implementation MusicHeaderViewItemModel

- (instancetype)initWithTitle:(NSString *)title alias:(NSString *)alias pictureName:(NSString *)pictureName {
    
    self = [super init];
    if (self) {
        self.title = title;
        self.type_alias = alias;
        self.pictureName = pictureName;
    }
    return self;
}



@end
