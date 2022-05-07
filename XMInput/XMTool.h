//
//  XMTool.h
//  XMInputDemo
//
//  Created by XM on 2022/5/5.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^XMAsyncImageComplete)(NSString *path, UIImage *image);

@interface XMTool : NSObject

// 获取字符串中多个相同字符的位置index
+ (NSMutableArray *)getRangeStr:(NSString *)text findText:(NSString *)findText;

@end

NS_ASSUME_NONNULL_END
