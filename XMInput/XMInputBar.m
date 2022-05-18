//
//  XMInputBar.m
//  XMInputDemo
//
//  Created by XM on 2022/5/5.
//

#import "XMInputBar.h"

@interface XMInputBar ()<XMGrowingTextViewDelegate>

@property (nonatomic, weak) UIView *lineView;
@property (nonatomic, weak) UIView *boxView;
@property (nonatomic, weak) UILabel *placeholderLabel;
@end

@implementation XMInputBar

- (instancetype)initWithFrame:(CGRect)frame {
    if(self == [super initWithFrame:frame]){
        self.inputTextMaxCount = 100;
        self.placeholderText = @"说点什么...";
        self.textViewColor = [UIColor blackColor];
        self.textViewFont = [UIFont systemFontOfSize:16];
        self.placeholderColor = [UIColor grayColor];
        self.atColor = [UIColor redColor];
        self.atCache = [[XMInputAtCache alloc] init];
        [self setupViews];
        [self defaultLayout];
    }
    return self;
}

- (void)setupViews {
    self.backgroundColor = [UIColor whiteColor];
    
    // 顶部分割线
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = kColorFromRGB(0xF6F7F9);
    [self addSubview:lineView];
    self.lineView = lineView;
    
    // 线框
    UIView *boxView = [[UIView alloc] init];
    boxView.backgroundColor = [UIColor clearColor];
    [self addSubview:boxView];
    self.boxView = boxView;
    
    UIButton *faceButton = [[UIButton alloc] init];
    [faceButton addTarget:self action:@selector(clickFaceBtn:) forControlEvents:UIControlEventTouchUpInside];
    [faceButton setImage:[UIImage imageNamed:@"ic_keyboard_emoj"] forState:UIControlStateNormal];
    [self addSubview:faceButton];
    self.faceButton = faceButton;

    UIButton *keyboardButton = [[UIButton alloc] init];
    [keyboardButton addTarget:self action:@selector(clickKeyboardBtn:) forControlEvents:UIControlEventTouchUpInside];
    [keyboardButton setImage:[UIImage imageNamed:@"ic_keyboard_input"] forState:UIControlStateNormal];
    keyboardButton.hidden = YES;
    [self addSubview:keyboardButton];
    self.keyboardButton = keyboardButton;
    
    UIButton *atButton = [[UIButton alloc] init];
    [atButton addTarget:self action:@selector(clickAtBtn:) forControlEvents:UIControlEventTouchUpInside];
    [atButton setImage:[UIImage imageNamed:@"ic_keyboard_at"] forState:UIControlStateNormal];
    [self addSubview:atButton];
    self.atButton = atButton;
    
    UIButton *sendButton = [[UIButton alloc] init];
    [sendButton addTarget:self action:@selector(clickSendBtn:) forControlEvents:UIControlEventTouchUpInside];
    [sendButton setImage:[UIImage imageNamed:@"ic_keyboard_send"] forState:UIControlStateNormal];
    [self addSubview:sendButton];
    self.sendButton = sendButton;
    
    UILabel *placeholderLabel = [[UILabel alloc] init];
    placeholderLabel.text = self.placeholderText;
    placeholderLabel.textColor = self.placeholderColor;
    placeholderLabel.font = self.textViewFont;
    placeholderLabel.userInteractionEnabled = NO;
    [self addSubview:placeholderLabel];
    self.placeholderLabel = placeholderLabel;
    XMGrowingTextView *inputTextView = [[XMGrowingTextView alloc] init];
    inputTextView.font = self.textViewFont;
    inputTextView.returnKeyType = UIReturnKeySend;
    inputTextView.delegate = self;
    inputTextView.textColor = self.textViewColor;
    inputTextView.textView.enablesReturnKeyAutomatically = YES;
    inputTextView.textContainerInset = UIEdgeInsetsMake(9, 10, 9, 10);
    inputTextView.maxNumberOfLines = 3;
    inputTextView.backgroundColor = [UIColor clearColor];
    inputTextView.backgroundColor = [[UIColor greenColor] colorWithAlphaComponent:0.3];
    [self addSubview:inputTextView];
    self.inputTextView = inputTextView;
}

