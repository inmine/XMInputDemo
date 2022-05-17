//
//  XMGrowingTextView.h
//  XMInputDemo
//
//  Created by XM on 2022/5/17.
//

#import <UIKit/UIKit.h>
#import "XMTextView.h"

NS_ASSUME_NONNULL_BEGIN

@class XMGrowingTextView;

@protocol XMGrowingTextViewDelegate <NSObject>
@optional

- (BOOL)xm_textView:(XMGrowingTextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text;

- (BOOL)xm_shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)range;

- (BOOL)xm_shouldInteractWithTextAttachment:(NSTextAttachment *)textAttachment inRange:(NSRange)range;

- (void)xm_textViewDidBeginEditing:(XMGrowingTextView *)textView;

- (void)xm_textViewDidChangeSelection:(XMGrowingTextView *)textView;

- (void)xm_textViewDidEndEditing:(XMGrowingTextView *)textView;

- (BOOL)xm_textViewShouldBeginEditing:(XMGrowingTextView *)textView;

- (BOOL)xm_textViewShouldEndEditing:(XMGrowingTextView *)textView;

- (void)xm_textViewDidChange:(XMGrowingTextView *)textView;

- (void)xm_growingTextViewDidChange:(XMGrowingTextView *)textView;

- (void)xm_willChangeHeight:(CGFloat)height;

- (void)xm_didChangeHeight:(CGFloat)height;

@end


@interface XMGrowingTextView : UIView

@property (nonatomic,weak) id<XMGrowingTextViewDelegate> delegate;

@property (nonatomic,assign) NSInteger minNumberOfLines;

@property (nonatomic,assign) NSInteger maxNumberOfLines;

@property (nonatomic,strong) UIView *inputView;

@property (nonatomic,strong) XMTextView *textView;

@property (nonatomic,assign) CGFloat maxHeight;

@property (nonatomic,assign) CGFloat minHeight;

@property (nonatomic,assign) CGRect previousFrame;

@property (nonatomic,assign) double previousTextHeight;

@end


@interface XMGrowingTextView(TextView)

@property (nonatomic,copy)   NSAttributedString *placeholderAttributedText;

@property (nonatomic,copy)   NSString *text;

@property (nonatomic,strong) UIFont *font;

@property (nonatomic,strong) UIColor *textColor;

@property (nonatomic,assign) NSTextAlignment textAlignment;

@property (nonatomic,assign) NSRange selectedRange;

@property (nonatomic,assign) UIDataDetectorTypes dataDetectorTypes;

@property (nonatomic,assign) BOOL editable;

@property (nonatomic,assign) BOOL selectable;

@property (nonatomic,assign) BOOL allowsEditingTextAttributes;

@property (nonatomic,copy)   NSAttributedString *attributedText;

@property (nonatomic,strong) UIView *textViewInputAccessoryView;

@property (nonatomic,assign) BOOL clearsOnInsertion;

@property (nonatomic,readonly) NSTextContainer *textContainer;

@property (nonatomic,assign)   UIEdgeInsets textContainerInset;

@property (nonatomic,readonly) NSLayoutManager *layoutManger;

@property (nonatomic,readonly) NSTextStorage *textStorage;

@property (nonatomic, copy)    NSDictionary<NSString *, id> *linkTextAttributes;

@property (nonatomic,assign)  UIReturnKeyType returnKeyType;

- (void)scrollRangeToVisible:(NSRange)range;

@end


NS_ASSUME_NONNULL_END
