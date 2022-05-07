//
//  ViewController.m
//  XMInputDemo
//
//  Created by XM on 2022/5/5.
//

#import "ViewController.h"
#import "XMViewControllerDemo1.h"
#import "XMViewControllerDemo2.h"
#import "XMViewControllerDemo3.h"
#import "XMViewControllerDemo4.h"
#import "XMViewControllerDemo5.h"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) NSArray *listArray;
@property (nonatomic, weak) UITableView *tableView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"inputDemo";
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.listArray = @[@"文本 + @ + emoji",
                       @"文本 + emoji",
                       @"初始化@",
                       @"初始化回复",
                       @"输入框不显示"];
    
    UITableView *tableView = [[UITableView alloc] init];
    tableView.frame = CGRectMake(0, self.navigationController.navigationBar.frame.size.height, self.view.frame.size.width, self.view.frame.size.height - self.navigationController.navigationBar.frame.size.height);
    tableView.backgroundColor = [UIColor clearColor];
    tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view addSubview:tableView];
    self.tableView = tableView;
}

#pragma mark - UITableViewDelegate, UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.listArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = self.listArray[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0: {
            XMViewControllerDemo1 *vc = [[XMViewControllerDemo1 alloc] init];
            vc.title = self.listArray[indexPath.row];
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        case 1: {
            XMViewControllerDemo2 *vc = [[XMViewControllerDemo2 alloc] init];
            vc.title = self.listArray[indexPath.row];
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        case 2: {
            XMViewControllerDemo3 *vc = [[XMViewControllerDemo3 alloc] init];
            vc.title = self.listArray[indexPath.row];
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        case 3: {
            XMViewControllerDemo4 *vc = [[XMViewControllerDemo4 alloc] init];
            vc.title = self.listArray[indexPath.row];
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        case 4: {
            XMViewControllerDemo5 *vc = [[XMViewControllerDemo5 alloc] init];
            vc.title = self.listArray[indexPath.row];
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        default:
            break;
    }
}

@end
