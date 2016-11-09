//
//  QRPointModel.m
//  QRFounder
//
//  Created by douglas on 2016/11/7.
//  Copyright © 2016年 dongxin. All rights reserved.
//

#import "QRPointModel.h"
@interface QRPointModel()
@property (nonatomic, strong) NSMutableArray *pointArr;
@property (nonatomic, strong) NSMutableArray *resultArr;
@property (nonatomic, assign) NSInteger width;
@property (nonatomic, assign) NSInteger boardWidth;
@property (nonatomic, assign) CGFloat oneWidth;
@end
@implementation QRPointModel
-(id)initWithQRCode:(QRcode *)code diyModel:(DIYModel *)diymodel andSize:(CGFloat)size isChangeBlack:(BOOL)isChange {

    self = [super init];
    if (self) {
        self.code = code;
        self.size = size;
        self.diymodel = diymodel;
        unsigned char *data = 0;
        int width;
        self.isChangeBlack = isChange;
        data = code->data;
        width = code->width;
        self.width = width + 2;
        self.boardWidth = 0;
        BOOL hasEnd = NO;
        NSMutableString *str = [[NSMutableString alloc] init];
        for(int i = 0; i < self.width; ++i) {
            for(int j = 0; j < self.width; ++j) {
                QROnePoint *point = [[QROnePoint alloc] init];
                
                if ((i == 0) || (j == 0) || (i == (width + 1)) || (j == (width + 1))) {
                    point.isBlack = self.isChangeBlack;
                } else {
                    if(*data & 1) {
                        
                        point.isBlack = !self.isChangeBlack;
                        if (!hasEnd) {
                            self.boardWidth ++;
                        }
                    }else {
                        
                        hasEnd = YES;
                        point.isBlack = self.isChangeBlack;
                    }
                    
                    ++data;
                }
                point.position = [NSIndexPath indexPathForRow:j inSection:i];
                //[str appendFormat:@"(%ld,%ld)",i,j];
                point.isInUse = NO;
                [self.pointArr addObject:point];
            }
            
        }
        for(int i = 0; i < self.width; ++i) {
            for(int j = 0; j < self.width; ++j) {
                QROnePoint *testPoint = self.pointArr[i * (self.width) + j];
                if (testPoint.isBlack) {
                    [str appendString:@"1 "];
                }else {
                    [str appendString:@"0 "];
                }
            }
            [str appendFormat:@"\n "];
        }
        NSLog(str);
        
        self.oneWidth = size/self.width;
        if (self.isChangeBlack) {
         // self.width += 2;
          self.qr_margin = 0;
          self.boardWidth += 2;
        }else {
            self.qr_margin = 1;
        }
        
        
        
        
    }
    return self;

}
-(id)initWithQRCode:(QRcode *)code diyModel:(DIYModel *)diymodel andSize:(CGFloat)size {
    return  [self initWithQRCode:code diyModel:diymodel andSize:size isChangeBlack:NO];
}
- (NSArray *)getResultArr {
    
    //Boarder
    self.diymodel.boarderModel.size = CGSizeMake(self.boardWidth, self.boardWidth);
    QRResultPoint *b1 = [[QRResultPoint alloc] init];
    b1.image = self.diymodel.boarderModel.image;
    b1.frame = CGRectMake(self.qr_margin * self.oneWidth, self.qr_margin * self.oneWidth, self.boardWidth * self.oneWidth, self.boardWidth * self.oneWidth);
    QROnePoint *bp1 = [[QROnePoint alloc] init];
    if (self.isChangeBlack) {
       bp1.position = [NSIndexPath indexPathForRow:0 inSection:0];
    } else {
       bp1.position = [NSIndexPath indexPathForRow:1 inSection:1];
    }
    
    [self markPoint:bp1 withDIYItem:self.diymodel.boarderModel status:1];
    
    
    
    QRResultPoint *b2 = [[QRResultPoint alloc] init];
    b2.image = self.diymodel.boarderModel.image;
    b2.frame = CGRectMake((self.width - self.qr_margin - self.boardWidth)* self.oneWidth, self.qr_margin * self.oneWidth, self.boardWidth * self.oneWidth, self.boardWidth * self.oneWidth);
    QROnePoint *bp2 = [[QROnePoint alloc] init];
    if (self.isChangeBlack) {
        bp2.position = [NSIndexPath indexPathForRow:self.width - self.boardWidth inSection:0];
    } else {
        bp2.position = [NSIndexPath indexPathForRow:self.width - self.boardWidth - self.qr_margin inSection:1];
    }
    
    [self markPoint:bp2 withDIYItem:self.diymodel.boarderModel status:1];
    
    QRResultPoint *b3 = [[QRResultPoint alloc] init];
    b3.image = self.diymodel.boarderModel.image;
    b3.frame = CGRectMake(self.qr_margin * self.oneWidth, (self.width - self.qr_margin - self.boardWidth) * self.oneWidth, self.boardWidth * self.oneWidth, self.boardWidth * self.oneWidth);
    QROnePoint *bp3 = [[QROnePoint alloc] init];
    if (self.isChangeBlack) {
      bp3.position = [NSIndexPath indexPathForRow:0 inSection:self.width - self.boardWidth];
    } else {
      bp3.position = [NSIndexPath indexPathForRow:1 inSection:self.width - self.boardWidth - self.qr_margin];
    }
    
    [self markPoint:bp3 withDIYItem:self.diymodel.boarderModel status:1];
    
    [self.resultArr addObject:b1];
    [self.resultArr addObject:b2];
    [self.resultArr addObject:b3];
    
    //item 由大到小
    NSMutableArray *items = [[NSMutableArray alloc] initWithArray:self.diymodel.itemArrays];
    [items sortUsingComparator:^NSComparisonResult(DIYSubModel *obj1, DIYSubModel *obj2) {
        return obj1.sizeCount < obj2.sizeCount;
    }];
    NSInteger count = self.pointArr.count;
    for (DIYSubModel *subModel in items) {
        @autoreleasepool {
            NSMutableArray *willUseArr = [[NSMutableArray alloc] init];
            NSMutableArray *lastUseArr = [[NSMutableArray alloc] init];
            
            for (QROnePoint *one in self.pointArr) {
                if (one.isBlack && !one.isInUse && !one.willInUse) {
                    if ([self isOKinPoint:one withDIYItem:subModel]) {
                        [willUseArr addObject:one];
                        [self markPoint:one withDIYItem:subModel status:0];
                    } else {
                    
                    }
                }
            }
            
            NSInteger preCount = count * subModel.probability/subModel.sizeCount;
            if (preCount < willUseArr.count) {
                
                if (subModel.sizeCount >= 4 && willUseArr.count > 0) {
                    
                    NSInteger index = 0;
                    while (lastUseArr.count < preCount) {
                        
                        NSInteger middleIndex = willUseArr.count/2;
                        QROnePoint *pp = willUseArr[middleIndex];
                        [lastUseArr addObject:pp];
                        [self markPoint:pp withDIYItem:subModel status:1];
                        
                        [willUseArr removeObject:pp];
                        if (lastUseArr.count == preCount) {
                            break;
                        }
                        QROnePoint *pp1 = willUseArr.firstObject;
                        [lastUseArr addObject:pp1];
                        [self markPoint:pp1 withDIYItem:subModel status:1];
                        
                        [willUseArr removeObject:pp1];
                        if (lastUseArr.count == preCount) {
                            break;
                        }
                        QROnePoint *pp2 = willUseArr.lastObject;
                        [lastUseArr addObject:pp2];
                        [self markPoint:pp2 withDIYItem:subModel status:1];
                        
                        [willUseArr removeObject:pp2];
                        if (lastUseArr.count == preCount) {
                            break;
                        }


                        
                        
                        index ++;
                    }
                    for (QROnePoint  *currentP in willUseArr) {
//                        if (lastUseArr.count < preCount) {
//                            [lastUseArr addObject:currentP];
//                            [self markPoint:currentP withDIYItem:subModel status:1];
//                            
//                        } else {
                            [self markPoint:currentP withDIYItem:subModel status:3];
                        //}
                    }

//                    NSInteger middleIndex = willUseArr.count/2;
//                    QROnePoint *pp = willUseArr[middleIndex];
//                    [lastUseArr addObject:pp];
//                    [self markPoint:pp withDIYItem:subModel status:1];
//                    
//                    [willUseArr removeObject:pp];
//                    
//                    [willUseArr sortUsingComparator:^NSComparisonResult(QROnePoint  *obj1, QROnePoint  *obj2) {
//                        return [obj1 disWithOtherpoint:pp] < [obj2 disWithOtherpoint:pp];
//                    }];
//                    for (QROnePoint  *currentP in willUseArr) {
//                        if (lastUseArr.count < preCount) {
//                            [lastUseArr addObject:currentP];
//                            [self markPoint:currentP withDIYItem:subModel status:1];
// 
//                        } else {
//                        [self markPoint:currentP withDIYItem:subModel status:3];
//                        }
//                    }
                } else {

                NSInteger more = willUseArr.count - preCount;
                NSInteger tag = more/preCount;
                if (tag < 1) {
                    tag = 1;
                }
                tag +=1;
                NSInteger nextRecord = 0;
                for (NSInteger j = 0; j < willUseArr.count; j++) {
                    QROnePoint  *currentPoint = willUseArr[j];
                    if (j == nextRecord) {
                        nextRecord += tag;
                        
                        [lastUseArr addObject:currentPoint];
                         [self markPoint:currentPoint withDIYItem:subModel status:1];
                    } else {
                        [self markPoint:currentPoint withDIYItem:subModel status:3];
                    }

                }
                }
                
            } else {
            
                for (QROnePoint *two in willUseArr) {
                    [self markPoint:two withDIYItem:subModel status:1];
                    [lastUseArr addObject:two];
                }
            }
            
            
            for (QROnePoint *last in lastUseArr) {
                QRResultPoint *bx = [[QRResultPoint alloc] init];
                bx.image = subModel.image;
                bx.frame = CGRectMake((last.position.row) * self.oneWidth, (last.position.section) * self.oneWidth, subModel.size.width * self.oneWidth, subModel.size.height * self.oneWidth);
                [self.resultArr addObject:bx];

            }
           // break;
            
        }
    }
    return self.resultArr;
}

