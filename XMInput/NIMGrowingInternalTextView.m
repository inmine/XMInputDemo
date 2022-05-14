//
//  NIMGrowingInternalTextView.m
//  NIMKit
//
//  Created by chris on 16/3/27.
//  Copyright © 2016年 Netease. All rights reserved.
//

#import "NIMGrowingInternalTextView.h"
#import "XMConfig.h"
#import "XMEmojiTextAttachment.h"

@interface NIMGrowingInternalTextView()

@property (nonatomic,assign) BOOL displayPlaceholder;

@end

@implementation NIMGrowingInternalTextView

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setText:(NSString *)text {
    [super setText:text];
    
    if ([self.delegate respondsToSelector:@selector(textViewDidChange:)]) {
        [self.delegate textViewDidChange:self];
    }
    
    [self updatePlaceholder];
}

- (void)setSelectedRange:(NSRange)selectedRange {
    [super setSelectedRange:selectedRange];
    [self scrollRangeToVisible:NSMakeRange(self.selectedRange.location, 0)];
}

- (BOOL)canBecomeFirstResponder {
    return YES;
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    return [super canPerformAction:action withSender:sender];
}

- (void)myWrap:(id)sender{
    NSRange range = self.selectedRange;
    NSString *text = @"\n";
    NSString *replaceText = [self.text stringByReplacingCharactersInRange:range withString: text];
    range = NSMakeRange(range.location + text.length, 0);
    self.text = replaceText;
    self.selectedRange = range;
    
    if ([self.delegate respondsToSelector:@selector(textViewDidChange:)]) {
        [self.delegate textViewDidChange:self];
    }
}

- (void)setPlaceholderAttributedText:(NSAttributedString *)placeholderAttributedText {
    _placeholderAttributedText = placeholderAttributedText;
    [self setNeedsDisplay];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self setNeedsDisplay];
}

#pragma mark - Private
- (void)setDisplayPlaceholder:(BOOL)displayPlaceholder {
    BOOL oldValue = _displayPlaceholder;
    _displayPlaceholder = displayPlaceholder;
    if (oldValue != self.displayPlaceholder) {
        [self setNeedsDisplay];
    }
}

- (void)updatePlaceholder {
    self.displayPlaceholder = self.text.length == 0;
}

- (void)textDidChangeNotification:(NSNotification *)notification {
    [self updatePlaceholder];
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    if (!self.displayPlaceholder) {
        return;
    }
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.alignment = self.textAlignment;
    
    CGRect targetRect = CGRectMake(3, self.contentInset.top, self.frame.size.width - self.contentInset.left, self.frame.size.height - self.contentInset.top);
    
    NSAttributedString *attributedString = self.placeholderAttributedText;
    [attributedString drawInRect:targetRect];
}

- (instancetype)initWithFrame:(CGRect)frame textContainer:(NSTextContainer *)textContainer {
    self = [super initWithFrame:frame textContainer:textContainer];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChangeNotification:) name:UITextViewTextDidChangeNotification object:self];
        
        // 添加长按换行
//        UIMenuController *menuController = [UIMenuController sharedMenuController];
//        NSMutableArray<UIMenuItem *> *temp = [NSMutableArray arrayWithArray:[NSArray notNullArray:menuController.menuItems]];
//
//        BOOL inserted = NO;
//        for (UIMenuItem *item in temp) {
//            if ([item.title isEqualToString:@"Wrap"]) {
//                inserted = YES;
//                break;
//            }
//        }
//
//        if (!inserted) {
//            UIMenuItem *menuItem = [[UIMenuItem alloc]initWithTitle:@"Wrap" action:@selector(myWrap:)];
//            [temp addObject:menuItem];
//            [menuController setMenuItems:temp];
//            [menuController setMenuVisible:NO];
//        }
        
        self.lineHeight = 20;
        self.displayPlaceholder = YES;
    }
    return self;
}
//- (instancetype)init {
//    if (self = [super init]) {
//        self.backgroundColor = [[UIColor redColor] colorWithAlphaComponent:0.6];
//        self.lineHeight = 20;
//        self.displayPlaceholder = YES;
//    }
//    return self;
//}

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
    [attributedString addAttribute:NSForegroundColorAttributeName value:self.textColor range:NSMakeRange(0, content.length)];
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


@end
