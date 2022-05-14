//
//  NIMGrowingTextView.m
//  NIMKit
//
//  Created by chris on 16/3/27.
//  Copyright © 2016年 Netease. All rights reserved.
//

#import "NIMGrowingTextView.h"


@interface NIMGrowingTextView()<UITextViewDelegate>



@end

@implementation NIMGrowingTextView

#pragma mark - Override
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        CGRect rect = CGRectMake(0, 0, frame.size.width, frame.size.height);
        NIMGrowingInternalTextView *textView = [[NIMGrowingInternalTextView alloc] initWithFrame:rect];
        textView.textContainerInset = UIEdgeInsetsZero;
        textView.textContainer.lineFragmentPadding = 0;
        self.textView = textView;
        self.previousFrame = frame;
        [self setup];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        NIMGrowingInternalTextView *textView = [[NIMGrowingInternalTextView alloc] initWithFrame:CGRectZero];
        textView.textContainerInset = UIEdgeInsetsZero;
        textView.textContainer.lineFragmentPadding = 0;
        self.textView = textView;
        self.previousFrame = CGRectZero;
        [self setup];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (self.previousFrame.size.width != self.bounds.size.width) {
        self.previousFrame = self.frame;
        [self fitToScrollView: NO];
    }
    self.textView.frame = self.bounds;
}

- (CGSize)intrinsicContentSize {
    return [self measureFrame:self.measureTextViewSize].size;
}

#pragma mark - UIResponder
- (UIView *)inputView {
    return self.textView.inputView;
}

- (void)setInputView:(UIView *)inputView {
    self.textView.inputView = inputView;
}

- (BOOL)isFirstResponder {
    return self.textView.isFirstResponder;
}

- (BOOL)becomeFirstResponder
{
    return [self.textView becomeFirstResponder];
}

- (BOOL)resignFirstResponder
{
    return [self.textView resignFirstResponder];
}

#pragma mark - Set
- (void)setMinNumberOfLines:(NSInteger)minNumberOfLines
{
    if (minNumberOfLines <= 0) {
        self.minHeight = 0;
        return;
    }
    self.minHeight = [self simulateHeight:minNumberOfLines];
    _minNumberOfLines = minNumberOfLines;
}

- (void)setMaxNumberOfLines:(NSInteger)maxNumberOfLines {
    if (maxNumberOfLines <= 0) {
        self.maxHeight = 0;
        return;
    }
    
    self.maxHeight = [self simulateHeight:maxNumberOfLines];
    _maxNumberOfLines = maxNumberOfLines;
}

#pragma mark - Private
- (void)setup {
    self.textView.delegate = self;
    self.textView.scrollEnabled = NO;
    self.textView.font = [UIFont systemFontOfSize:16];
    self.textView.backgroundColor = [UIColor clearColor];
    [self addSubview:self.textView];
    
    self.minHeight = self.frame.size.height;
    self.maxNumberOfLines = 3;
    [self.textView setScrollEnabled:YES];
    self.textView.userInteractionEnabled = YES;
    self.textView.showsVerticalScrollIndicator = YES;
}

- (CGFloat)simulateHeight:(NSInteger)line {
    CGFloat lineH = self.textView.font.lineHeight;
    CGFloat height = ceil(lineH * line + self.textView.textContainerInset.top + self.textView.textContainerInset.bottom);
    return height;
}

