//
//  XMFaceCell.h
//  XMInputDemo
//
//  Created by XM on 2022/5/5.
//

#import <UIKit/UIKit.h>
#import "XMFaceCellData.h"
NS_ASSUME_NONNULL_BEGIN

@interface XMFaceCell : UICollectionViewCell

/**
 *  表情图像
 *  表情所对应的Image图像。
 */
@property (nonatomic, strong) UIImageView *face;

/**
 *  设置表情单元的数据
 *
 *  @param data 需要设置的数据源。
 */
- (void)setData:(XMFaceCellData *)data;

@end

NS_ASSUME_NONNULL_END