- (void)defaultLayout {
    CGSize buttonSize = kInputBar_Button_Size;
    self.lineView.frame = CGRectMake(0, 0, kScreen_Width, 1);
    self.boxView.frame = CGRectMake(kInputBar_HorzMargin, kInputBar_VertMargin, kScreen_Width - 2*kInputBar_HorzMargin, kInputBar_Height - 2*kInputBar_VertMargin);
    self.boxView.layer.cornerRadius = 8;
    self.boxView.layer.borderColor = kColorFromRGB(0xE8E8E8).CGColor;
    self.boxView.layer.borderWidth = 1;
    self.boxView.layer.masksToBounds = YES;
    self.faceButton.frame = CGRectMake(kScreen_Width - buttonSize.width - kInputBar_HorzMargin - 4, kInputBar_Height - buttonSize.height - kInputBar_VertMargin - 2, buttonSize.width, buttonSize.height);
    self.keyboardButton.frame = CGRectMake(kScreen_Width - buttonSize.width - kInputBar_HorzMargin - 4, kInputBar_Height - buttonSize.height - kInputBar_VertMargin - 2, buttonSize.width, buttonSize.height);
    self.atButton.frame = CGRectMake(self.faceButton.frame.origin.x - buttonSize.width, kInputBar_Height - buttonSize.height - kInputBar_VertMargin - 2, buttonSize.width, buttonSize.height);
    self.sendButton.frame = CGRectMake(kScreen_Width, kInputBar_Height - buttonSize.height - kInputBar_VertMargin - 2, buttonSize.width, buttonSize.height);
    if (self.atButton.hidden) {
        self.inputTextView.frame = CGRectMake(self.boxView.frame.origin.x, self.boxView.frame.origin.y, self.boxView.frame.size.width - buttonSize.width - 4, self.boxView.frame.size.height);
    } else {
        self.inputTextView.frame = CGRectMake(self.boxView.frame.origin.x, self.boxView.frame.origin.y, self.boxView.frame.size.width - 2*buttonSize.width - 4, self.boxView.frame.size.height);
    }
    self.placeholderLabel.frame = CGRectMake(self.inputTextView.frame.origin.x + self.inputTextView.textContainerInset.left + 2, self.inputTextView.frame.origin.y + self.inputTextView.textContainerInset.top - 1, self.inputTextView.frame.size.width - self.inputTextView.textContainerInset.left - self.inputTextView.textContainerInset.right, self.inputTextView.frame.size.height - self.inputTextView.textContainerInset.top - self.inputTextView.textContainerInset.bottom);
    self.inputTextView.text = @"";
}

#pragma mark - set
- (void)setTextViewColor:(UIColor *)textViewColor {
    _textViewColor = textViewColor;
    self.inputTextView.textColor = textViewColor;
}

- (void)setTextViewFont:(UIFont *)textViewFont {
    _textViewFont = textViewFont;
    self.inputTextView.font = textViewFont;
}

- (void)setPlaceholderColor:(UIColor *)placeholderColor {
    _placeholderColor = placeholderColor;
    self.placeholderLabel.textColor = placeholderColor;
}

- (void)setPlaceholderText:(NSString *)placeholderText {
    _placeholderText = placeholderText;
    self.placeholderLabel.text = placeholderText;
}

#pragma mark - XMGrowingTextViewDelegate
- (void)xm_textViewDidBeginEditing:(XMGrowingTextView *)textView {
    if (!self.keyboardButton.hidden) {
        if(self.delegate && [self.delegate respondsToSelector:@selector(inputBarDidTouchKeyboard:)]){
            [self.delegate inputBarDidTouchKeyboard:self];
        }
    }
    self.keyboardButton.hidden = YES;
    self.faceButton.hidden = NO;
    [self updateInputStatus];
}

- (void)xm_textViewDidChange:(XMGrowingTextView *)textView {
    if(textView.text.length > kTextView_TextView_Input_Count_Max) {
        textView.text = [textView.text substringToIndex:kTextView_TextView_Input_Count_Max];
    }
    [self updateInputStatus];
}

