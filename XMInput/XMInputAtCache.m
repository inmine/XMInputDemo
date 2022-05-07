//
//  XMInputAtCache.m
//  XMInputDemo
//
//  Created by XM on 2022/5/6.
//

#import "XMInputAtCache.h"

@implementation XMInputAtCache

- (instancetype)init {
    self = [super init];
    if (self) {
        _items = [[NSMutableArray alloc] init];
    }
    return self;
}

- (NSArray *)allAtUid:(NSString *)sendText {
    NSMutableArray *uids = [[NSMutableArray alloc] init];
    for (XMInputAtItem *item in self.items) {
        if ([sendText containsString:item.atName]) {
            [uids addObject:item.uid];
        }
    }
    
    return [NSArray arrayWithArray:uids];
}

- (void)clean {
    [self.items removeAllObjects];
}

- (void)insertAtItem:(XMInputAtItem *)item atIndex:(NSInteger)atIndex{
    [_items insertObject:item atIndex:atIndex];
}

- (void)addAtItem:(XMInputAtItem *)item {
    [_items addObject:item];
}

- (XMInputAtItem *)item:(NSString *)name {
    __block XMInputAtItem *item;
    [_items enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        XMInputAtItem *object = obj;
        if ([object.name isEqualToString:name]) {
            item = object;
            *stop = YES;
        }
    }];
    
    return item;
}

- (void)removeIndex:(NSInteger)index{
    if (index < _items.count) {
        [_items removeObjectAtIndex:index];
    }
}

- (XMInputAtItem *)removeName:(NSString *)name {
    __block XMInputAtItem *item;
    [_items enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        XMInputAtItem *object = obj;
        if ([object.name isEqualToString:name]) {
            item = object;
            *stop = YES;
        }
    }];
    
    if (item) {
        [_items removeObject:item];
    }
    
    return item;
}

@end
