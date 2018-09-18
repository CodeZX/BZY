//
//  MusicHeaderView.h
//  BZY
//
//  Created by 周鑫 on 2018/9/14.
//  Copyright © 2018年 ZX. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MusicHeaderView;
@protocol  MusicHeaderViewDelegate <NSObject>
@optional
- (void)musicHeaderView:(MusicHeaderView *)musicHeaderView didSelectedAlias:(NSString *)alias;
@required
@end
@interface MusicHeaderView : UIView
@property (nonatomic,weak) id<MusicHeaderViewDelegate> delegate;
@end