- (BOOL)xm_textView:(XMGrowingTextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if([text isEqualToString:@"\n"]){
        if (self.delegate && [self.delegate respondsToSelector:@selector(inputBar:didSendText:)]) {
            [self.delegate inputBar:self didSendText:self.inputTextView.textView.message];
            [self clearInput];
        }
        return NO;
    }
    
    // 删除
    if ([text isEqualToString:@""]) {
        return [self deleteTextRange:range];
    }
    
    // 对输入文字字数限制
    if ((self.contentText.length + text.length) > self.inputTextMaxCount) {
        return NO;
    }
    
    // 输入@
    if ([text isEqualToString:XMInputAtStartChar] && (range.length == 0)) {
        self.isInputAt = YES;
        if (!self.atButton.hidden) {
            if (self.delegate && [self.delegate respondsToSelector:@selector(inputBarDidTouchAt:)]) {
                [self.delegate inputBarDidTouchAt:self];
            }
        }
        return YES;
    }
    
    [self updateInputStatus];
    
    return YES;
}

- (void)xm_didChangeHeight:(CGFloat)height {
    NSLog(@"==>height:%lf   %lf",height,self.inputTextView.frame.size.height);
    CGFloat newHeight = height;
    if(newHeight > kTextView_TextView_Height_Max){
        newHeight = kTextView_TextView_Height_Max;
    }
    if(newHeight < kTextView_TextView_Height_Min){
        newHeight = kTextView_TextView_Height_Min;
    }
    CGRect textFrame = self.inputTextView.frame;
    textFrame.size.height = newHeight;
    self.inputTextView.frame = textFrame;
    [UIView animateWithDuration:0.15f animations:^{
        [self layoutButton:newHeight + 2 * kInputBar_VertMargin];
    } completion:^(BOOL finished) {
        [self.inputTextView.textView scrollRectToVisible:CGRectMake(0, 0, self.inputTextView.frame.size.width, self.inputTextView.frame.size.height) animated:NO];
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            [self scrollToBottomAnimated:NO];
//        });
    }];
}

#pragma mark - XMGrowingTextViewDelegate
// 光标
- (void)xm_textViewDidChangeSelection:(XMGrowingTextView *)textView {
    NSRange selectedRange = textView.selectedRange;
    NSString *content = self.contentText;
    
    if (content.length > self.inputTextMaxCount) {
        content = [content substringToIndex:self.inputTextMaxCount];
    }
    
    if ([content containsString:XMInputAtEndChar]) {
        if (selectedRange.length) { // 光标选择
            for (XMInputAtItem *item in self.atCache.items) {
                NSRange range = [content rangeOfString:item.atName];
                // 选择文本有包含at文本(1.前面包含了部分 2.后面包含了部分)
                if ((selectedRange.location <= range.location)
                    && (selectedRange.location + selectedRange.length) > range.location
                    && ((selectedRange.location + selectedRange.length) < (range.location + range.length))) {
                    // 前面包含了部分
                    NSInteger length = (range.location+range.length) - (selectedRange.location + selectedRange.length) + selectedRange.length;
                    textView.selectedRange = NSMakeRange(selectedRange.location,length);
                }

                if ((selectedRange.location > range.location)
                    && (selectedRange.location < (range.location + range.length))
                    && ((selectedRange.location + selectedRange.length)>=(range.location + range.length))) {
                    // 后面包含了部分
                    NSInteger length = (selectedRange.location+selectedRange.length)-(range.location+range.length)+range.length;
                    textView.selectedRange = NSMakeRange(range.location,length);
                }
            }
        }else{ // 光标移动
            for (XMInputAtItem *item in self.atCache.items) {
                NSString *atName = [NSString stringWithFormat:@"%@%@%@",XMInputAtStartChar,item.name,XMInputAtEndChar];
                NSRange range = [content rangeOfString:atName];
                // 光标在at文本中间
                if (selectedRange.location>range.location && selectedRange.location<(range.location+range.length)) {
                    textView.selectedRange = NSMakeRange(range.location+range.length, 0);
                }
            }
        }
    }
}

- (void)layoutButton:(CGFloat)height {
    CGRect frame = self.frame;
    CGFloat offset = height - frame.size.height;
    frame.size.height = height;
    self.frame = frame;

    CGSize buttonSize = kInputBar_Button_Size;
    CGFloat originY = frame.size.height - buttonSize.height - kInputBar_VertMargin - 2;

    CGRect faceFrame = _faceButton.frame;
    faceFrame.origin.y = originY;
    self.faceButton.frame = faceFrame;
    self.keyboardButton.frame = self.faceButton.frame;
    
    CGRect atFrame = self.atButton.frame;
    atFrame.origin.y = originY;
    self.atButton.frame = atFrame;
    
    CGRect sendFrame = self.sendButton.frame;
    sendFrame.origin.y = originY;
    self.sendButton.frame = sendFrame;
    
    CGRect boxFrame = self.boxView.frame;
    boxFrame.size.height = self.frame.size.height - 2*kInputBar_VertMargin;
    self.boxView.frame = boxFrame;
    
    if(_delegate && [_delegate respondsToSelector:@selector(inputBar:didChangeInputHeight:)]){
        [_delegate inputBar:self didChangeInputHeight:offset];
    }
}

