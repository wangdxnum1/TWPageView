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
@property (nonatomic, weak) UIView *contentView;
@property (nonatomic, weak) UIPageControl *pageControl;

@property (nonatomic, strong) NSMutableArray *subViewsArray;

@property (nonatomic, assign)NSInteger previousPage;

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
    [self.contentView addSubview:view];

    _numberOfPages++;
    
    WeakSelf(weakSelf);
    if(_numberOfPages == 1)
    {
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.contentView);
            make.top.equalTo(weakSelf.contentView);
            make.bottom.equalTo(weakSelf.contentView);
            make.width.equalTo(weakSelf);
        }];
    }
    else
    {
        UIView *leftView = [self.subViewsArray lastObject];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(leftView.mas_right);
            make.top.equalTo(weakSelf.contentView);
            make.bottom.equalTo(weakSelf.contentView);
            make.width.equalTo(leftView);
        }];
    }
    
    [self.subViewsArray addObject:view];
    self.pageControl.numberOfPages = _numberOfPages;
}

- (NSInteger)currentPage
{
    NSInteger currentPage = self.scrollView.contentOffset.x / self.frame.size.width;
    return currentPage;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    WeakSelf(weakSelf);
//    [self.contentView mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.width.mas_equalTo(@(weakSelf.frame.size.width * self.numberOfPages));
//    }];
    
    if (self.scrollView.contentSize.width != self.frame.size.width * self.numberOfPages) {
        [self.contentView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(@(weakSelf.frame.size.width * self.numberOfPages));
        }];
        [self.scrollView setContentOffset:CGPointMake(self.frame.size.width * self.previousPage, self.scrollView.contentOffset.y)];
    } else {
        self.previousPage = [self currentPage];
    }
}


#pragma mark UIScrollView 代理
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if(scrollView == self.scrollView)
    {
        CGFloat pageWidth = CGRectGetWidth(self.scrollView.frame);
        NSInteger page = self.scrollView.contentOffset.x / pageWidth;
        self.pageControl.currentPage = page;
        self.previousPage = page;
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
    self.previousPage = 0;
    self.currentPage = 0;
    
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
    
    UIView *contentView = [[UIView alloc]initWithFrame:CGRectZero];
    self.contentView = contentView;
    [self.scrollView addSubview:contentView];
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.scrollView);
        
        //make.width.equalTo(self.scrollView);
        make.height.equalTo(self.scrollView);
    }];
    contentView.backgroundColor = [UIColor orangeColor];
    
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
