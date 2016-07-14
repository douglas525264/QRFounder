//
//  NSManagedObject+NSManagedObject_BaseType.m
//  DBManager
//
//  Created by dongxin on 15/7/7.
//  Copyright (c) 2015年 dongxin. All rights reserved.
//

#import "NSManagedObject+NSManagedObject_BaseType.h"

@implementation NSManagedObject (NSManagedObject_BaseType)
- (int)intValueForKey:(NSString *)key
{
    NSNumber *number = [self valueForKey:key];
    if (number) {
        return [number intValue];
    }
    return 0;
}

- (void)setIntValue:(int)value forKey:(NSString *)key
{
    [self setValue:[NSNumber numberWithInt:value] forKey:key];
}

- (long)longValueForKey:(NSString *)key
{
    NSNumber *number = [self valueForKey:key];
    if (number) {
        return [number longValue];
    }
    return 0;
}

- (int64_t)int64ValueForKey:(NSString *)key
{
    NSNumber *number = [self valueForKey:key];
    if (number) {
        return [number longLongValue];
    }
    return 0;
}

- (double)doubleValueForKey:(NSString *)key
{
    NSNumber *number = [self valueForKey:key];
    if (number) {
        return [number doubleValue];
    }
    return 0.0;
}

- (void)setLongValue:(long)value forKey:(NSString *)key
{
    [self setValue:[NSNumber numberWithLong:value] forKey:key];
}

- (void)setInt64Value:(int64_t)value forKey:(NSString *)key
{
    [self setValue:[NSNumber numberWithLongLong:value] forKey:key];
}

- (void)setFloatValue:(float)value forKey:(NSString *)key
{
    [self setValue:[NSNumber numberWithFloat:value] forKey:key];
}

- (void)setDoubleValue:(double)value forKey:(NSString *)key
{
    [self setValue:[NSNumber numberWithDouble:value] forKey:key];
}

- (float)floatValueForKey:(NSString *)key
{
    NSNumber *number = [self valueForKey:key];
    if (number) {
        return number.floatValue;
    }
    return 0.0;
}
@end
