//
//  XMFaceGroup.h
//  XMInputDemo
//
//  Created by XM on 2022/5/5.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XMFaceGroup : NSObject

/**
 *  表情组索引号，从0开始。
 */
@property (nonatomic, assign) int groupIndex;

/**
 *  表情组路径
 *  用于保存表情组在系统中存放的路径。
 */
@property (nonatomic, strong) NSString *groupPath;

/**
 *  表情组总行数
 *  用于计算表情总数，进而定位每一个表情。
 */
@property (nonatomic, assign) int rowCount;

/**
 *  每行所包含的表情数
 *  用于计算表情总数，进而定位每一个表情。
 */
@property (nonatomic, assign) int itemCountPerRow;

/**
 *  表情信息组
 *  存储各个表情的 cellData
 */
@property (nonatomic, strong) NSMutableArray *faces;

/**
 *  删除标志位
 *  对于需要“删除”按钮的表情组，该位为 YES，否则为 NO。
 *  当该位为 YES 时，FaceView 会在表情视图右下角中显示一个“删除”图标，使您无需呼出键盘即可进行表情的删除操作。
 */
@property (nonatomic, assign) BOOL needBackDelete;

/**
 *  表情menu路径
 *  用于存储表情菜单在系统中存放的路径。
 *  表情菜单即在表情视图最下方显示表情组缩略图与“发送按钮”的菜单视图。
 */
@property (nonatomic, strong) NSString *menuPath;

@end

NS_ASSUME_NONNULL_END
