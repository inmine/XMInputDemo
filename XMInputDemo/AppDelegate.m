//
//  AppDelegate.m
//  XMInputDemo
//
//  Created by XM on 2022/5/5.
//

#import "AppDelegate.h"
#import "ViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    // 1.创建窗口;
    self.window = [[UIWindow alloc] init];
    self.window.hidden = NO;
    self.window.backgroundColor = [UIColor whiteColor];
    self.window.frame = [UIScreen mainScreen].bounds;
    // 2.设置root控制器
    ViewController *vc = [[ViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    self.window.rootViewController = nav;
    // 3.显视窗口
    [self.window makeKeyAndVisible];
    
    return YES;
}


@end