- (void)fitToScrollView: (BOOL)animated {
    CGSize actualTextViewSize = [self measureTextViewSize];
    CGRect oldScrollViewFrame = self.frame;
    CGRect newScrollViewFrame = [self measureFrame:actualTextViewSize];
    
    CGFloat contentSizeH = self.textView.contentSize.height;
    CGFloat maxHeight = ceil(self.maxHeight);
    if (contentSizeH <= maxHeight) {
        newScrollViewFrame.size.height = contentSizeH;
    } else {
        newScrollViewFrame.size.height = maxHeight;
    }

    if (newScrollViewFrame.size.height <= self.maxHeight && _previousTextHeight == 0) {
        if(oldScrollViewFrame.size.height != newScrollViewFrame.size.height) {
            if ([self.textViewDelegate respondsToSelector:@selector(willChangeHeight:)]) {
                [self.textViewDelegate willChangeHeight:newScrollViewFrame.size.height + 7];
            }
            
            if (newScrollViewFrame.size.height == self.maxHeight) {
                _previousTextHeight = newScrollViewFrame.size.height;
            } else {
                _previousTextHeight = 0;
            }
        }
    } else {
        if (_previousTextHeight != _textView.contentSize.height) {
            _previousTextHeight = _textView.contentSize.height;
        }
    }
    
    self.textView.layoutManager.allowsNonContiguousLayout = NO;
    if (contentSizeH <= maxHeight) {
        self.textView.frame = CGRectMake(0, 0, newScrollViewFrame.size.width, newScrollViewFrame.size.height);
    } else {
        self.textView.frame = CGRectMake(0, 0, newScrollViewFrame.size.width, newScrollViewFrame.size.height - 2);
    }
    
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, newScrollViewFrame.size.width, newScrollViewFrame.size.height);
    self.textView.center = CGPointMake(self.frame.size.height * 0.5, self.frame.size.width * 0.5);
    CGRect textViewFrame = self.textView.frame;
    textViewFrame.origin.y = ceil(textViewFrame.origin.y);
    self.textView.frame = textViewFrame;

    if (contentSizeH <= maxHeight) {
        [self.textView scrollRangeToVisible:NSMakeRange(self.textView.selectedRange.location, 0)];
    } else {
        [UIView setAnimationsEnabled:NO];
        [self.textView scrollRangeToVisible:NSMakeRange(self.textView.selectedRange.location, 0)];
        [UIView setAnimationsEnabled:YES];
        [self.textView scrollRangeToVisible:NSMakeRange(self.textView.selectedRange.location, 0)];
    }
    
    [self.textView setNeedsLayout];
    [self.textView layoutIfNeeded];
    
    [self setNeedsLayout];
    [self layoutIfNeeded];

    if (oldScrollViewFrame.size.height != newScrollViewFrame.size.height && [self.textViewDelegate respondsToSelector:@selector(didChangeHeight:)]) {
        [self.textViewDelegate didChangeHeight:newScrollViewFrame.size.height];
    }

    [self invalidateIntrinsicContentSize];
}

- (CGSize)measureTextViewSize {
    return [self.textView sizeThatFits:CGSizeMake(self.bounds.size.width, CGFLOAT_MAX)];
}

- (CGRect)measureFrame:(CGSize)contentSize {
    CGSize selfSize;
    
    if (contentSize.height < self.minHeight || !self.textView.hasText) {
        selfSize = CGSizeMake(contentSize.width, self.minHeight);
    } else if (self.maxHeight > 0 && contentSize.height > self.maxHeight) {
        selfSize = CGSizeMake(contentSize.width, self.maxHeight);
    } else {
        selfSize = contentSize;
    }
    
    CGRect frame = self.frame;
    frame.size.height = selfSize.height;
    return frame;
}

- (void)scrollToBottom {
    [self.textView scrollRangeToVisible:NSMakeRange(self.textView.text.length - 1, 1)];
}

#pragma mark - UITextViewDelegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([self.textViewDelegate respondsToSelector:@selector(shouldChangeTextInRange:replacementText:)]) {
        return [self.textViewDelegate shouldChangeTextInRange:range replacementText:text];
    }
    
    return YES;
}

- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange {
    if ([self.textViewDelegate respondsToSelector:@selector(shouldInteractWithURL:inRange:)]) {
        return [self.textViewDelegate shouldInteractWithURL:URL inRange:characterRange];
    }
    return YES;
}

- (BOOL)textView:(UITextView *)textView shouldInteractWithTextAttachment:(NSTextAttachment *)textAttachment inRange:(NSRange)characterRange
{
    if ([self.textViewDelegate respondsToSelector:@selector(shouldInteractWithTextAttachment:inRange:)]) {
        return [self.textViewDelegate shouldInteractWithTextAttachment:textAttachment inRange:characterRange];
    }
    return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if ([self.textViewDelegate respondsToSelector:@selector(textViewDidBeginEditing:)]) {
        [self.textViewDelegate textViewDidBeginEditing:self];
    }
}

