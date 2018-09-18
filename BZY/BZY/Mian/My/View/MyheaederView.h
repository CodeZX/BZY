//
//  MyheaederView.h
//  BZY
//
//  Created by 周鑫 on 2018/9/14.
//  Copyright © 2018年 ZX. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MyheaederView;
@protocol  MyheaederViewDelegate <NSObject>
@optional
- (void)heaederView:(MyheaederView *)headerView didTapPortraitImaV:(UIImageView *)PortraitImaV;
- (void)heaederView:(MyheaederView *)headerView didTapCollect:(UIButton *)collectBtn;
@required
@end
@interface MyheaederView : UIView
@property (nonatomic,weak) id<MyheaederViewDelegate> delegate;
@end
