//
//  XMTextView.m
//  XMInputDemo
//
//  Created by XM on 2022/5/7.
//

#import "XMTextView.h"
#import "XMConfig.h"
#import "XMEmojiTextAttachment.h"

@interface XMTextView()

//@property (nonatomic,assign) BOOL displayPlaceholder;

@end

@implementation XMTextView

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)initWithFrame:(CGRect)frame textContainer:(NSTextContainer *)textContainer {
    self = [super initWithFrame:frame textContainer:textContainer];
    if (self) {
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChangeNotification:) name:UITextViewTextDidChangeNotification object:self];

        self.lineHeight = 20;
//        self.displayPlaceholder = YES;
    }
    return self;
}

- (UIResponder *)nextResponder {
    if(_overrideNextResponder == nil){
        return [super nextResponder];
    }else{
        return _overrideNextResponder;
    }
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    if (_overrideNextResponder != nil) {
        return NO;
    } else {
        return [super canPerformAction:action withSender:sender];
    }
}

- (NSString *)message {
    NSString *text = [self getStrContentInRange:NSMakeRange(0, self.attributedText.length)];
    return text;
}

- (void)copy:(id)sender {
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    // 复制的内容 (将emoji转为文本)
    NSString *content = [self getStrContentInRange:self.selectedRange];
    // at
    // 如果产生的真实的 @, 复制的时候, 将匹配的标识符替换成空格
    content = [content stringByReplacingOccurrencesOfString:XMInputAtEndChar withString:@" "];
    
    [pasteboard setString:content];
    [self layoutIfNeeded];
}

- (void)cut:(id)sender {
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    NSString *content = [self getStrContentInRange:self.selectedRange];
    // at
    // 如果产生的真实的 @, 复制的时候, 将匹配的标识符替换成空格
    content = [content stringByReplacingOccurrencesOfString:XMInputAtEndChar withString:@" "];
    [pasteboard setString:content];
    [super cut:sender];
    if (self.delegate && [self.delegate respondsToSelector:@selector(textViewDidChange:)]) {
        [self.delegate textViewDidChange:self];
    }
    [self layoutIfNeeded];
}

- (void)paste:(id)sender {
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    if(pasteboard.string.length > 0){
        NSRange range = self.selectedRange;
        if(range.location == NSNotFound){
            range.location = self.text.length;
        }
        if([self.delegate textView:self shouldChangeTextInRange:range replacementText:pasteboard.string]){
            NSAttributedString *newAttriString = [self getEmojiText:pasteboard.string];
            [self insertAttriStringToTextview:newAttriString];
        }
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(textViewDidChange:)]) {
        [self.delegate textViewDidChange:self];
    }
    [self layoutIfNeeded];
}

- (NSString *)getStrContentInRange:(NSRange)range {
    NSMutableString *result = [[NSMutableString alloc] init];
    NSRange effectiveRange = NSMakeRange(range.location, 0);
    NSUInteger length = NSMaxRange(range);
    while (NSMaxRange(effectiveRange) < length) {
        NSTextAttachment *attachment = [self.attributedText attribute:NSAttachmentAttributeName atIndex:NSMaxRange(effectiveRange) effectiveRange:&effectiveRange];
        if(attachment){
            if([attachment isKindOfClass:[XMEmojiTextAttachment class]]){
                XMEmojiTextAttachment *emojiTextAttachment = (XMEmojiTextAttachment*)attachment;
                [result appendString:emojiTextAttachment.emojiText];
            }
        } else {
            NSString *subStr = [self.text substringWithRange:effectiveRange];
            [result appendString:subStr];
        }
    }
    return [result copy];
}

