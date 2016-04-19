//
//  DXScrollMenu.m
//  QRFounder
//
//  Created by dongxin on 16/3/28.
//  Copyright © 2016年 dongxin. All rights reserved.
//

#import "DXScrollMenu.h"
#import "DXMenuBtn.h"

#import "DXCommenHelper.h"

#import "DXHelper.h"
#define MenuItemCount 6
#define MenuIconCount 7
#define iconWidth 25
#define  MenuWidth 60
@interface DXScrollMenu()<UIScrollViewDelegate>

@property (nonatomic, strong)UIScrollView *iconScrollView;
@property (nonatomic, strong)UIScrollView *menuScrollView;
@property (nonatomic, strong)NSMutableArray *pageControls;
@property (nonatomic, strong)NSMutableArray *iconBtns;
@property (nonatomic, strong)NSMutableArray *subScrollViews;
@end


@implementation DXScrollMenu

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void)setMenuItems:(NSArray *)menuItems {

    _menuItems = menuItems;
    
    
    [self.iconScrollView removeFromSuperview];
    self.iconScrollView = nil;
    [self.menuScrollView removeFromSuperview];
    self.menuScrollView = nil;
    NSInteger i = 0;
    self.menuScrollView.contentSize = CGSizeMake(self.menuScrollView.frame.size.width * _menuItems.count, self.menuScrollView.frame.size.height);

    CGFloat iconW = self.frame.size.width/MenuIconCount;
    
    self.iconScrollView.contentSize = CGSizeMake(_menuItems.count * iconW, self.iconScrollView.frame.size.height);
    
    for (DXmenuItem *item in _menuItems) {
        DXMenuBtn *iconBtn = [DXMenuBtn buttonWithType:UIButtonTypeCustom];
        iconBtn.tag = i;
        CGFloat iconW = self.frame.size.width/MenuIconCount;
        
        iconBtn.frame = CGRectMake(i * iconW , 0, iconW, self.iconScrollView.frame.size.height);
        
        //iconBtn.layer.borderWidth = 1;
        UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake((i + 1) * iconW, 0, 1, self.iconScrollView.frame.size.height)];
        
        lable.backgroundColor = [UIColor whiteColor];
        
        [iconBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [iconBtn setImage:item.menuIcon forState:UIControlStateNormal];
        UILabel *lable11 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 4, 4)];
        lable11.backgroundColor = RGB(0, 0, 0, 0.6);
        [iconBtn setBackgroundImage: [[DXHelper shareInstance] imageFromView:lable11 ] forState:UIControlStateSelected];
        
        [self.iconScrollView addSubview:iconBtn];
        [self.iconScrollView addSubview:lable];
        NSInteger j = 0;
        
        iconW = self.frame.size.width/MenuItemCount;
         UIScrollView *subScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(i * self.menuScrollView.frame.size.width, 0,  self.menuScrollView.frame.size.width,  self.menuScrollView.frame.size.height)];
        subScrollView.userInteractionEnabled = YES;
        subScrollView.showsHorizontalScrollIndicator = NO;
        subScrollView.delegate = self;
        subScrollView.tag = i;
        for (DXSubMenuItem *subMenu in item.items) {
           
            
            
            DXMenuBtn *iconBtn = [DXMenuBtn buttonWithType:UIButtonTypeCustom];
            iconBtn.tag = -1;
            iconBtn.path = [NSIndexPath indexPathForRow:j inSection:i];
            
            iconBtn.frame = CGRectMake(j * iconW , 0 , iconW, self.menuScrollView.frame.size.height);
            
            [iconBtn setImage:subMenu.normalImage forState:UIControlStateNormal];
            
            [iconBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
            
            [subScrollView addSubview:iconBtn];
            

          j++;
        }
        NSInteger pageCount = item.items.count / MenuItemCount + item.items.count % MenuItemCount > 0 ? 1 : 0;
        subScrollView.contentSize = CGSizeMake(subScrollView.frame.size.width *pageCount, subScrollView.frame.size.height);

        [self.menuScrollView addSubview:subScrollView];
        CGRect subFrame = subScrollView.frame;
        if (pageCount > 1) {
            UIPageControl *pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(subFrame.origin.x , subFrame.origin.y + subFrame.size.height - 9, subFrame.size.width, 4)];
            pageControl.numberOfPages = pageCount;
            pageControl.tag = i;
            pageControl.currentPage = 0;
            pageControl.pageIndicatorTintColor = [UIColor grayColor];
            pageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
            [self.menuScrollView addSubview:pageControl];
            [self.pageControls addObject:pageControl];
        }
        
        i ++;
    }
    [self selectIconWithTag:0];
    
}

