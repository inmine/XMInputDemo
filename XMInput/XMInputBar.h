//
//  XMInputBar.h
//  XMInputDemo
//
//  Created by XM on 2022/5/5.
//

#import <UIKit/UIKit.h>
#import "XMInput.h"
#import "XMTextView.h"
#import "XMInputAtCache.h"
#import "NIMGrowingTextView.h"

NS_ASSUME_NONNULL_BEGIN

@class XMInputBar,XMResponderTextView;
@protocol XMInputBarDelegate <NSObject>

/**
 *  点击表情按钮，即“笑脸”后的回调委托。
 *  您可以通过该回调实现：点击表情按钮后，显示出对应的表情视图。
 *
 *  @param textView 委托者，当前与用户交互的 InputBar。
 */
- (void)inputBarDidTouchFace:(XMInputBar *)textView;

/**
 *  点击键盘按钮后的回调委托
 *  点击表情按钮后，对应位置的“笑脸”会变成“键盘”图标，此时为键盘按钮。
 *  您可以通过该回调实现：隐藏当前显示的表情视图或者更多视图，并浮现键盘。
 *
 *  @param textView 委托者，当前与用户交互的 InputBar。
 */
- (void)inputBarDidTouchKeyboard:(XMInputBar *)textView;

/**
 *  点击at按钮后的回调委托
 *  点击at按钮后，对应弹起at列表
 *
 *  @param textView 委托者，当前与用户交互的 InputBar。
 */
- (void)inputBarDidTouchAt:(XMInputBar *)textView;

/**
 *  发送文本消息时的回调委托。
 *  当您通过 InputBar 发送文本消息（通过键盘点击发送时），执行该回调函数。
 *  您可以通过该回调实现：获取 InputBar 的内容，并将消息进行发送。
 *
 *  @param textView 委托者，当前与用户交互的 InputBar。
 *  @param text 点击发送时，当前 InputBar 中的文本消息。
 */
- (void)inputBar:(XMInputBar *)textView didSendText:(NSString *)text;

/**
 *  输入条高度更改时的回调委托
 *  当您点击语音按钮、表情按钮、“+”按钮或者呼出/收回键盘时，InputBar 高度会发生改变时，执行该回调
 *  您可以通过该回调实现：通过该回调函数进行 InputBar 高度改变时的 UI 布局调整。
 *
 *  @param textView 委托者，当前与用户交互的 InputBar。
 *  @param offset 输入条高度改变的偏移量。
 */
- (void)inputBar:(XMInputBar *)textView didChangeInputHeight:(CGFloat)offset;

@end

@interface XMInputBar : UIView

/**
 *  实现 XMInputBarDelegate 协议的委托。
 */
@property (nonatomic, weak) id<XMInputBarDelegate> delegate;

/**
 *  文本输入视图
 *  即在输入条中占据大部分面积文本输入框
 *  继承自 UITextView
 */
@property (nonatomic, strong) NIMGrowingTextView *inputTextView;

/**
 *  表情按钮
 *  即在输入条中的“笑脸”按钮。
 *  对应回调委托中的表情按钮回调。
 */
@property (nonatomic, strong) UIButton *faceButton;

/**
 *  键盘按钮
 *  即点击表情按钮（“笑脸”）后，笑脸变化后的按钮。
 */
@property (nonatomic, strong) UIButton *keyboardButton;

/**
 *  at按钮
 *  即在输入条中的“at”按钮。
 *  对应回调委托中的at按钮回调。
 */
@property (nonatomic, strong) UIButton *atButton;

/**
 *  发送按钮
 *  即在输入条中的“发送”按钮。
 *  对应回调委托中的发送按钮回调。
 */
@property (nonatomic, strong) UIButton *sendButton;

/**
 *  文本内容
 *  原数据。
 */
@property (nonatomic, copy) NSString *contentText;

/**
 *  文本内容数量最大限制
 *  emoji算一个。
 */
@property (nonatomic, assign) NSInteger inputTextMaxCount;

/**
 *  at数据
 *  处理at的业务。
 */
@property (nonatomic, strong) XMInputAtCache *atCache;

/**
 * 是否是输入at
 * 用于判断状态
 */
@property (nonatomic, assign) BOOL           isInputAt;

/**
 * at文字颜色
 * 默认系统红色
 */
@property (nonatomic, strong) UIColor *atColor;

/**
 * 文本输入框文字颜色
 * 默认黑色
 */
@property (nonatomic, strong) UIColor *textViewColor;

/**
 * 文本输入框文字大小
 * 默认16
 */
@property (nonatomic, strong) UIFont *textViewFont;

/**
 * 占位文字的颜色
 * 默认灰色
 */
@property (nonatomic, strong) UIColor *placeholderColor;

/**
 * 占位文字
 */
@property (nonatomic, copy) NSString *placeholderText;

/**
 *  添加表情
 *  用于实现在当前文本输入框中输入 emoji
 *
 *  @param emoji 需要输入的表情的字符串表示形式。
 */
- (void)addEmoji:(NSString *)emoji;

/**
 *  删除函数
 *  删除当前文本输入框中最右侧的字符（替换为“”）。
 */
- (void)backDelete;

/**
 *  获取at数组
 *  数组中存储的用户id。
 */
- (NSArray *)getAtUidArray;

/**
 *  添加at
 *  name : 用户昵称。
 *  uid :  用户id。
 */
- (void)inputAtByAppendingName:(NSString *)name uid:(NSString *)uid;

/**
 *  开始输入
 *  重新开始初始化
 */
- (void)startInput;

/**
 *  开始输入直接at
 *  重新开始初始化
 *  name : 用户昵称。
 *  uid :  用户id。
 */
- (void)startInputAtToId:(NSString *)toId name:(NSString *)name;

/**
 *  结束输入
 */
- (void)endInput;

@end


@interface XMInputBar (InputText)

- (NSRange)selectedRange;

- (void)insertAttributedString:(NSAttributedString *)attributedString;

- (void)deleteChooseTextInRange:(NSRange)range;

- (void)inputTextScrollView;


@end

NS_ASSUME_NONNULL_END
