//
//  NIMGrowingInternalTextView.h
//  NIMKit
//
//  Created by chris on 16/3/27.
//  Copyright © 2016年 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NIMGrowingInternalTextView : UITextView

@property (nonatomic, strong) NSAttributedString *placeholderAttributedText;

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
