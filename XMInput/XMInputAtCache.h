//
//  XMInputAtCache.h
//  XMInputDemo
//
//  Created by XM on 2022/5/6.
//

#import <Foundation/Foundation.h>
#import "XMInputAtItem.h"

NS_ASSUME_NONNULL_BEGIN

@interface XMInputAtCache : NSObject

@property (nonatomic, strong) NSMutableArray<XMInputAtItem *> *items;

- (NSArray *)allAtUid:(NSString *)sendText;

- (void)clean;

- (void)insertAtItem:(XMInputAtItem *)item atIndex:(NSInteger)atIndex;

- (void)addAtItem:(XMInputAtItem *)item;

- (XMInputAtItem *)item:(NSString *)name;

- (void)removeIndex:(NSInteger)index;

- (XMInputAtItem *)removeName:(NSString *)name;

@end

NS_ASSUME_NONNULL_END
