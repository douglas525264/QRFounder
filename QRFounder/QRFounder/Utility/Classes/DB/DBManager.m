//
//  DBManager.m
//  DBManager
//
//  Created by dongxin on 15/7/7.
//  Copyright (c) 2015年 dongxin. All rights reserved.
//

#import "DBManager.h"
#import "DBHelper.h"
#import "NSManagedObject+NSManagedObject_BaseType.h"
#import "DmSearchCriteria.h"


#import "NSDictionary+DXHelper.h"
#define ZAPYAIDF @"zapyaDBManagerQueue"
static DBManager *dbManager;
@implementation DBManager
{
    DBHelper *_helper;
}
+ (DBManager *)shareManager{
    
    if (!dbManager) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            
            dbManager = [[DBManager alloc] init];
            
        });
    }
    return dbManager;
    
}
- (id)init{
    self = [super init];
    if (self) {
        _helper = [DBHelper sharedInstance];
    }
    return self;
}
- (void)saveModel:(id)dataModel{
    
    [self saveModelWithThread:dataModel];
    return;
    
}
- (void)saveModelWithThread:(id)dataModel{
    
    @synchronized(self){
        
        if ([self managerObjWithModel:dataModel]) {
            [self updateModel:dataModel];
            return;
        }
        NSManagedObject *objc;

        if ([dataModel isKindOfClass:[QRModel class]]) {
            // NSManagedObject *objc = ;
            objc = [self createManagerWithModel:dataModel];
            
            [self saveQrModel:dataModel toObject:objc];
            // [_helper saveContext];
            NSLog(@"dataBase has save a User %@",dataModel);
            //  return ;
        }
        
        
        [_helper.managedObjectContext insertObject:objc];
        [_helper saveContext];
        
    }
}
- (void)updateModel:(id)dataModel{
    
    @synchronized(self){
        
        NSManagedObject *objc = [self managerObjWithModel:dataModel];
        if (objc) {
            if ([dataModel isKindOfClass:[QRModel class]]) {
                [self saveQrModel:dataModel toObject:objc];
            }
            
            
            [_helper saveContext];
        }
        //
    }
    
}

- (void)deleteModel:(id)dataModel{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        @synchronized(self){
            NSManagedObject *objc = [self managerObjWithModel:dataModel];
            if(objc){
                [_helper.managedObjectContext deleteObject:objc];
                if ([_helper.managedObjectContext existingObjectWithID:objc.objectID error:nil]){
                    [_helper saveContext];
                    
                }
            }
             // you can do something with object
            else{
                //[_helper.managedObjectContext reset];
            } // object was deleted
        }
    });
    
}
- (void)deleteModels:(NSArray *)models{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        @synchronized(self){
            for (id dataModel in models) {
                NSManagedObject *objc = [self managerObjWithModel:dataModel];
                if (objc) {
                    [_helper.managedObjectContext deleteObject:objc];
                }
                
            }
            [_helper saveContext];
        }
    });
}