- (void)updateInputStatus {
    CGSize buttonSize = kInputBar_Button_Size;
    CGRect boxFrame = self.boxView.frame;
    CGRect inputFrame = self.inputTextView.frame;
    CGRect faceFrame = self.faceButton.frame;
    CGRect atFrame = self.atButton.frame;
    CGRect sendFrame = self.sendButton.frame;
    [self inputTextScrollView];
    if (self.inputTextView.text.length) {
        self.placeholderLabel.hidden = YES;
        boxFrame.size.width = kScreen_Width - kInputBar_HorzMargin - 47;
        if (self.atButton.hidden) {
            inputFrame.size.width = boxFrame.size.width - buttonSize.width - 4;
        } else {
            inputFrame.size.width = boxFrame.size.width - 2*buttonSize.width - 4;
        }
        faceFrame.origin.x = kScreen_Width - buttonSize.width - 4 - 47;
        atFrame.origin.x = faceFrame.origin.x - buttonSize.width;
        sendFrame.origin.x = kScreen_Width - buttonSize.width - 7;
    } else{
        self.inputTextView.textColor = self.textViewColor;
        self.placeholderLabel.hidden = NO;
        boxFrame.size.width = kScreen_Width - 2*kInputBar_HorzMargin;
        if (self.atButton.hidden) {
            inputFrame.size.width = boxFrame.size.width - buttonSize.width - 4;
        } else {
            inputFrame.size.width = boxFrame.size.width - 2*buttonSize.width - 4;
        }
        faceFrame.origin.x = kScreen_Width - buttonSize.width - kInputBar_HorzMargin - 4;
        atFrame.origin.x = faceFrame.origin.x - buttonSize.width;
        sendFrame.origin.x = kScreen_Width;
    }
    [UIView animateWithDuration:0.25f animations:^{
        self.boxView.frame = boxFrame;
        self.inputTextView.frame = inputFrame;
        self.faceButton.frame = faceFrame;
        self.keyboardButton.frame = faceFrame;
        self.atButton.frame = atFrame;
        self.sendButton.frame = sendFrame;
    }];
}

#pragma mark - click
// 表情
- (void)clickFaceBtn:(UIButton *)sender {
    self.faceButton.hidden = YES;
    self.keyboardButton.hidden = NO;
    self.keyboardButton.frame = self.faceButton.frame;
    if(self.delegate && [self.delegate respondsToSelector:@selector(inputBarDidTouchFace:)]){
        [self.delegate inputBarDidTouchFace:self];
    }
}

// 键盘
- (void)clickKeyboardBtn:(UIButton *)sender {
    self.faceButton.hidden = NO;
    self.keyboardButton.hidden = YES;
    if(self.delegate && [self.delegate respondsToSelector:@selector(inputBarDidTouchKeyboard:)]){
        [self.delegate inputBarDidTouchKeyboard:self];
    }
}

// at
- (void)clickAtBtn:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(inputBarDidTouchAt:)]) {
        [self.delegate inputBarDidTouchAt:self];
    }
}

// 发送
- (void)clickSendBtn:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(inputBar:didSendText:)]) {
        [self.delegate inputBar:self didSendText:self.inputTextView.textView.message];
    }
    [self clearInput];
}

#pragma mark - event
- (void)startInput {
    [self.inputTextView becomeFirstResponder];
}

- (void)startInputAtToId:(NSString *)toId name:(NSString *)name {
    [self inputAtByAppendingName:name uid:toId];
}

- (void)endInput {
    [self clearInput];
}

- (void)clearInput {
    [self.atCache clean];
    self.inputTextView.text = @"";
    [self xm_textViewDidChange:self.inputTextView];
    [self.inputTextView resignFirstResponder];
}

- (void)scrollToBottomAnimated:(BOOL)animated {
    CGPoint off = self.inputTextView.textView.contentOffset;
    off.y = self.inputTextView.textView.contentSize.height - self.inputTextView.textView.bounds.size.height + self.inputTextView.textView.contentInset.bottom;
    [self.inputTextView.textView setContentOffset:off animated:animated];
}

