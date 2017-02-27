//
//  HRCyleView.m
//  无限滚动
//
//  Created by ld on 17/2/24.
//  Copyright © 2017年 ld. All rights reserved.
//

#import "HRCycleView.h"

#define kReuseID @"HRCycleView"
#define kRepeatCount 100000

@interface HRCycleView ()

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *flowLayout;
@property (weak, nonatomic) IBOutlet UIPageControl *pageController;
@property (assign ,nonatomic) NSInteger currentIndex;
@property (nonatomic,strong) NSTimer * timer;
@property (assign ,nonatomic) NSTimeInterval duration;

@end

@implementation HRCycleView

+ (instancetype)cycleView:(NSTimeInterval)duration
{
    HRCycleView * cycleView = [[[NSBundle mainBundle]loadNibNamed:@"HRCycleView" owner:nil options:nil] lastObject];
    [cycleView.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:kReuseID];
    cycleView.duration = duration;
    cycleView.pageController.enabled = NO;
    [cycleView startTimer];
    return cycleView;
}

- (void)autoScroll
{
    //如果item的个数为0 则不需要滚动item了 并暂停定时器
    if (self.itemCount() == 0) {
        [self invalidateTimer];
        return;
    }
    NSIndexPath * indexPath = [NSIndexPath indexPathForItem:_currentIndex + 1 inSection:0];
    [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionLeft animated:YES];
}

-(void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    self.flowLayout.itemSize = self.frame.size;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.itemCount() * kRepeatCount;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:kReuseID forIndexPath:indexPath];
    UIView * customView = self.fetchItem(indexPath.row % self.itemCount(),cell.customView);
    customView.frame = cell.bounds;
    cell.customView = customView;
    [cell addSubview:customView];
    return cell;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //如果没有item 则直接返回
    if (self.itemCount() == 0) {
        return;
    }
    //控制指示点的位置
    _currentIndex = (NSInteger)(scrollView.contentOffset.x/scrollView.bounds.size.width + 0.5);
    NSInteger  pageNum = _currentIndex % self.itemCount();
    self.pageController.currentPage = pageNum;
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    if (self.timer.valid) {//如果正在计时
        NSInteger needResetIndex = (kRepeatCount / 2 + 1) * self.itemCount();
        //超过中间位置 且是item个的整数倍 重新定位到中心位置 防止滚到底
        if (_currentIndex >= needResetIndex && _currentIndex % self.itemCount() == 0) {
            NSInteger midIndex = (kRepeatCount / 2 ) * self.itemCount();
            NSIndexPath * indexPath = [NSIndexPath indexPathForItem:midIndex inSection:0];
            [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
            
        }
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self invalidateTimer];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self startTimer];
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    self.pageController.hidden = _showIndicator ? !_showIndicator() : YES;
    _collectionView.contentOffset = CGPointMake(self.flowLayout.itemSize.width * (kRepeatCount / 2) * self.itemCount(), 0);
    _collectionView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
}

- (void)startTimer
{
    _timer = [NSTimer scheduledTimerWithTimeInterval:_duration  target:[hr_YYTextWeakProxy proxyWithTarget:self] selector:@selector(autoScroll) userInfo:nil repeats:YES];
}

- (void)invalidateTimer
{
    [_timer invalidate];
}

@end

#import <objc/runtime.h>
@implementation UICollectionViewCell (HRCycleView)

- (void)setCustomView:(UIView *)customView
{
    objc_setAssociatedObject(self, @selector(customView), customView, OBJC_ASSOCIATION_RETAIN);
}

- (UIView *)customView
{
    return objc_getAssociatedObject(self, _cmd);
}

@end

@implementation hr_YYTextWeakProxy

- (instancetype)initWithTarget:(id)target {
    _target = target;
    return self;
}

+ (instancetype)proxyWithTarget:(id)target {
    return [[hr_YYTextWeakProxy alloc] initWithTarget:target];
}

- (id)forwardingTargetForSelector:(SEL)selector {
    return _target;
}

- (void)forwardInvocation:(NSInvocation *)invocation {
    void *null = NULL;
    [invocation setReturnValue:&null];
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)selector {
    return [NSObject instanceMethodSignatureForSelector:@selector(init)];
}

- (BOOL)respondsToSelector:(SEL)aSelector {
    return [_target respondsToSelector:aSelector];
}

- (BOOL)isEqual:(id)object {
    return [_target isEqual:object];
}

- (NSUInteger)hash {
    return [_target hash];
}

- (Class)superclass {
    return [_target superclass];
}

- (Class)class {
    return [_target class];
}

- (BOOL)isKindOfClass:(Class)aClass {
    return [_target isKindOfClass:aClass];
}

- (BOOL)isMemberOfClass:(Class)aClass {
    return [_target isMemberOfClass:aClass];
}

- (BOOL)conformsToProtocol:(Protocol *)aProtocol {
    return [_target conformsToProtocol:aProtocol];
}

- (BOOL)isProxy {
    return YES;
}

- (NSString *)description {
    return [_target description];
}

- (NSString *)debugDescription {
    return [_target debugDescription];
}

@end

