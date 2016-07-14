//
//  DBHelper.h
//  DBManager
//
//  Created by dongxin on 15/7/7.
//  Copyright (c) 2015年 dongxin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "NSManagedObject+NSManagedObject_BaseType.h"
#import "DmDatabaseOperation.h"
#import <UIKit/UIKit.h>

UIKIT_EXTERN NSString * const kQrStr;
UIKIT_EXTERN NSString * const kCreateTime;
UIKIT_EXTERN NSString * const kIsScanResult;
UIKIT_EXTERN NSString * const kQrModelTableName;

@interface DBHelper : NSObject
@property (nonatomic, retain, readonly)NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong, readonly)NSManagedObjectContext *privateManageObjectContext;
@property (nonatomic, retain, readonly)NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readonly)NSPersistentStoreCoordinator *persistentStoreCoordinator;

+ (DBHelper *)sharedInstance;
+ (NSString *)getStorePath;
- (void)saveContext;
- (void)saveWithContext:(NSManagedObjectContext *)context;
- (BOOL)saveWithContextt:(NSManagedObjectContext *)context;
@end
