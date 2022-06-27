//
//  XMInputController.m
//  XMInputDemo
//
//  Created by XM on 2022/5/5.
//

#import "XMInputController.h"
#import "XMFaceView.h"
#import "XMInput.h"
#import "XMInputBar.h"

typedef NS_ENUM(NSUInteger, InputStatus) {
    Input_Status_Input,
    Input_Status_Input_Face,
    Input_Status_Input_More,
    Input_Status_Input_Keyboard,
    Input_Status_Input_Talk,
};

@interface XMInputController ()<XMInputBarDelegate,XMFaceViewDelegate>

@property (nonatomic, assign) InputStatus status;
@property (nonatomic, strong) XMFaceView *faceView;

@end

@implementation XMInputController

- (void)viewWillAppear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    for (UIGestureRecognizer *gesture in self.view.window.gestureRecognizers) {
        gesture.delaysTouchesBegan = NO;
    }
    self.navigationController.interactivePopGestureRecognizer.delaysTouchesBegan = NO;
}

- (void)viewDidDisappear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)init {
    if (self = [super init]) {
        self.showInputBar = YES;
        self.showAtBtn = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupViews];
}

- (void)setupViews {
    self.view.backgroundColor = [UIColor whiteColor];
    self.view.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    self.automaticallyAdjustsScrollViewInsets = NO;
    _status = Input_Status_Input;

    XMInputBar *inputBar = [[XMInputBar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, kInputBar_Height)];
    inputBar.delegate = self;
    inputBar.atColor = kColorFromRGB(0x5991E0);
    inputBar.atButton.hidden = !self.showAtBtn;
    inputBar.placeholderColor = kColorFromRGB(0x777777);
    inputBar.tintColor = [UIColor redColor];
    [self.view addSubview:inputBar];
    self.inputBar = inputBar;
    
    [XMConfig defaultConfig];
}

- (void)startInput {
    [self.inputBar startInput];
}

- (void)startInputAtToId:(NSString *)toId name:(NSString *)name {
    [self.inputBar startInputAtToId:toId name:name];
}

- (void)inputAtByAppendingName:(NSString *)name uid:(NSString *)uid {
    [self.inputBar inputAtByAppendingName:name uid:uid];
}

- (void)setPlaceholderText:(NSString *)placeholderText {
    _placeholderText = placeholderText;
    self.inputBar.placeholderText = placeholderText;
}

- (void)endInput {
    [self.inputBar endInput];
    if (_delegate && [_delegate respondsToSelector:@selector(inputController:didChangeHeight:)]){
        if (self.showInputBar) {
            [_delegate inputController:self didChangeHeight:_inputBar.frame.size.height + kBottom_SafeHeight];
        } else {
            [_delegate inputController:self didChangeHeight:0];
        }
    }
}

#pragma mark - 输入键盘的改变通知
- (void)keyboardWillShow:(NSNotification *)notification {
    _status = Input_Status_Input_Keyboard;
}

- (void)keyboardWillHide:(NSNotification *)notification {
    // 当点击表情，键盘消失不处理
    if (_status == Input_Status_Input_Face) return;
    
    if (_delegate && [_delegate respondsToSelector:@selector(inputController:didChangeHeight:)]){
        if (self.showInputBar) {
            [_delegate inputController:self didChangeHeight:_inputBar.frame.size.height + kBottom_SafeHeight];
        } else {
            [_delegate inputController:self didChangeHeight:0];
        }
    }
}

- (void)keyboardWillChangeFrame:(NSNotification *)notification {
    CGRect keyboardFrame = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
//    NSLog(@"==>size:%@  height:%lf",NSStringFromCGSize(keyboardFrame.size),_inputBar.frame.size.height);
    if (keyboardFrame.size.width != kScreen_Width) return;
    if (_delegate && [_delegate respondsToSelector:@selector(inputController:didChangeHeight:)]){
        [_delegate inputController:self didChangeHeight:(keyboardFrame.size.height + _inputBar.frame.size.height)];
    }
}

