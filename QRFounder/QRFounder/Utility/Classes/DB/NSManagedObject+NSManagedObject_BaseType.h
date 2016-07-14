//
//  NSManagedObject+NSManagedObject_BaseType.h
//  DBManager
//
//  Created by dongxin on 15/7/7.
//  Copyright (c) 2015年 dongxin. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface NSManagedObject (NSManagedObject_BaseType)
// KVC - overridden to access generic dictionary storage unless subclasses explicitly provide accessors
- (int)intValueForKey:(NSString *)key;

// KVC - overridden to access generic dictionary storage unless subclasses explicitly provide accessors
- (void)setIntValue:(int)value forKey:(NSString *)key;

// KVC - overridden to access generic dictionary storage unless subclasses explicitly provide accessors
- (long)longValueForKey:(NSString *)key;

// KVC - overridden to access generic dictionary storage unless subclasses explicitly provide accessors
- (void)setLongValue:(long)value forKey:(NSString *)key;

// KVC - overridden to access generic dictionary storage unless subclasses explicitly provide accessors
- (void)setFloatValue:(float)value forKey:(NSString *)key;

// KVC - overridden to access generic dictionary storage unless subclasses explicitly provide accessors
- (float)floatValueForKey:(NSString *)key;

- (void)setInt64Value:(int64_t)value forKey:(NSString *)key;

- (void)setDoubleValue:(double)value forKey:(NSString *)key;
- (double)doubleValueForKey:(NSString *)key;
- (int64_t)int64ValueForKey:(NSString *)key;
@end
