//
//  MusicHeaderViewItemModel.h
//  BZY
//
//  Created by 周鑫 on 2018/9/14.
//  Copyright © 2018年 ZX. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MusicHeaderViewItemModel : NSObject
@property (nonatomic,strong) NSString *title;
@property (nonatomic,strong) NSString *type_alias;
@property (nonatomic,strong) NSString *pictureName;
- (instancetype)initWithTitle:(NSString *)title alias:(NSString *)alias pictureName:(NSString *)pictureName;
@end
