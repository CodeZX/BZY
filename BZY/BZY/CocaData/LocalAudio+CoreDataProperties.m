//
//  LocalAudio+CoreDataProperties.m
//  BZY
//
//  Created by 周鑫 on 2018/9/6.
//  Copyright © 2018年 ZX. All rights reserved.
//
//

#import "LocalAudio+CoreDataProperties.h"

@implementation LocalAudio (CoreDataProperties)

+ (NSFetchRequest<LocalAudio *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"LocalAudio"];
}

@dynamic name;
@dynamic url;
@dynamic pic;
@dynamic author;

@end