- (void)addEmoji:(NSString *)emoji {
    XMEmojiTextAttachment *attach   = [[XMEmojiTextAttachment alloc] init];
    attach.image                    = [UIImage imageNamed:emoji];
    attach.emojiText                = emoji;
    attach.bounds                   = CGRectMake(0, -5, self.inputTextView.textView.lineHeight, self.inputTextView.textView.lineHeight);
    NSAttributedString *emojiAtt    = [NSAttributedString attributedStringWithAttachment:attach];
    NSMutableAttributedString *mutableAttr = [[NSMutableAttributedString alloc] initWithAttributedString:emojiAtt];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 0;
    paragraphStyle.alignment = NSTextAlignmentNatural;
    [mutableAttr addAttribute:NSFontAttributeName value:self.textViewFont range:NSMakeRange(0, mutableAttr.length)];
    [mutableAttr addAttribute:NSForegroundColorAttributeName value:self.textViewColor range:NSMakeRange(0, mutableAttr.length)];
    [mutableAttr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, mutableAttr.length)];
    [self insertAttributedString:mutableAttr];
}

- (void)backDelete {
    if (self.selectedRange.location > 0) {
        // 删的不是表情，可能是@
        NSRange range;
        XMInputAtItem *item = [self delRangeForAt];
        if (item) {
            range = item.range;
        } else {
            range = NSMakeRange(self.selectedRange.location - 1, 1);
        }
        [self deleteChooseTextInRange:range];
    }
}

// 删除数据
- (BOOL)deleteTextRange:(NSRange)range {
    if (range.length == 1 ) { // 单删
        return [self onTextDelete];
    }else{ // 选择删除
        [self deleteChooseTextInRange:range];
        return NO;
    }
}

- (void)inputAtByAppendingName:(NSString *)name uid:(NSString *)uid {
    if (name.length && uid.length) {
        // @ 单个人
        NSMutableString *str = [[NSMutableString alloc] initWithString:@""];
        [str appendString:XMInputAtStartChar];
        [str appendString:name];
        [str appendString:XMInputAtEndChar];
        
        // 新at后的文字总长度大于总限制的长度，return
        if ((self.contentText.length + str.length) > self.inputTextMaxCount) {
            return;
        }
        
        XMInputAtItem *item = [[XMInputAtItem alloc] init];
        item.uid = uid;
        item.name = name;
        item.atName = str;
        
        [self atInsertArrayWithItem:item];
        NSMutableAttributedString *atAttStr = [[NSMutableAttributedString alloc] initWithString:str];
        [atAttStr addAttribute:NSFontAttributeName value:self.textViewFont range:NSMakeRange(0, atAttStr.length)];
        [atAttStr addAttribute:NSForegroundColorAttributeName value:self.atColor range:NSMakeRange(0, atAttStr.length-1)];
        [atAttStr addAttribute:NSForegroundColorAttributeName value:self.textViewColor range:NSMakeRange(atAttStr.length-1, 1)];
        [self insertAttributedString:atAttStr];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.inputTextView becomeFirstResponder];
        });
    }
}

// at插入有序数组
- (void)atInsertArrayWithItem:(XMInputAtItem *)item{
    if ([self.contentText containsString:XMInputAtStartChar] && [self.contentText containsString:XMInputAtEndChar] && self.atCache.items.count) {
        // 已经存在at数组，插入到对应数组位置
        NSRange range = self.inputTextView.selectedRange;
        NSString *frontText = [self.contentText substringToIndex:range.location];
        // 新添加的at对象前面的at对象个数
        NSArray *atArray = [XMTool getRangeStr:frontText findText:XMInputAtEndChar];
        // 插入到对应数组位置
        [self.atCache insertAtItem:item atIndex:atArray.count];
    }else{ // 目前没有at,直接加入数组
        [self.atCache addAtItem:item];
    }
}

// 删除（单独删除）
- (BOOL)onTextDelete {
    NSRange range = [self delRangeForEmoticon];
    if (range.length == 1) {
        //删的不是表情，可能是@
        XMInputAtItem *item = [self delRangeForAt];
        if (item) {
            range = item.range;
        }
    }
    
    if (range.length == 1) {
        // 自动删除
        return YES;
    }
    
    [self deleteChooseTextInRange:range];
    return NO;
}