- (void)btnClick:(DXMenuBtn *)sender {
    if (!sender.path) {
     NSLog(@"Btn Click With Tag : %ld",sender.tag);
        [UIView animateWithDuration:0.5 animations:^{
           self.menuScrollView.contentOffset = CGPointMake(self.menuScrollView.frame.size.width *sender.tag, 0);
        }];
        [self selectIconWithTag:sender.tag];
        if (self.selectFinishedCallBack) {
            self.selectFinishedCallBack(nil,sender.tag);
        }
    } else {
     NSLog(@"Btn Click With IndexPath : %@",sender.path.description);
        if (self.selectFinishedCallBack) {
            self.selectFinishedCallBack(sender.path,0);
        }
    }
    
}
- (void)selectIconWithTag:(NSInteger)tag {

    for (UIView *subView in self.iconScrollView.subviews) {
        if ([subView isKindOfClass:[DXMenuBtn class]]) {
            DXMenuBtn *btn = (DXMenuBtn *)subView;
            if (btn.tag == tag) {
                btn.selected = YES;
            }else {
                btn.selected = NO;
            }
        }
    }

}
#pragma mark - ScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {

    if ([scrollView isEqual:self.iconScrollView]) {
        //
        return;
    }
    if ([scrollView isEqual:self.menuScrollView]) {
        NSInteger currentPage = self.menuScrollView.contentOffset.x /self.menuScrollView.frame.size.width;
        
        CGFloat iconW = self.frame.size.width/MenuIconCount;
        
        [ self selectIconWithTag:currentPage];
        NSInteger allPageCount = self.iconScrollView.contentSize.width / iconW;
        if (currentPage - (MenuIconCount/2) < 0 || (currentPage + (MenuIconCount/2)) >  allPageCount -1) {
            
        }else {
            [UIView animateWithDuration:0.5 animations:^{
                self.iconScrollView.contentOffset = CGPointMake(iconW *(currentPage - (MenuIconCount/2)), 0);
            }];

        }
        
        return;
    }
    //子ScrollView 处理逻辑
    NSInteger tag = scrollView.tag;
    for (UIPageControl *pageControl in self.pageControls) {
        if (pageControl.tag == tag) {
            pageControl.currentPage = scrollView.contentOffset.x / scrollView.frame.size.width;
        }
    }
}
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    
    
    
}
#pragma mark - 懒加载

- (UIScrollView *)iconScrollView {

    if (!_iconScrollView) {
        _iconScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height *1.2/4)];
        _iconScrollView.delegate = self;
        _iconScrollView.scrollEnabled = YES;
       // _iconScrollView.pagingEnabled = YES;
        _iconScrollView.showsHorizontalScrollIndicator = NO;
        _iconScrollView.contentSize = CGSizeMake(_iconScrollView.frame.size.width, _iconScrollView.frame.size.height);
        UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(0,_iconScrollView.frame.origin.y + _iconScrollView.frame.size.height - 1, _iconScrollView.frame.size.width, 1)];
        lable.backgroundColor = [UIColor whiteColor];
        
        
        [self addSubview:_iconScrollView];
        
        [self addSubview:lable];
    }
    return _iconScrollView;
}

- (UIScrollView *)menuScrollView {
    if (!_menuScrollView) {
        _menuScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, self.frame.size.height *1.2 /4, self.frame.size.width, self.frame.size.height *2.8/4)];
        _menuScrollView.delegate = self;
        _menuScrollView.pagingEnabled = YES;
        _menuScrollView.scrollEnabled = YES;
        _menuScrollView.showsHorizontalScrollIndicator = NO;
        _menuScrollView.userInteractionEnabled = YES;
        _menuScrollView.contentSize = CGSizeMake(_menuScrollView.frame.size.width, _menuScrollView.frame.size.height);
        [self addSubview:_menuScrollView];
  
    }
    return _menuScrollView;
}
- (NSMutableArray *)pageControls {

    if (!_pageControls) {
        _pageControls = [[NSMutableArray alloc] init];
        
    }
    return _pageControls;
}
@end
