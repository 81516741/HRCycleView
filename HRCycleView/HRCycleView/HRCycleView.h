//
//  HRCyleView.h
//  无限滚动
//
//  Created by ld on 17/2/24.
//  Copyright © 2017年 ld. All rights reserved.
//

#import <UIKit/UIKit.h>

//类似tableView的方式去使用，不同点是用block替代了代理
@interface HRCycleView : UIView<UICollectionViewDataSource,UICollectionViewDelegate>

/**
  * 快速创建对象
  * duration 每次滚动间隔时间
 */
+ (instancetype)cycleView:(NSTimeInterval)duration;
/**
 * 页面的个数必须大于0 这个block必须赋值 (类似tableView必须返回cell的个数)
 */
@property (nonatomic,copy) NSInteger(^itemCount)();
/**
 * 获取每个页面的item
 */
@property (nonatomic,copy) UIView *(^fetchItem)(NSInteger index,UIView * customView);
/**
 * item被点击
 */
@property (nonatomic,copy) void(^itemClick)(NSInteger index);
/**
 * 是否显示指示点
 */
@property (nonatomic,copy) BOOL(^showIndicator)();

@end


@interface hr_YYTextWeakProxy : NSProxy

@property (nonatomic, weak, readonly) id target;
- (instancetype)initWithTarget:(id)target;
+ (instancetype)proxyWithTarget:(id)target;

@end