//异步执行
- (void)asySaveModel:(id)dataModel {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        @synchronized(self){
            NSManagedObjectContext *context = _helper.privateManageObjectContext;
            NSManagedObject *objc = [self managerObjWithModel:dataModel withContext:context];
            if (objc) {
                if ([dataModel isKindOfClass:[QRModel class]]) {
                    [self saveQrModel:dataModel toObject:objc];
                }
                
                
                
            } else {
                if ([dataModel isKindOfClass:[QRModel class]]) {
                    // NSManagedObject *objc = ;
                    objc = [self createManagerWithModel:dataModel withContext:context];
                    [self saveQrModel:dataModel toObject:objc];
                    
                    NSLog(@"dataBase has save a Task %@",dataModel);
                    // return ;
                }
                [context insertObject:objc];
            }

            [_helper saveWithContext:context];
            
        }
        
        
    });
}
- (void)asyUpdateModel:(id)dataModel{
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        @synchronized(self){
            NSManagedObjectContext *context = _helper.privateManageObjectContext;
            NSManagedObject *objc = [self managerObjWithModel:dataModel withContext:context];
            if (objc) {
                if ([dataModel isKindOfClass:[QRModel class]]) {
                    [self saveQrModel:dataModel toObject:objc];
                }
                
                [_helper saveWithContext:context];
            }
            
        }
        
    });
    
}
- (void)asyDeleteModel:(id)dataModel{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        @synchronized(self) {
            NSManagedObjectContext *context = _helper.privateManageObjectContext;
            NSManagedObject *objc = [self managerObjWithModel:dataModel withContext:context];
            if (objc) {
                [context deleteObject:objc];
                //   [context performBlock:^{
                
                
                //[context detectConflictsForObject:objc];
                [_helper saveWithContext:context];
                // }];
            }
            
        }
    });
    
}
- (void)asyDeleteModels:(NSArray *)models{
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        @synchronized(self) {
            NSManagedObjectContext *context = _helper.privateManageObjectContext;
            for (id dataModel in models) {
                NSManagedObject *objc = [self managerObjWithModel:dataModel withContext:context];
                if (objc) {
                    [context deleteObject:objc];
                    
                }
            }
            //  [context performBlock:^{
            
            [_helper saveWithContext:context];
            
            
            // }];
        }
        
    });
    
}
- (void)asyDeleteModels:(NSArray *)models withFinshedBlock:(void (^)(BOOL isSuccess)) finishedBlock {
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        @synchronized(self) {
            NSManagedObjectContext *context = _helper.privateManageObjectContext;
            for (id dataModel in models) {
                NSManagedObject *objc = [self managerObjWithModel:dataModel withContext:context];
                if (objc) {
                    [context deleteObject:objc];
                    
                }
            }
            //  [context performBlock:^{
            
            BOOL res =  [_helper saveWithContextt:context];
            if (finishedBlock) {
                finishedBlock(res);
            }
            
            // }];
        }
        
    });
    
    
    
}
- (void)getModelWithClass:(Class)clss andCount:(NSInteger)count Offset:(NSInteger)offset ascending:(BOOL) asending withFinishBlock:(void (^)(BOOL isOK,NSArray *resultArr)) finishBlock{
    
   
    if (clss == [QRModel class]) {
        [self getModelWithClass:clss andCount:count Offset:offset ascending:asending andConditions:nil withFinishBlock:finishBlock];
    }
    finishBlock(NO,nil);
    
    
}




- (NSArray *)getModelWithClass:(Class)clss andCount:(NSInteger)count Offset:(NSInteger)offset ascending:(BOOL) asending andConditions:(NSDictionary *)conditions{
    
    DmSearchCriteria *search;
    if (clss == [QRModel class]) {
        search = [[DmSearchCriteria alloc] initWithEntityName:kQrModelTableName];
        [search addOrder:kCreateTime ascending:asending];
    }
    if (conditions) {
        
        for (NSString *key in [conditions allKeys]) {
            NSPredicate *predicate;
            predicate = [NSPredicate predicateWithFormat:@"%K == %d",key,[[conditions objectForKey:key] integerValue]];
            [search addFilter:predicate];
            
        }
        
    }
    
    NSEntityDescription *myen = [NSEntityDescription entityForName:search.entityName inManagedObjectContext:_helper.managedObjectContext];
    
    
    NSFetchRequest *request  =[[NSFetchRequest alloc] init];
    [request setEntity:myen];
    if (count > 0  && offset >= 0) {
        [request setFetchLimit:count];
        [request setFetchOffset:offset];
    }
    
    [search setRequest:request];
    NSArray *arr = [_helper.managedObjectContext executeFetchRequest:request error:nil];
    NSMutableArray *resultArr = [[NSMutableArray alloc] init];
    for (NSManagedObject *objc in arr) {
        if (clss == [QRModel class]) {
            [resultArr addObject:[self qrModelFromManagerObjc:objc]];
        }
    }
    

    
    return resultArr;
}
- (QRModel *)qrModelFromManagerObjc:(NSManagedObject *)objc {

    QRModel *model = [[QRModel alloc] init];
    model.QRStr = [objc valueForKey:kQrStr];
    model.createTime = [objc longValueForKey:kCreateTime];
    model.isScanResult = [[objc valueForKey:kIsScanResult] boolValue];
    return model;
}
- (void )getModelWithClass:(Class)clss andCount:(NSInteger)count Offset:(NSInteger)offset ascending:(BOOL) asending andConditions:(NSDictionary *)conditions withFinishBlock:(void (^)(BOOL isOK,NSArray *resultArr)) finishBlock{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        NSManagedObjectContext *context = _helper.privateManageObjectContext;
        DmSearchCriteria *search;
        if (clss == [QRModel class]) {
            search = [[DmSearchCriteria alloc] initWithEntityName:kQrModelTableName];
            
        }
        [search addOrder:kCreateTime ascending:asending];
        if (conditions) {
            
            for (NSString *key in [conditions allKeys]) {
                NSPredicate *predicate;
                predicate = [NSPredicate predicateWithFormat:@"%K == %d",key,[[conditions objectForKey:key] integerValue]];
                [search addFilter:predicate];
                
            }
            
        }
        
        NSEntityDescription *myen = [NSEntityDescription entityForName:search.entityName inManagedObjectContext:context];
        
        
        NSFetchRequest *request  =[[NSFetchRequest alloc] init];
        [request setEntity:myen];
        if (count > 0  && offset >= 0) {
            [request setFetchLimit:count];
            [request setFetchOffset:offset];
        }
        
        [search setRequest:request];
        NSArray *arr = [context executeFetchRequest:request error:nil];
        NSMutableArray *resultArr = [[NSMutableArray alloc] init];
        for (NSManagedObject *objc in arr) {
            if (clss == [QRModel class]) {
                [resultArr addObject:[self qrModelFromManagerObjc:objc]];
            }
        }
        finishBlock(YES,resultArr);
    });
    
    
    
}

