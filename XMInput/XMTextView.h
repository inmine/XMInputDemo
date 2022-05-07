//
//  XMTextView.h
//  XMInputDemo
//
//  Created by XM on 2022/5/7.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface XMTextView : UITextView

@property (nonatomic, weak) UIResponder *overrideNextResponder;

/**
 * message(将emoji转换后的text)
 */
@property (nonatomic, copy) NSString *message;

/**
 * 行高
 * 默认20
 */
@property (nonatomic, assign) CGFloat lineHeight;

/**
 * 插入数据
 */
- (void)insertAttriStringToTextview:(NSAttributedString *)attriString;

/**
 * 删除数据
 */
- (void)deleteAttriStringToTextview:(NSAttributedString *)attriString;

/**
 * 获取emoji富文本
 */
- (NSMutableAttributedString *)getEmojiText:(NSString *)content;

@end

NS_ASSUME_NONNULL_END
