//
//  DmSearchFilter.h
//  zapya
//
//  Created by cb deng on 12-9-14.
//  Copyright (c) 2012年 dewmobile.net. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
@interface DmSearchCriteria : NSObject
{
    NSMutableArray * _orders;
	NSMutableArray * _filters;
    NSString* entityName;
}

@property (nonatomic, copy) NSString* entityName;
@property (nonatomic, readonly) NSArray* orders;
@property (nonatomic, readonly) NSArray* filters;

+ (id)criteria;
- (id)init;
- (id)initWithEntityName:(NSString*)entityName;

- (BOOL)hasOrders;
- (BOOL)hasFilters;

- (void)addOrder:(NSString *)property ascending:(BOOL)ascending;
- (void)addFilter:(NSString *)format key:(NSString *)key value:(id)value;
- (void)addFilter:(NSPredicate *)filter;
- (void)setRequest:(NSFetchRequest *)request;

@end
