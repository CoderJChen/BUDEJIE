//
//  CJEmotionListView.m
//  BUDEJIE
//
//  Created by eric on 17/1/20.
//  Copyright © 2017年 eric. All rights reserved.
//

#import "CJEmotionListView.h"
#import "CJEmotionPageView.h"
@interface CJEmotionListView ()<UIScrollViewDelegate>
@property(weak, nonatomic) UIScrollView * scrollView;
@property(weak, nonatomic) UIPageControl * pageControl;
@end

@implementation CJEmotionListView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
//        self.backgroundColor = CJRandomColor;
        [self setUpScrollView];
        [self setUpPageControl];
        
    }
    return self;
}
- (void)setUpScrollView{
//    滚动视图
    UIScrollView * scrollView = [[UIScrollView alloc]init];
    scrollView.delegate = self;
//    scrollView.backgroundColor = [UIColor yellowColor];
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.pagingEnabled = YES;
    scrollView.bounces = NO;
    [self addSubview:scrollView];
    _scrollView = scrollView;
}
- (void)setUpPageControl{
//    翻页视图
    UIPageControl * pageControl = [[UIPageControl alloc]init];
    pageControl.userInteractionEnabled = NO;
    
    [pageControl setValue:[UIImage imageNamed:@"compose_keyboard_dot_normal"] forKeyPath:@"_pageImage"];
    [pageControl setValue:[UIImage imageNamed:@"compose_keyboard_dot_selected"] forKeyPath:@"_currentPageImage"];
    
//    pageControl.pageIndicatorTintColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"compose_keyboard_dot_normal"]];
//    pageControl.currentPageIndicatorTintColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"compose_keyboard_dot_selected"]];
    
    [self addSubview:pageControl];
    
    _pageControl = pageControl;
}

- (void)setEmotions:(NSArray *)emotions{
    _emotions = emotions;
    
    NSInteger count = (emotions.count + CJEmotionPageNumber - 1)/CJEmotionPageNumber;
    
    self.pageControl.numberOfPages = count;
    for (int i = 0; i < count; i++) {
        CJEmotionPageView * pageView = [[CJEmotionPageView alloc]init];
        NSRange range;
        range.location = i * CJEmotionPageNumber;
        NSUInteger left = emotions.count - range.location;
        if (left > CJEmotionPageNumber) {
            range.length = CJEmotionPageNumber;
        }else{
            range.length = left;
        }
        pageView.emotions = [emotions subarrayWithRange:range];
        [self.scrollView addSubview:pageView];
    }
    
}
- (void)layoutSubviews{
    [super layoutSubviews];
    
    self.pageControl.width = self.width;
    self.pageControl.height = 35;
    self.pageControl.x = 0;
    self.pageControl.y = self.height - self.pageControl.height;

    self.scrollView.x = self.scrollView.y = 0;
    self.scrollView.width = self.width;
    self.scrollView.height = self.pageControl.y ;
    
    NSInteger count = self.scrollView.subviews.count;
    
    for (int i = 0; i < count; i++) {
        CJEmotionPageView * pageView = self.scrollView.subviews[i];
        pageView.x = i * self.scrollView.width;
        pageView.y = 0;
        pageView.width = self.scrollView.width;
        pageView.height = self.scrollView.height;
    }
    self.scrollView.contentSize = CGSizeMake(self.scrollView.width * count, 0);
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    self.pageControl.currentPage = scrollView.contentOffset.x / scrollView.width + 0.5;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
