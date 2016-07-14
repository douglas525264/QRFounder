//
//  DmDatabaseOperation.h
//  zaypa
//
//  Created by cb deng on 12-8-1./Users/dongxin/Desktop/DX/KY/ios/branches/zapya_appstore/zapya/app/Model/DirectoryWatcher.h
//  Copyright (c) 2012年 dewmobile.net. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSManagedObject+NSManagedObject_BaseType.h"
@interface DmDatabaseOperation : NSObject
@property (nonatomic, readonly)NSManagedObjectContext *threadObjectContext;
@property (nonatomic, readonly)NSManagedObjectContext *mainObjectContext;
@property (nonatomic)BOOL waitUntilDone;
@end
