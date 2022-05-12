//
//  XMBaseViewController.m
//  XMInputDemo
//
//  Created by XM on 2022/5/12.
//

#import "XMBaseViewController.h"

@interface XMBaseViewController ()

@end

@implementation XMBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton *keybordBtn = [[UIButton alloc] init];
    [keybordBtn setTitle:@"键盘退下" forState:UIControlStateNormal];
    [keybordBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [keybordBtn addTarget:self action:@selector(hideKeybord) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBarBtn = [[UIBarButtonItem alloc] initWithCustomView:keybordBtn];
    self.navigationItem.rightBarButtonItems = @[rightBarBtn];
    
    UILabel *contentLabel = [[UILabel alloc] init];
    contentLabel.backgroundColor = [[UIColor yellowColor] colorWithAlphaComponent:0.3];
    contentLabel.frame = CGRectMake(20, 100, self.view.frame.size.width - 40, 200);
    contentLabel.font = [UIFont systemFontOfSize:16];
    contentLabel.textColor = [UIColor blackColor];
    contentLabel.numberOfLines = 0;
    [self.view addSubview:contentLabel];
    self.contentLabel = contentLabel;
}

- (void)hideKeybord {
    [self.view endEditing:YES];
}

@end
