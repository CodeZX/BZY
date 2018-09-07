//
//  MyInfoModel.h
//  BZY
//
//  Created by 周鑫 on 2018/9/5.
//  Copyright © 2018年 ZX. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef  void (^actionBlock)(void);
@interface MyInfoModel : NSObject

@property (nonatomic,strong) NSString *title;
@property (nonatomic,strong) actionBlock block;

- (instancetype)initWithTitle:(NSString *)title actionBlock:(actionBlock)block;
@end