#pragma mark - InputBarDelegate
- (void)inputBarDidTouchFace:(XMInputBar *)textView {
    if([XMConfig defaultConfig].faceGroups.count == 0){
        return;
    }
//    if(_status == Input_Status_Input_More){
//        [self hideMoreAnimation];
//    }
    _status = Input_Status_Input_Face;
    [_inputBar.inputTextView resignFirstResponder];
    [self showFaceAnimation];
    if (_delegate && [_delegate respondsToSelector:@selector(inputController:didChangeHeight:)]){
        [_delegate inputController:self didChangeHeight:_inputBar.frame.size.height + self.faceView.frame.size.height + kBottom_SafeHeight];
    }
}

- (void)inputBarDidTouchKeyboard:(XMInputBar *)textView {
    [self hideFaceAnimation];
    _status = Input_Status_Input_Keyboard;
    [_inputBar.inputTextView becomeFirstResponder];
}

- (void)inputBarDidTouchAt:(XMInputBar *)textView {
    [_inputBar.inputTextView becomeFirstResponder];
    if (self.delegate && [self.delegate respondsToSelector:@selector(inputController:didSelectFunctionType:atArray:message:)]) {
        [self.delegate inputController:self didSelectFunctionType:XMInputFunctionAt atArray:[textView getAtUidArray] message:@""];
    }
}

- (void)inputBar:(XMInputBar *)textView didSendText:(NSString *)text {
    if (self.delegate && [self.delegate respondsToSelector:@selector(inputController:didSelectFunctionType:atArray:message:)]) {
        [self.delegate inputController:self didSelectFunctionType:XMInputFunctionSend atArray:[textView getAtUidArray] message:text];
    }
}

- (void)inputBar:(XMInputBar *)textView didChangeInputHeight:(CGFloat)offset {
    if(_status == Input_Status_Input_Face){
        [self showFaceAnimation];
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(inputController:didChangeHeight:)]){
        [self.delegate inputController:self didChangeHeight:self.view.frame.size.height + offset];
    }
}

- (void)showFaceAnimation {
    self.faceView.hidden = NO;
    
//    CGRect frame = self.faceView.frame;
//    frame.origin.y = kScreen_Height;
//    self.faceView.frame = frame;
    
    CGRect newFrame = self.faceView.frame;
    newFrame.origin.y = self.inputBar.frame.origin.y + self.inputBar.frame.size.height;
    self.faceView.frame = newFrame;
//    __weak typeof(self) weakSelf = self;
//    [UIView animateWithDuration:0.25f delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
//        weakSelf.faceView.frame = newFrame;
//    } completion:nil];
}

- (void)hideFaceAnimation {
    self.faceView.hidden = NO;
    self.faceView.alpha = 1.0;
    __weak typeof(self) ws = self;
    [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        ws.faceView.alpha = 0.0;
    } completion:^(BOOL finished) {
        ws.faceView.hidden = YES;
        ws.faceView.alpha = 1.0;
    }];
}

#pragma mark - XMFaceViewDelegate
- (void)faceView:(XMFaceView *)faceView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    XMFaceGroup *group = [XMConfig defaultConfig].faceGroups[indexPath.section];
    XMFaceCellData *face = group.faces[indexPath.row];
    [self.inputBar addEmoji:face.name];
}

- (void)faceViewDidBackDelete:(XMFaceView *)faceView {
    [self.inputBar backDelete];
}

#pragma mark - lazy load
- (XMFaceView *)faceView {
    if(!_faceView){
        _faceView = [[XMFaceView alloc] initWithFrame:CGRectMake(0, _inputBar.frame.origin.y + _inputBar.frame.size.height, self.view.frame.size.width, kFaceView_Height)];
        _faceView.delegate = self;
        [_faceView setData:[XMConfig defaultConfig].faceGroups];
        [self.view addSubview:_faceView];
    }
    return _faceView;
}

@end