- (void)textViewDidChangeSelection:(UITextView *)textView
{
    if ([self.textViewDelegate respondsToSelector:@selector(textViewDidChangeSelection:)]) {
        [self.textViewDelegate textViewDidChangeSelection:self];
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if ([self.textViewDelegate respondsToSelector:@selector(textViewDidEndEditing:)]) {
        [self.textViewDelegate textViewDidEndEditing:self];
    }
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    if ([self.textViewDelegate respondsToSelector:@selector(textViewShouldBeginEditing:)]) {
        return [self.textViewDelegate textViewShouldBeginEditing:self];
    }
    return YES;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    if ([self.textViewDelegate respondsToSelector:@selector(textViewShouldEndEditing:)]) {
        return [self.textViewDelegate textViewShouldEndEditing:self];
    }
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView
{
    if ([self.textViewDelegate respondsToSelector:@selector(textViewDidChange:)]) {
        [self.textViewDelegate textViewDidChange:self];
    }
    
    if ([self.textViewDelegate respondsToSelector:@selector(growingTextViewDidChange:)]) {
        [self.textViewDelegate growingTextViewDidChange:self];
    }
    
    [self fitToScrollView: NO];
}

@end




@implementation NIMGrowingTextView(TextView)

- (NSAttributedString *)placeholderAttributedText
{
    return self.textView.placeholderAttributedText;
}

- (void)setPlaceholderAttributedText:(NSAttributedString *)placeholderAttributedText {
    [self.textView setPlaceholderAttributedText:placeholderAttributedText];
}

// MARK: TextView
- (NSString *)text
{
    return self.textView.text;
}

- (void)setText:(NSString *)text {
    self.textView.text = text;
    [self fitToScrollView: YES];
}

- (UIFont *)font {
    return self.textView.font;
}

- (void)setFont:(UIFont *)font
{
    self.textView.font = font;
    [self fitToScrollView: YES];
}

- (UIColor *)textColor
{
    return self.textView.textColor;
}

- (void)setTextColor:(UIColor *)textColor
{
    self.textView.textColor = textColor;
}

- (NSTextAlignment)textAlignment
{
    return self.textView.textAlignment;
}

- (void)setTextAlignment:(NSTextAlignment)textAlignment
{
    self.textView.textAlignment = textAlignment;
}

- (NSRange)selectedRange
{
    return self.textView.selectedRange;
}

- (void)setSelectedRange:(NSRange)selectedRange
{
    self.textView.selectedRange = selectedRange;
}

- (UIDataDetectorTypes)dataDetectorTypes
{
    return self.textView.dataDetectorTypes;
}

- (void)setDataDetectorTypes:(UIDataDetectorTypes)dataDetectorTypes
{
    self.textView.dataDetectorTypes = dataDetectorTypes;
}

- (BOOL)editable
{
    return self.textView.editable;
}

- (void)setEditable:(BOOL)editable
{
    self.textView.editable = editable;
}

- (BOOL)selectable
{
    return self.textView.selectable;
}

- (void)setSelectable:(BOOL)selectable
{
    self.textView.selectable = selectable;
}

- (BOOL)allowsEditingTextAttributes
{
    return self.allowsEditingTextAttributes;
}

- (void)setAllowsEditingTextAttributes:(BOOL)allowsEditingTextAttributes
{
    self.textView.allowsEditingTextAttributes = allowsEditingTextAttributes;
}

- (NSAttributedString *)attributedText
{
    return self.textView.attributedText;
}

- (void)setAttributedText:(NSAttributedString *)attributedText
{
    self.textView.attributedText = attributedText;
    [self fitToScrollView: YES];
}

- (void)scrollRangeToVisible:(NSRange)range
{
    [self.textView scrollRangeToVisible:range];
}


- (UIView *)textViewInputAccessoryView
{
    return self.textView.inputAccessoryView;
}

- (void)setTextViewInputAccessoryView:(UIView *)textViewInputAccessoryView
{
    self.textView.inputAccessoryView = textViewInputAccessoryView;
}

- (BOOL)clearsOnInsertion
{
    return self.textView.clearsOnInsertion;
}

- (void)setClearsOnInsertion:(BOOL)clearsOnInsertion
{
    self.textView.clearsOnInsertion = clearsOnInsertion;
}

- (NSTextContainer *)textContainer
{
    return self.textView.textContainer;
}


- (UIEdgeInsets)textContainerInset
{
    return self.textView.textContainerInset;
}

- (void)setTextContainerInset:(UIEdgeInsets)textContainerInset
{
    self.textView.textContainerInset = textContainerInset;
}

- (NSLayoutManager *)layoutManger
{
    return self.textView.layoutManager;
}

- (NSTextStorage *)textStorage
{
    return self.textView.textStorage;
}

- (NSDictionary<NSString *,id> *)linkTextAttributes
{
    return self.textView.linkTextAttributes;
}

- (void)setLinkTextAttributes:(NSDictionary<NSString *,id> *)linkTextAttributes
{
    self.textView.linkTextAttributes = linkTextAttributes;
}

- (void)setReturnKeyType:(UIReturnKeyType)returnKeyType
{
    [self.textView setReturnKeyType:returnKeyType];
}

- (UIReturnKeyType)returnKeyType
{
    return self.textView.returnKeyType;
}



@end
