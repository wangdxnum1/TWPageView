//
//  TWPageView.m
//  TWPageView
//
//  Created by HaKim on 15/12/29.
//  Copyright © 2015年 haKim. All rights reserved.
//

#import "TWPageView.h"
#import "Masonry.h"

#define WeakSelf(weakSelf)  __weak __typeof(&*self)weakSelf = self;

//device screen size
#define kScreenWidth               [[UIScreen mainScreen] bounds].size.width
#define kScreenHeight              [[UIScreen mainScreen] bounds].size.height

@interface TWPageView ()<UIScrollViewDelegate>

@property (nonatomic, weak) UIScrollView *scrollView;

@property (nonatomic, weak) UIPageControl *pageControl;

@property (nonatomic, strong) NSMutableArray *subViewsArray;

@end

@implementation TWPageView

- (instancetype)initWithFrame:(CGRect)frame
{
    if(self == [super initWithFrame:frame])
    {
        [self commonInit];
    }
    return self;
}



#pragma mark - public method
- (void)addPageWithView:(UIView *)view
{
    [self.scrollView addSubview:view];
    
    CGRect frame = CGRectMake(self.frame.size.width * _numberOfPages, 0, self.frame.size.width, self.frame.size.height);
    _numberOfPages++;
    view.frame = frame;
    [self.subViewsArray addObject:view];
    self.pageControl.numberOfPages = _numberOfPages;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.scrollView.contentSize = CGSizeMake(self.frame.size.width * _numberOfPages, self.frame.size.height);
}

#pragma mark UIScrollView 代理
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if(scrollView == self.scrollView)
    {
        CGFloat pageWidth = CGRectGetWidth(self.scrollView.frame);
        NSInteger page = self.scrollView.contentOffset.x /pageWidth;
        self.pageControl.currentPage = page;
    }
}

- (void)changePage:(UIPageControl *)sender {
    NSInteger page = self.pageControl.currentPage;
    CGRect bounds = self.bounds;
    bounds.origin.x = CGRectGetWidth(bounds) * page;
    bounds.origin.y = 0;
    [self.scrollView scrollRectToVisible:bounds animated:YES];
}

#pragma mark - UI
- (void)commonInit
{
    _numberOfPages = 0;
    
    [self setupScrollView];
    [self setupPageControle];
}

- (void)setupScrollView
{
    UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:CGRectZero];
    [self addSubview:scrollView];
    self.scrollView = scrollView;
    
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.bounces = NO;
    scrollView.pagingEnabled = YES;
    scrollView.delegate = self;
    scrollView.scrollEnabled = YES;
    
    WeakSelf(weakSelf);
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf).with.insets(UIEdgeInsetsZero);
    }];
    
    //self.scrollView.backgroundColor = [UIColor orangeColor];
}

- (void)setupPageControle
{
    UIPageControl *pageControl = [[UIPageControl alloc]initWithFrame:CGRectZero];
    [self addSubview:pageControl];
    self.pageControl = pageControl;
    
    pageControl.numberOfPages = 0;
    pageControl.currentPage = 0;
    
    [pageControl addTarget:self action:@selector(changePage:) forControlEvents:UIControlEventValueChanged];
    
    WeakSelf(weakSelf);
    [self.pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.mas_left).with.offset(0);
        make.right.equalTo(weakSelf.mas_right).with.offset(0);
        make.bottom.equalTo(weakSelf.mas_bottom).with.offset(-20);
        make.height.mas_equalTo(@(30));
    }];
}

#pragma mark - get & set method

- (NSMutableArray*)subViewsArray
{
    if(_subViewsArray == nil)
    {
        _subViewsArray = [NSMutableArray array];
    }
    return _subViewsArray;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