// 删除at
- (XMInputAtItem *)delRangeForAt {
    NSString *text = self.contentText;
    NSRange range = [self rangeForPrefix:XMInputAtStartChar suffix:XMInputAtEndChar];
    if (range.location + range.length > text.length) {
        return nil;
    }
    
    // 处理用户从中间删除 @ 中的内容
    // 没找到在处理一次
    if (range.length == 1) {
        range = [self secondCheckRangeForPrefix:XMInputAtStartChar suffix:XMInputAtEndChar];
    }
    
    NSRange selectedRange = [self selectedRange];
    XMInputAtItem *item = nil;
    if (range.length > 1) {
        NSString *name = [text substringWithRange:range];
        NSString *temp = [[name mutableCopy] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:XMInputAtEndChar]];
        NSString *set = [XMInputAtStartChar stringByAppendingString:XMInputAtEndChar];
        name = [name stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:set]];
        item = [self.atCache item:name];
        
        // 某些名字中可能带有 @, 上面那一步@被去掉了会导致匹配不上, 这里同样处理下这种情况, 如果为空, 重新用名字查一次
        if (!item) {
            item = [self.atCache item:temp];
        }
        
        NSString *prefix = @"";
        if (range.location >= 1) {
            prefix = [text substringWithRange:NSMakeRange(range.location - 1, 1)];
        }
        
        if ([prefix isEqualToString:XMInputAtEndChar]) {
            range = item ? NSMakeRange(range.location, range.length) : NSMakeRange(selectedRange.location - 1, 1);
        } else {
            if (item && [item.name hasPrefix:XMInputAtStartChar]) {
                // 检查前面有几个 @, 全部一起去掉
                NSInteger atStringCount = 0;
                for (NSInteger i = 0; i < item.name.length; i++) {
                    NSString *sub = [item.name substringWithRange:NSMakeRange(i, 1)];
                    if ([sub isEqualToString:XMInputAtStartChar]) {
                        atStringCount++;
                    } else {
                        break;
                    }
                }
                
                range = item ? NSMakeRange(range.location - atStringCount, range.length + atStringCount) : NSMakeRange(selectedRange.location - 1, 1);
            } else {
                range = item ? range : NSMakeRange(selectedRange.location - 1, 1);
            }
        }
    }
    item.range = range;
    return item;
}

// 删除emoji
- (NSRange)delRangeForEmoticon {
    NSString *text = self.contentText;
    NSRange range = [self rangeForPrefix:@"[" suffix:@"]"];
    NSRange selectedRange = [self selectedRange];
    if (range.length > 1){
        NSString *name = [text substringWithRange:range];
        XMFaceCellData *emotion = [[XMConfig defaultConfig].emojiCache objectForKey:name];
        range = emotion ? range : NSMakeRange(selectedRange.location - 1, 1);
        return range;
    }
    return range;
}

- (NSRange)rangeForPrefix:(NSString *)prefix suffix:(NSString *)suffix {
    NSString *text = self.contentText;
    NSRange range = [self selectedRange];
    NSString *selectedText = range.location ? [text substringWithRange:NSMakeRange(0, range.location)] : text;
    NSInteger endLocation = range.location;
    if (endLocation <= 0) {
        return NSMakeRange(NSNotFound, 0);
    }
    
    NSInteger index = -1;
    if ([selectedText hasSuffix:suffix]) {
        //往前搜最多30个字符，一般来讲是够了...
        NSInteger p = 50;
        for (NSInteger i = endLocation; i >= endLocation - p && i-1 >= 0 ; i--) {
            NSRange subRange = NSMakeRange(i - 1, 1);
            NSString *subString = [text substringWithRange:subRange];
            if ([subString compare:prefix] == NSOrderedSame) {
                index = i - 1;
                break;
            }
        }
    }
    
    if (index == -1) {
        return NSMakeRange(endLocation - 1, 1);
    }
    
    return NSMakeRange(index, endLocation - index);
}

