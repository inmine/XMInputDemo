//
//  XMConfig.h
//  XMInputDemo
//
//  Created by XM on 2022/5/5.
//

#import <Foundation/Foundation.h>
#import "XMFaceGroup.h"
#import "XMFaceCellData.h"

NS_ASSUME_NONNULL_BEGIN

#define kScreen_Width        [UIScreen mainScreen].bounds.size.width
#define kScreen_Height       [UIScreen mainScreen].bounds.size.height
#define kIs_IPhone           (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define kIs_IPhoneX          (kScreen_Width >=375.0f && kScreen_Height >=812.0f && kIs_IPhone)
#define kTabBar_Height       (kIs_IPhoneX ? (49.0 + 34.0):(49.0))
#define kBottom_SafeHeight   (kIs_IPhoneX ? (34.0):(0))

#define kInputBar_Height     60
#define kInputBar_VertMargin 10
#define kInputBar_HorzMargin 12
#define kInputBar_Button_Size CGSizeMake(36, 36)
#define kTextView_TextView_Height_Max 80
#define kTextView_TextView_Height_Min (kInputBar_Height - 2*kInputBar_VertMargin)

#define kFaceView_Height     289

#define kTextView_TextView_Input_Count_Max 100

#define kColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 \
alpha:1.0]

#define XMInputAtStartChar  @"@"
#define XMInputAtEndChar    @"\u2004"  // 空格

@interface XMConfig : NSObject

/**
 *  获取 Config 实例
 */
+ (XMConfig *)defaultConfig;

/**
 * 表情列表
 */
@property (nonatomic, strong) NSArray<XMFaceGroup *> *faceGroups;

/**
 * 表情cache
 */
@property (nonatomic, strong) NSCache *emojiCache;

@end

NS_ASSUME_NONNULL_END
