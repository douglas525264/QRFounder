//
//  DBHelper.m
//  DBManager
//
//  Created by dongxin on 15/7/7.
//  Copyright (c) 2015年 dongxin. All rights reserved.
//

#import "DBHelper.h"
#pragma mark -
#pragma Database Table and column define
NSString * const kDataManagerBundleName = @"qrfounder";
NSString * const kDataManagerModelName = @"QRdatabase";
NSString * const kDataManagerSQLiteName = @"qrfounder.sqlite";


//透传消息存储
// User Key-Value Table
NSString * const kQrModelTableName = @"QRModel";
NSString * const kQrStr = @"qrstr";
NSString * const kCreateTime = @"createtime";
NSString * const kIsScanResult = @"isscanresult";


static DBHelper *sharedInstance = nil;
@implementation DBHelper
@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;
@synthesize privateManageObjectContext = _privateManageObjectContext;
+ (DBHelper *)sharedInstance{

    static dispatch_once_t pred;
    if (!sharedInstance) {
    dispatch_once(&pred, ^{
        sharedInstance = [[self alloc] init];
    });
    }
    return sharedInstance;
}
+ (NSString *)getStorePath{
    
    return [NSString stringWithFormat:@"%@/%@",[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"],kDataManagerSQLiteName];
}
- (NSManagedObjectContext*)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    // Create the main context only on the main thread
    if (![NSThread isMainThread]) {
        [self performSelectorOnMainThread:@selector(managedObjectContext) withObject:nil waitUntilDone:YES];
        return _managedObjectContext;
    }
    
    // Create store
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSConfinementConcurrencyType];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
        _managedObjectContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy;
    }
    
    // Add context save observer
    //    [[NSNotificationCenter defaultCenter] addObserver:self
    //                                             selector:@selector(mergeContextChangesForNotification:)
    //                                                 name:NSManagedObjectContextDidSaveNotification
    //                                               object:nil];
    
    return _managedObjectContext;
}
- (void)mergeOnMainThread:(NSNotification *)aNotification
{
    @try {
        [_managedObjectContext mergeChangesFromContextDidSaveNotification:aNotification];
    }
    @catch (NSException *exception) {
        NSLog(@"merge db failed:%@", exception);
    }
}

- (void)mergeContextChangesForNotification:(NSNotification *)aNotification
{
    if (aNotification.object != _managedObjectContext) {
        [self performSelectorOnMainThread:@selector(mergeOnMainThread:) withObject:aNotification waitUntilDone:YES];
    }
}

// Returns the managed object model for the application.
// If the model does't already exist, it is created bymering all the models found in the application bundle.
//
- (NSManagedObjectModel*)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    
    NSURL *momURL = [[NSBundle mainBundle] URLForResource:kDataManagerModelName withExtension:@"momd"];
    
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:momURL];
    return _managedObjectModel;
}

// Returns the persisten store
// If the store does't exist, it is created kuaiya.sqlite for save.
//
- (NSPersistentStoreCoordinator*)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSString *storePath = [[self class] getStorePath];
    
    // set up the backing store
    NSFileManager *fileManager = [NSFileManager defaultManager];
    // If the expected store doesn't exist, copy the default store.
    // Use this for the default database and data.
    if (![fileManager fileExistsAtPath:storePath]) {
        NSString *defaultStorePath = [[NSBundle mainBundle] pathForResource:kDataManagerBundleName ofType:@"sqlite"];
        if (defaultStorePath) {
            [fileManager copyItemAtPath:defaultStorePath toPath:storePath error:NULL];
        }else {
            
            NSString *dirPatn = [storePath substringToIndex:[storePath rangeOfString:[storePath lastPathComponent]].location];
            [fileManager createDirectoryAtPath:dirPatn withIntermediateDirectories:YES attributes:nil error:nil];
            [fileManager createFileAtPath:storePath contents:nil attributes:nil];

        }
    }
    
    NSURL *storeUrl = [NSURL fileURLWithPath:storePath];
    
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
                             [NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption,
                             [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
    
    NSError *error;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType
                                                   configuration:nil
          
                                                             URL:storeUrl
                                                         options:options
                                                           error:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes t he application to generate a crash log and terminate.
        // You should not use this function in a shipping application, although it may be useful
        // during development. if it is not possible to recover from error, display an alert panel
        // that instruvts the user to quit the application by oressing the home button.
        //
        
        // Typical reasons for error here include:
        // The persistent store is not accesible
        // the schema for the persistent store is incompatible with current managed object model
        // check the error message to determine what the actaul problem was.
        //
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
    }
    
    return _persistentStoreCoordinator;
}
- (void)saveContext{
  //  dispatch_async(dispatch_get_main_queue(), ^{
        NSError *error = nil;
    @try {
            if ([self.managedObjectContext hasChanges] && ![self.managedObjectContext save:&error]) {
                
                NSLog(@"DataBase save error :%@",error.debugDescription);
             //   abort();
            }
        }
    @catch (NSException *exception) {
        NSLog(@"ex : %@",exception.debugDescription);
    }
    @finally {
        
    }
}
- (void)saveWithContext:(NSManagedObjectContext *)context {
     NSError *error = nil;
    [context tryLock];
    if ([context hasChanges] && ![context save:&error]) {
        
        NSLog(@"DataBase save error :%@",error.debugDescription);
        [context reset];
        //  abort();
    
    }
    [context unlock];
}
- (BOOL)saveWithContextt:(NSManagedObjectContext *)context {
    NSError *error = nil;
    BOOL result ;
    [context tryLock];
    if ([context hasChanges] && ![context save:&error]) {
        
        NSLog(@"DataBase save error :%@",error.debugDescription);
        [context reset];
        result = YES;
        //  abort();
        
    }else {
    NSLog(@"DataBase save error :%@",error.debugDescription);
        result = NO;
    }
    [context unlock];
    return result;
}

- (NSManagedObjectContext *)privateManageObjectContext {
    if (!_privateManageObjectContext) {
        _privateManageObjectContext = [[NSManagedObjectContext alloc] init];
        
        [_privateManageObjectContext setPersistentStoreCoordinator:self.persistentStoreCoordinator];
        [_privateManageObjectContext setStalenessInterval:0.0];
        [_privateManageObjectContext setMergePolicy:NSMergeByPropertyStoreTrumpMergePolicy];
        
    }
    return _privateManageObjectContext;
    
}
- (void)dealloc {
    //    [[NSNotificationCenter defaultCenter] removeObserver:self
    //                                                    name:NSManagedObjectContextDidSaveNotification
    //                                                  object:nil];
}

@end
