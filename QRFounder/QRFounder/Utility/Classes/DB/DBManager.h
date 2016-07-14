//
//  DBManager.h
//  DBManager
//
//  Created by dongxin on 15/7/7.
//  Copyright (c) 2015年 dongxin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "QRModel.h"
@interface DBManager : NSObject
+ (DBManager *)shareManager;


//同步执行

- (void)saveModel:(id)dataModel;
- (void)updateModel:(id)dataModel;
- (void)deleteModel:(id)dataModel;
- (void)deleteModels:(NSArray *)models;

- (NSArray *)getModelWithClass:(Class)clss andCount:(NSInteger)count Offset:(NSInteger)offset ascending:(BOOL) asending;

//异步执行
- (void)asySaveModel:(id)dataModel;

//EXT
- (void)asyDeleteModels:(NSArray *)models withFinshedBlock:(void (^)(BOOL isSuccess)) finishedBlock;
- (void)asyUpdateModel:(id)dataModel;
- (void)asyDeleteModel:(id)dataModel;
- (void)asyDeleteModels:(NSArray *)models;

- (void)getModelWithClass:(Class)clss andCount:(NSInteger)count Offset:(NSInteger)offset ascending:(BOOL) asending withFinishBlock:(void (^)(BOOL isOK,NSArray *resultArr)) finishBlock;

@end
