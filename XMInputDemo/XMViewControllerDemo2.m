//
//  XMViewControllerDemo2.m
//  XMInputDemo
//
//  Created by XM on 2022/5/7.
//

#import "XMViewControllerDemo2.h"
#import "XMInput.h"
#import "XMAtListViewController.h"

@interface XMViewControllerDemo2 ()<XMInputControllerDelegate>

@property (nonatomic, strong) XMInputController *inputController;

@end

@implementation XMViewControllerDemo2

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *keybordBtn = [[UIButton alloc] init];
    [keybordBtn setTitle:@"键盘退下" forState:UIControlStateNormal];
    [keybordBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [keybordBtn addTarget:self action:@selector(keybordBtnClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBarBtn = [[UIBarButtonItem alloc] initWithCustomView:keybordBtn];
    self.navigationItem.rightBarButtonItems = @[rightBarBtn];
    
    XMInputController *inputController = [[XMInputController alloc] init];
    inputController.delegate = self;
    inputController.view.frame = CGRectMake(0, self.view.frame.size.height - kInputBar_Height - kBottom_SafeHeight, self.view.frame.size.width, kInputBar_Height + kBottom_SafeHeight);
    inputController.showAtBtn = NO;
    [self addChildViewController:inputController];
    [self.view addSubview:inputController.view];
    self.inputController = inputController;
}

#pragma mark - XMInputControllerDelegate
- (void)inputController:(XMInputController *)inputController didChangeHeight:(CGFloat)height {
    [self updateInputHeight:height];
}

- (void)inputController:(XMInputController *)inputController didSelectFunctionType:(XMInputFunctionState)type atArray:(NSArray *)atArray message:(NSString *)message {
    switch (type) {
        case XMInputFunctionAt: {
            XMAtListViewController *vc = [[XMAtListViewController alloc] init];
            vc.atArray = atArray;
            [self presentViewController:vc animated:YES completion:nil];
            __weak typeof(self) weakSelf = self;
            vc.getAtUser = ^(NSString * _Nonnull name, NSString * _Nonnull uid) {
                [weakSelf.inputController inputAtByAppendingName:name uid:uid];
            };
            break;
        }
        case XMInputFunctionSend: {
            NSLog(@"==>message:%@  atArray:%@",message,atArray);
            break;
        }
        default:
            break;
    }
}

- (void)updateInputHeight:(CGFloat)height {
    [UIView animateWithDuration:0.15f delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        CGRect inputFrame = self.inputController.view.frame;
        inputFrame.origin.y = self.view.frame.size.height - height;
        inputFrame.size.height = height;
        self.inputController.view.frame = inputFrame;
    } completion:^(BOOL finished) {}];
}

- (void)keybordBtnClick {
    [self.view endEditing:YES];
}

@end
