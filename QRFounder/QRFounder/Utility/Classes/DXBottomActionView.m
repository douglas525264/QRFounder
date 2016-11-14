//
//  DXBottomActionView.m
//  QRFounder
//
//  Created by douglas on 16/7/19.
//  Copyright © 2016年 dongxin. All rights reserved.
//

#import "DXBottomActionView.h"
#define maxlinCount 3
#define smallWidth 30
#define oneLineHeight 49
@interface DXBottomActionView()
@property (nonatomic, strong) UIView *sLine;
@end
@implementation DXBottomActionView
+ (DXBottomActionView *)popWithCommendArr:(NSArray *)arr andBlock:(void (^)(DXBottomActionView *bpc,DXBottomActionMenu command)) block {

    DXBottomActionView *result = [[DXBottomActionView alloc] initWithcommendArr:arr];
    result.callBackWithCommand = block;
    result.frame = CGRectMake(0, 0, [[UIApplication sharedApplication] keyWindow].frame.size.width, 49);
    [result configWithArr:arr];
    return result;
}
- (DXBottomActionView *)initWithcommendArr:(NSArray *)commendArr {

    self = [super init];
    if (self) {
        self.commendArr = [NSMutableArray arrayWithArray:commendArr];
        [self addSubview:self.sLine];
    }
    return self;
}
- (void)configWithArr:(NSArray *)arr {
    NSInteger i = 0;
    NSInteger j = 0;
    NSInteger tem = arr.count - j * 3 - i;
    NSInteger lineCount =  tem/3 > 0 ? 3 : tem;
    for (NSNumber *com in arr) {

        
        CGFloat w = self.frame.size.width/lineCount;
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(i * w , j * oneLineHeight, w, oneLineHeight);
        btn.tag = [com integerValue];
        [btn setTitle:[self getTitleWithCommend:[com integerValue]] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(commendbtnClick:) forControlEvents:UIControlEventTouchUpInside];
        if (i >= lineCount) {
            i = 0;
            j++;
            tem = arr.count - j * 3 - i;
            lineCount =  tem/3 > 0 ? 3 : tem;

        } else {
            
            i++;
        }
        [self addSubview:btn];
    }

}
- (NSString *)getTitleWithCommend:(DXBottomActionMenu)commend {

    switch (commend) {
        case DXBottomActionMenuSelectAll:
            return @"全选";
            break;
        case DXBottomActionMenuNOTSelectAll:
            return @"全不选";
            break;
        case DXBottomActionMenuDelete:
            return @"删除";
            break;
        default:{
            return nil;
        }break;
    }
}
- (CGFloat)getheightWithWidth{

    NSInteger lineCount = self.commendArr.count/3;
    lineCount += (self.commendArr.count%3) > 0 ? 1 : 0;
    return lineCount * oneLineHeight;
}
- (void)commendbtnClick:(UIButton *)sender {

    if (self.callBackWithCommand) {
        self.callBackWithCommand(self,sender.tag);
    }
}
- (void)setCount:(NSInteger)count {

    _count = count;
    for (UIView *subView in self.subviews) {
        if ([subView isKindOfClass:[UIButton class]] && subView.tag == DXBottomActionMenuDelete) {
            UIButton *deleteBtn = (UIButton *)subView;
            if (count > 0) {
               [deleteBtn setTitle:[NSString stringWithFormat:@"%@(%ld)",[self getTitleWithCommend:DXBottomActionMenuDelete],count] forState:UIControlStateNormal];
            } else {
                [deleteBtn setTitle:[self getTitleWithCommend:DXBottomActionMenuDelete] forState:UIControlStateNormal];
            }
        }
        if ([subView isKindOfClass:[UIButton class]]
            &&subView.tag == DXBottomActionMenuSelectAll
            && count == self.allcount
            && self.allcount > 0) {
            
            UIButton *selectBtn = (UIButton *)subView;
            selectBtn.tag = DXBottomActionMenuNOTSelectAll;
            [selectBtn setTitle:[self getTitleWithCommend:DXBottomActionMenuNOTSelectAll] forState:UIControlStateNormal];
        }
        if ([subView isKindOfClass:[UIButton class]] && subView.tag == DXBottomActionMenuNOTSelectAll  && count < self.allcount && self.allcount > 0) {
            UIButton *selectBtn = (UIButton *)subView;
            selectBtn.tag = DXBottomActionMenuSelectAll;
            [selectBtn setTitle:[self getTitleWithCommend:DXBottomActionMenuSelectAll] forState:UIControlStateNormal];
        }

    }
}
- (void)reloadUI{


}
- (void)show {
    
    CGFloat height = [self getheightWithWidth];
    UIView *view = [[UIApplication sharedApplication].windows lastObject];
    self.frame = CGRectMake(0, view.frame.size.height, view.frame.size.width, height);
    [view addSubview:self];
    [UIView animateWithDuration:0.3 animations:^{
        self.frame = CGRectMake(0, view.frame.size.height - height, view.frame.size.width, height);
    }];
}

- (void)showInView:(UIView *)view {
    
    CGFloat height = [self getheightWithWidth];
    if (height == 0) {
        height = 49;
    }
    self.frame = CGRectMake(0,  view.frame.size.height, view.frame.size.width, height);
    [view addSubview:self];
    [UIView animateWithDuration:0.3 animations:^{
        self.frame = CGRectMake(0, view.frame.size.height - height, view.frame.size.width, height);
        //[view bringSubviewToFront:self];
    }];
}
- (void)dismisswithAnimation:(BOOL)animation {
    UIView *view = self.superview;
    CGFloat height = self.frame.size.height;
    if (animation) {
        
        
        [UIView animateWithDuration:0.3 animations:^{
            
            self.frame = CGRectMake(0, view.frame.size.height, view.frame.size.width, height);
            
            
        } completion:^(BOOL finished) {
            [self removeFromSuperview];
        }];
  
    } else {
        self.frame = CGRectMake(0, view.frame.size.height, view.frame.size.width, height);
        [self removeFromSuperview];
        
    }
}
- (UIView *)sLine {
    if (!_sLine) {
        _sLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 1)];
        _sLine.backgroundColor = [UIColor whiteColor];
        _sLine.alpha = 0.6;
        _sLine.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    }
    return _sLine;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
