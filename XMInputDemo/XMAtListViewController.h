//
//  XMAtListViewController.h
//  XMInputDemo
//
//  Created by XM on 2022/5/6.
//

#import <UIKit/UIKit.h>
#import "XMInputBar.h"
NS_ASSUME_NONNULL_BEGIN

@interface XMAtListViewController : UIViewController

@property (nonatomic, strong) NSArray *atArray;
@property (nonatomic, copy)void(^getAtUser) (NSString *name, NSString *uid);
/** <#name#> */
@property (nonatomic, strong) XMInputBar *inpuBar;
@end

NS_ASSUME_NONNULL_END
