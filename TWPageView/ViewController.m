//
//  ViewController.m
//  TWPageView
//
//  Created by HaKim on 15/12/29.
//  Copyright © 2015年 haKim. All rights reserved.
//

#import "ViewController.h"
#import "TWPageView.h"
#import "UIColor+randomColor.h"
#import "Masonry.h"

#define WeakSelf(weakSelf)  __weak __typeof(&*self)weakSelf = self;

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    //CGRect frame = self.view.bounds;
    WeakSelf(weakSelf);
    TWPageView *pageView = [[TWPageView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:pageView];
    [pageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.view).with.insets(UIEdgeInsetsZero);
    }];
    
    
    UIViewController *vc = [[UIViewController alloc]init];
    vc.view.backgroundColor = [UIColor redColor];
    [pageView addPageWithView:vc.view];
    
    UIView *view2 = [[UIView alloc]init];
    view2.backgroundColor = [UIColor randomColor];
    [pageView addPageWithView:view2];
    
    UIView *view3 = [[UIView alloc]init];
    view3.backgroundColor = [UIColor randomColor];
    [pageView addPageWithView:view3];
    
    UIView *view4 = [[UIView alloc]init];
    view4.backgroundColor = [UIColor randomColor];
    [pageView addPageWithView:view4];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