- (BOOL)isOKinPoint:(QROnePoint *)onePoint withDIYItem:(DIYSubModel *)diyItem {
    BOOL result = YES;
    
    if (onePoint.position.section +diyItem.size.height > (self.width)) {
        return NO;
    }
    if (onePoint.position.row +diyItem.size.width > (self.width)) {
        return NO;
    }
    for (NSInteger i = onePoint.position.section; i < onePoint.position.section +diyItem.size.height; i++) {
        for (NSInteger j = onePoint.position.row; j < onePoint.position.row +diyItem.size.width; j++) {
            
            NSInteger index = i * (self.width) + j;
            
            QROnePoint *model = self.pointArr[index];
            if (model.isBlack && !model.isInUse && !model.willInUse) {
                
            }else {
                return NO;
            }
        }
    }
    return result;
    
}
- (void)markPoint:(QROnePoint *)onePoint withDIYItem:(DIYSubModel *)diyItem status:(NSInteger)status {
    
    for (NSInteger i = onePoint.position.section; i < onePoint.position.section + diyItem.size.height; i++) {
        for (NSInteger j = onePoint.position.row; j < onePoint.position.row + diyItem.size.width; j++) {
            QROnePoint *model = self.pointArr[i * self.width + j];
            switch (status) {
                case 0:{
                    model.willInUse = YES;
                }break;
                case 1:{
                    model.isInUse = YES;
                }break;
                    
                default:
                    model.willInUse = NO;
                    break;
            }
        }
    }
}
- (NSMutableArray *)pointArr {

    if (!_pointArr) {
        _pointArr = [[NSMutableArray alloc] init];
    }
    return _pointArr;
}
- (NSMutableArray *)resultArr {
    if (!_resultArr) {
        _resultArr = [[NSMutableArray alloc] init];
    }
    return _resultArr;
}

@end

@implementation QROnePoint
- (CGFloat)disWithOtherpoint:(QROnePoint *)point {
    double k = ldexp((point.position.section - self.position.section), 1);
    return [self longWithWidth:(point.position.section - self.position.section) andHigh:(point.position.row - self.position.row)];
}
- (double)longWithWidth:(CGFloat) width andHigh:(CGFloat)high {

    return sqrt(ldexp(width, 1) + ldexp(high, 1));
}
@end
@implementation QRResultPoint

@end
