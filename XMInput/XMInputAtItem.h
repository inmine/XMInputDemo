//
//  XMInputAtItem.h
//  XMInputDemo
//
//  Created by XM on 2022/5/6.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XMInputAtItem : NSObject

@property (nonatomic,   copy) NSString *name;
@property (nonatomic,   copy) NSString *atName;
@property (nonatomic,   copy) NSString *uid;
@property (nonatomic, assign) NSRange  range;

@end

NS_ASSUME_NONNULL_END
