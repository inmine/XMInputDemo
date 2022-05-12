//
//  XMInputController.h
//  XMInputDemo
//
//  Created by XM on 2022/5/5.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, XMInputFunctionState) {
    XMInputFunctionNormal,          // 默认键盘（无输入框）
    XMInputFunctionTextInput,       // 键盘输入
    XMInputFunctionEmojiInput,      // 表情输入
    XMInputFunctionAt,              // at
    XMInputFunctionSend,            // 发送
};


@class XMInputController,XMInputBar;

@protocol XMInputControllerDelegate <NSObject>

/**
 *  当前 InputController 高度改变时的回调。
 *  一般由 InputBar 中的高度改变回调进一步调用。
 *  您可以通过该回调实现：根据改变的高度调整控制器内各个组件的 UI 布局。
 *
 *  @param  inputController 委托者，当前参与交互的视图控制器。
 *  @param height 改变高度的具体数值（偏移量）。
 */
- (void)inputController:(XMInputController *)inputController didChangeHeight:(CGFloat)height;

/**
 *  当前 InputController 高度改变时的回调。
 *  一般由 InputBar 中的高度改变回调进一步调用。
 *  您可以通过该回调实现：根据改变的高度调整控制器内各个组件的 UI 布局。
 *
 *  @param  inputController 委托者，当前参与交互的视图控制器。
 *  @param height 改变高度的具体数值（偏移量）。
 */
- (void)inputController:(XMInputController *)inputController didChangeHeight:(CGFloat)height;

/**
 *  功能按钮点击
 *  一般由 InputBar 中的发送信息回调进一步调用。
 *
 *  @param  inputController 委托者，当前参与交互的视图控制器。
 *  @param type 当前功能事件回调。
 *  @param atArray at列表。
 *  @param message 当前控制器所获取并准备发送的消息。
 */
- (void)inputController:(XMInputController *)inputController didSelectFunctionType:(XMInputFunctionState)type atArray:(NSArray *)atArray message:(NSString *)message;

@end

@interface XMInputController : UIViewController

/**
 *  实现 TInputControllerDelegate 协议的委托。
 */
@property (nonatomic, weak) id<XMInputControllerDelegate> delegate;

/**
 *  输入条
 */
@property (nonatomic, strong) XMInputBar *inputBar;

/**
 * 是否显示输入框在页面上
 * 默认显示:YES
 */
@property (nonatomic, assign) BOOL showInputBar;

/**
 * 是否显示at在输入框上
 * 默认显示:YES
 */
@property (nonatomic, assign) BOOL showAtBtn;

/**
 * 占位文字
 */
@property (nonatomic, copy) NSString *placeholderText;

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
 *  添加at
 *  name : 用户昵称。
 *  uid :  用户id。
 */
- (void)inputAtByAppendingName:(NSString *)name uid:(NSString *)uid;

@end

NS_ASSUME_NONNULL_END
