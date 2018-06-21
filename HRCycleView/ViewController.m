//
//  ViewController.m
//  HRCycleView
//
//  Created by ld on 17/2/27.
//  Copyright © 2017年 ld. All rights reserved.
//

#import "ViewController.h"
#import "HRCycleView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSArray * colors = @[[UIColor redColor],[UIColor greenColor],[UIColor blackColor]];
    HRCycleView * view = [HRCycleView cycleView:2];
    view.frame = CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, 150);
    view.itemCount = ^(){
        return (NSInteger)3;
    };
    view.fetchItem = ^(NSInteger index,UIView * customView){
        if (customView == nil) {
            customView = [[UIView alloc]init];
        }
        customView.backgroundColor = colors[index];
        NSLog(@"%p",customView);
        return customView;
    };
    view.showIndicator = ^{
        return YES;
    };
    [self.view addSubview:view];
}


@end
