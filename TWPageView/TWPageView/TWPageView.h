//
//  TWPageView.h
//  TWPageView
//
//  Created by HaKim on 15/12/29.
//  Copyright © 2015年 haKim. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TWPageView : UIView

- (void)addPageWithView:(UIView*)view;

@property(nonatomic,assign,readonly) NSInteger numberOfPages;
@end
