//
//  LocalAudio+CoreDataProperties.h
//  BZY
//
//  Created by 周鑫 on 2018/9/6.
//  Copyright © 2018年 ZX. All rights reserved.
//
//

#import "LocalAudio+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface LocalAudio (CoreDataProperties)

+ (NSFetchRequest<LocalAudio *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *name;
@property (nullable, nonatomic, copy) NSURL *url;
@property (nullable, nonatomic, copy) NSString *pic;
@property (nullable, nonatomic, copy) NSString *author;

@end

NS_ASSUME_NONNULL_END
