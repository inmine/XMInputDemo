//
//  XMAtListViewController.m
//  XMInputDemo
//
//  Created by XM on 2022/5/6.
//

#import "XMAtListViewController.h"

@interface XMAtListViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, weak) UITableView *tableView;

@end

@implementation XMAtListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton *nav = [[UIButton alloc] init];
    nav.frame = CGRectMake(0, 0, self.view.frame.size.width, 64);
    nav.backgroundColor = [UIColor redColor];
    [nav setTitle:@"点击我返回" forState:UIControlStateNormal];
    [nav addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:nav];
    
    UITableView *tableView = [[UITableView alloc] init];
    tableView.frame = CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height - 64);
    tableView.backgroundColor = [UIColor clearColor];
    tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view addSubview:tableView];
    self.tableView = tableView;
}

#pragma mark - UITableViewDelegate, UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 20;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 74;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = [NSString stringWithFormat:@"uid_%zi",indexPath.row+1];
    cell.backgroundColor = [UIColor whiteColor];
    for (NSString *uid in self.atArray) {
        if ([uid isEqualToString:[NSString stringWithFormat:@"%zi",indexPath.row+1]]) {
            cell.backgroundColor = [UIColor greenColor];
        }
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *name = [NSString stringWithFormat:@"uid_%zi",indexPath.row+1];
    NSString *uid = [NSString stringWithFormat:@"%zi",indexPath.row+1];
    for (NSString *uidCache in self.atArray) {
        if ([uidCache isEqualToString:uid]) {
            NSLog(@"==》已经被选中");
            return;
        }
    }
    
    if (self.getAtUser) {
        self.getAtUser(name, uid);
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)back {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