- (NSMutableAttributedString *)getEmojiText:(NSString *)content {
    NSString *emojiTextPttern = @"\\[[0-9a-zA-Z\\u4e00-\\u9fa5]+\\]";
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:content attributes:self.typingAttributes];
    [attributedString addAttribute:NSFontAttributeName value:self.font range:NSMakeRange(0, content.length)];
    if (self.textColor) {
        [attributedString addAttribute:NSForegroundColorAttributeName value:self.textColor range:NSMakeRange(0, content.length)];
    }
    static NSRegularExpression *regExpress = nil;
    if(regExpress == nil){
        regExpress = [[NSRegularExpression alloc] initWithPattern:emojiTextPttern options:0 error:nil];
    }
    // 通过正则表达式识别出emojiText
    NSArray *matches = [regExpress matchesInString:content options:0 range:NSMakeRange(0, content.length)];
    if(matches.count > 0){
         for(NSTextCheckingResult *result in [matches reverseObjectEnumerator]){
             NSString *emojiText = [content substringWithRange:result.range];
             // 构造NSTextAttachment对象
             XMEmojiTextAttachment *attachment = [self createEmojiAttachment:emojiText];
             if(attachment){
                NSAttributedString *rep = [NSAttributedString attributedStringWithAttachment:attachment];
                // 在对应的位置替换
                [attributedString replaceCharactersInRange:result.range withAttributedString:rep];
             }
         }
    }
    return attributedString;
}

- (XMEmojiTextAttachment *)createEmojiAttachment:(NSString *)emojiText {
    if(emojiText.length == 0){
         return nil;
    }
    UIImage *image = [UIImage imageNamed:emojiText];
    if(image == nil){
        return nil;
    }
    XMEmojiTextAttachment *attachment = [[XMEmojiTextAttachment alloc]init];
    attachment.image        = image;
    attachment.emojiText    = emojiText;
    attachment.bounds = CGRectMake(0, -5, self.lineHeight, self.lineHeight);
    return attachment;
}

- (void)insertAttriStringToTextview:(NSAttributedString *)attriString {
    NSMutableAttributedString *mulAttriString = [[NSMutableAttributedString alloc] initWithAttributedString:self.attributedText];
    NSRange range = self.selectedRange;
    if(range.location == NSNotFound){
        range.location = self.text.length;
    }
    [mulAttriString insertAttributedString:attriString atIndex:range.location];
    self.attributedText = [mulAttriString copy];
    self.selectedRange = NSMakeRange(range.location + attriString.length, 0);
}

//- (void)setText:(NSString *)text {
//    [super setText:text];
//
//    if ([self.delegate respondsToSelector:@selector(textViewDidChange:)]) {
//        [self.delegate textViewDidChange:self];
//    }
//
////    [self updatePlaceholder];
//}

//- (void)setSelectedRange:(NSRange)selectedRange {
//    [super setSelectedRange:selectedRange];
//    [self scrollRangeToVisible:NSMakeRange(self.selectedRange.location, 0)];
//}
//
//- (BOOL)canBecomeFirstResponder {
//    return YES;
//}

//- (void)setPlaceholderAttributedText:(NSAttributedString *)placeholderAttributedText {
//    _placeholderAttributedText = placeholderAttributedText;
//    [self setNeedsDisplay];
//}

//- (void)layoutSubviews {
//    [super layoutSubviews];
//    [self setNeedsDisplay];
//}

//#pragma mark - Private
//- (void)setDisplayPlaceholder:(BOOL)displayPlaceholder {
//    BOOL oldValue = _displayPlaceholder;
//    _displayPlaceholder = displayPlaceholder;
//    if (oldValue != self.displayPlaceholder) {
//        [self setNeedsDisplay];
//    }
//}
//
//- (void)updatePlaceholder {
//    self.displayPlaceholder = self.text.length == 0;
//}
//
//- (void)textDidChangeNotification:(NSNotification *)notification {
//    [self updatePlaceholder];
//}

//- (void)drawRect:(CGRect)rect {
//    [super drawRect:rect];
//    if (!self.displayPlaceholder) {
//        return;
//    }
//    
//    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
//    paragraphStyle.alignment = self.textAlignment;
//    
//    CGRect targetRect = CGRectMake(3, self.contentInset.top, self.frame.size.width - self.contentInset.left, self.frame.size.height - self.contentInset.top);
//    
//    NSAttributedString *attributedString = self.placeholderAttributedText;
//    [attributedString drawInRect:targetRect];
//}

@end