- (NSRange)secondCheckRangeForPrefix:(NSString *)prefix suffix:(NSString *)suffix {
    NSString *text = self.contentText;
    if (![text containsString:XMInputAtEndChar]) {
        return NSMakeRange(NSNotFound, 0);
    }
    
    NSRange range = [self selectedRange];
    
    BOOL foundEnd = NO;
    NSInteger endLocation = 0;
    for (NSInteger i = range.location; i < text.length; i++) {
        NSRange subRange = NSMakeRange(i, 1);
        NSString *subString = [text substringWithRange:subRange];
        if ([subString isEqualToString:XMInputAtEndChar]) {
            foundEnd = YES;
            endLocation = i+1;
            break;
        }
    }
    
    if (!foundEnd) {
        return NSMakeRange(NSNotFound, 0);
    }
    
    BOOL foundStart = NO;
    NSInteger startLocation = 0;
    for (NSInteger i = range.location; i >= 0; i--) {
        NSRange subRange = NSMakeRange(i, 1);
        NSString *subString = [text substringWithRange:subRange];
        if ([subString isEqualToString:XMInputAtStartChar]) {
            foundStart = YES;
            startLocation = i;
            break;
        }
    }
    
    if (foundEnd && foundStart) {
        return NSMakeRange(startLocation, endLocation - startLocation);
    }
    
    return NSMakeRange(NSNotFound, 0);
}

#pragma mark - get
// 获取at数组
- (NSArray *)getAtUidArray {
    NSMutableArray<XMInputAtItem *> *items = self.atCache.items;
    NSMutableArray *atArray = [NSMutableArray array];
    if (items.count) {
        for (XMInputAtItem *item in items) {
            [atArray addObject:item.uid];
        }
    }
    return atArray;
}

- (NSString *)contentText {
    return self.inputTextView.text;
}

@end




@implementation XMInputBar (InputText)

- (NSRange)selectedRange {
    return self.inputTextView.selectedRange;
}

- (void)insertAttributedString:(NSAttributedString *)attributedString {
    if ((self.inputTextView.attributedText.length + attributedString.length) > self.inputTextMaxCount) {
        return;
    }
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithAttributedString:self.inputTextView.attributedText];
    NSRange newSelectRange = NSMakeRange(self.selectedRange.location + attributedString.length, 0);
    [attString replaceCharactersInRange:self.selectedRange withAttributedString:attributedString];
    self.inputTextView.attributedText = attString;
//    [self.inputTextView setNeedsLayout];
//    [self.inputTextView layoutIfNeeded];
    self.inputTextView.selectedRange = newSelectRange;
    [self xm_textViewDidChange:self.inputTextView];
    [self inputTextScrollView];
}

- (void)inputTextScrollView {
    if(self.inputTextView.textView.contentSize.height > kTextView_TextView_Height_Max){
        CGRect cursorPosition = [self.inputTextView.textView caretRectForPosition:self.inputTextView.textView.selectedTextRange.start];
        if ((cursorPosition.origin.y + cursorPosition.size.height) > (self.inputTextView.textView.contentSize.height - self.inputTextView.textContainerInset.bottom - 10)) {
            float offset = self.inputTextView.textView.contentSize.height - self.inputTextView.textView.frame.size.height + self.inputTextView.textContainerInset.bottom;
            [self.inputTextView.textView scrollRectToVisible:CGRectMake(0, offset, self.inputTextView.frame.size.width, self.inputTextView.frame.size.height) animated:YES];
        }
    }
}

// 选择删除
- (void)deleteChooseTextInRange:(NSRange)range{
    NSString *text = self.contentText;
    if (range.location + range.length <= [text length]
        && range.location != NSNotFound && range.length != 0) {
        // 防止 emoji 被截断
        range = [text rangeOfComposedCharacterSequencesForRange:range];
        // 获取被移除的字符串
        NSString *deleteText = [text substringWithRange:range];
        // 是否是删除的at
        if ([deleteText containsString:XMInputAtStartChar] && [deleteText containsString:XMInputAtEndChar]) {
            NSArray *items = [self.atCache.items copy];
            for (XMInputAtItem *item in items) {
                if ([deleteText containsString:item.atName]) {
                    [self.atCache removeName:item.name];
                }
            }
        }
        
        NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithAttributedString:self.inputTextView.attributedText];
        // 在对应的位置替换
        NSRange newSelectRange = NSMakeRange(range.location, 0);;
        [attString replaceCharactersInRange:range withString:@""];
        self.inputTextView.attributedText = attString;
        self.inputTextView.selectedRange = newSelectRange;
        [self xm_textViewDidChange:self.inputTextView];
        self.inputTextView.font = self.textViewFont;
    }
}

@end