- (NSArray *)getModelWithClass:(Class)clss andCount:(NSInteger)count Offset:(NSInteger)offset ascending:(BOOL) asending{
    
    
    if (clss == [QRModel class]) {
        return [self getModelWithClass:clss andCount:count Offset:offset ascending:asending andConditions:nil];
    }
    
    
    return nil;
    
}
- (NSManagedObject *)managerObjWithModel:(id)dataModel{
    
    @synchronized(self) {
        if ([dataModel isKindOfClass:[QRModel class]]) {
            QRModel *qrmodel = (QRModel *)dataModel;
            DmSearchCriteria *search = [[DmSearchCriteria alloc] initWithEntityName:kQrModelTableName];
            
            [search addFilter:@"%K == %@" key:kCreateTime value:@(qrmodel.createTime)];
            
            NSEntityDescription *myen = [NSEntityDescription entityForName:search.entityName inManagedObjectContext:_helper.managedObjectContext];
            
            NSFetchRequest *request  =[[NSFetchRequest alloc] init];
            [search setRequest:request];
            [request setEntity:myen];
            NSArray *arr = [_helper.managedObjectContext executeFetchRequest:request error:nil];
            if (arr && arr.count > 0) {
                return arr[0];
            }
            
        }
        
        return nil;
    }
    
}
- (NSManagedObject *)managerObjWithModel:(id)dataModel withContext:(NSManagedObjectContext *)context{
    
    @synchronized(self) {
        NSManagedObject *objc;
        if ([dataModel isKindOfClass:[QRModel class]]) {
            QRModel *qrmodel = (QRModel *)dataModel;
            DmSearchCriteria *search = [[DmSearchCriteria alloc] initWithEntityName:kQrModelTableName];
            
            [search addFilter:@"%K == %@" key:kCreateTime value:@(qrmodel.createTime)];
            
            NSEntityDescription *myen = [NSEntityDescription entityForName:search.entityName inManagedObjectContext:context];
            
            NSFetchRequest *request  =[[NSFetchRequest alloc] init];
            [search setRequest:request];
            [request setEntity:myen];
            NSArray *arr = [context executeFetchRequest:request error:nil];
            if (arr && arr.count > 0) {
                return arr[0];
            }
            
        }
        
        
        return objc;
    }
    
}

- (NSManagedObject *)createManagerWithModel:(id)dataModel{
    
    NSManagedObject *objc;
        if ([dataModel isKindOfClass:[QRModel class]]) {
        objc = [NSEntityDescription insertNewObjectForEntityForName:kQrModelTableName inManagedObjectContext:_helper.managedObjectContext];
    }
    
    return objc;
    
}
- (NSManagedObject *)createManagerWithModel:(id)dataModel withContext:(NSManagedObjectContext *)context{
    
    NSManagedObject *objc;
    if ([dataModel isKindOfClass:[QRModel class]]) {
        objc = [NSEntityDescription insertNewObjectForEntityForName:kQrModelTableName inManagedObjectContext:context];
    }
    
    return objc;
    
}


/**
 *  taskModel Interface
 */
/**
 *  User interface
 */
- (void)saveQrModel:(QRModel *)model toObject:(NSManagedObject *)objc {
    [objc setValue:model.QRStr forKey:kQrStr];
    [objc setValue:@(model.createTime) forKey:kCreateTime];
    [objc setValue:@(model.isScanResult) forKey:kIsScanResult];

}


@end
