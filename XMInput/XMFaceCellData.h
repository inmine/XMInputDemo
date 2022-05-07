//
//  XMFaceCellData.h
//  XMInputDemo
//
//  Created by XM on 2022/5/5.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XMFaceCellData : NSObject

/**
 *  表情id。
 */
@property (nonatomic, strong) NSString *faceId;

/**
 *  表情名称。
 */
@property (nonatomic, strong) NSString *name;

/**
 *  表情在本地缓存的存储路径。
 */
@property (nonatomic, strong) NSString *path;

@end

NS_ASSUME_NONNULL_END
