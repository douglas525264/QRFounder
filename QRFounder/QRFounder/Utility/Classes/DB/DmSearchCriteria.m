//
//  DmSearchFilter.m
//  zapya
//
//  Created by cb deng on 12-9-14.
//  Copyright (c) 2012年 dewmobile.net. All rights reserved.
//

#import "DmSearchCriteria.h"

@implementation DmSearchCriteria
@synthesize entityName;
@synthesize orders;
@synthesize filters;

+ (id)criteria
{
    DmSearchCriteria* criteria = [[DmSearchCriteria alloc] init];
    return criteria;
}

-(id) init {	
	if (!(self = [self initWithEntityName:nil])) {
		
	}
    
	return self;
}

-(id) initWithEntityName:(NSString*)theEntityName {
	if (self = [super init]) {
		self.entityName = theEntityName;
	}
	
	return self;
}

-(void)dealloc {
	entityName = nil;
	_orders = nil;
	_filters = nil;
}

- (BOOL)hasOrders
{
    return [_orders count] > 0;
}

- (BOOL)hasFilters
{
    return [_filters count] > 0;
}

- (void)addOrder:(NSString *)property ascending:(BOOL)ascending
{
    NSSortDescriptor* sort = [[NSSortDescriptor alloc] initWithKey:property ascending:ascending];
    if (_orders == nil) {
        _orders = [[NSMutableArray alloc] init];
    }
    [_orders addObject:sort];
}

- (void)addFilter:(NSString *)format key:(NSString *)key value:(id)value
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:format, key, value];
    if (_filters == nil) {
        _filters = [[NSMutableArray alloc] init];
    }
    [_filters addObject:predicate];
}
- (void)addFilter:(NSPredicate *)filter{

    if (_filters == nil) {
        _filters = [[NSMutableArray alloc] init];
    }
    [_filters addObject:filter];

}
- (void)setRequest:(NSFetchRequest *)request
{	
	if ([self hasOrders]) {
		[request setSortDescriptors:_orders];
	}
	
	if ([self hasFilters]) {
		NSPredicate* compoudPredicate = [NSCompoundPredicate andPredicateWithSubpredicates:_filters];
		[request setPredicate:compoudPredicate];
	}    
}

@end
