//
//  DmDatabaseOperation.m
//  zaypa
//
//  Created by cb deng on 12-8-1.
//  Copyright (c) 2012年 dewmobile.net. All rights reserved.
//

#import "DmDatabaseOperation.h"
#import "DBHelper.h"


@implementation DmDatabaseOperation
@synthesize threadObjectContext = _threadObjectContext;

- (id)init {
    if (self = [super init]) {
        _waitUntilDone = NO;
    }
    return self;
}

- (NSManagedObjectContext *)threadObjectContext
{
    if (_threadObjectContext != nil) {
        return _threadObjectContext;
    }
    DBHelper *helper = [DBHelper sharedInstance];
    _mainObjectContext = helper.managedObjectContext;
    _threadObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    [_threadObjectContext setPersistentStoreCoordinator:helper.persistentStoreCoordinator];
    
    [_threadObjectContext setStalenessInterval:0.0];
    [_threadObjectContext setMergePolicy:NSMergeByPropertyStoreTrumpMergePolicy];
    
    // Add context save observer
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(mergeContextChangesForNotification:)
                                                 name:NSManagedObjectContextDidSaveNotification
                                               object:_threadObjectContext];

    return _threadObjectContext;
}

- (void)mergeOnMainThread:(NSNotification *)aNotification
{
    [_mainObjectContext mergeChangesFromContextDidSaveNotification:aNotification];
}

- (void)mergeContextChangesForNotification:(NSNotification *)aNotification
{
    if (aNotification.object != _mainObjectContext) {
        [self performSelectorOnMainThread:@selector(mergeOnMainThread:) withObject:aNotification waitUntilDone:_waitUntilDone];
    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:NSManagedObjectContextDidSaveNotification
                                                  object:_threadObjectContext];
}

@end
