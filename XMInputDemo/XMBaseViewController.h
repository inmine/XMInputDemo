//
//  XMBaseViewController.h
//  XMInputDemo
//
//  Created by XM on 2022/5/12.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface XMBaseViewController : UIViewController

@property (nonatomic, strong) UILabel *contentLabel;

- (void)hideKeybord;

@end

NS_ASSUME_NONNULL_END
