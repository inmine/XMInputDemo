//
//  XMFaceView.h
//  XMInputDemo
//
//  Created by XM on 2022/5/5.
//

#import <UIKit/UIKit.h>
#import "XMConfig.h"

NS_ASSUME_NONNULL_BEGIN

@class XMFaceView;
@protocol XMFaceViewDelegate <NSObject>

/**
 *  选择某一具体表情后的回调（索引定位）。
 *  您可以通过该回调实现：当点击字符串类型的表情（如[微笑]）时，将表情添加到输入条。当点击其他类型的表情时，直接发送该表情。
 *
 *  @param faceView 委托者，表情视图。通常情况下表情视图只有且只有一个。
 *  @param indexPath 索引路径，定位表情。index.section：表情所在分组；index.row：表情所在行。
 */
- (void)faceView:(XMFaceView *)faceView didSelectItemAtIndexPath:(NSIndexPath *)indexPath;

/**
 *  点击表情视图中 删除 按钮后的操作回调。
 *  您可以通过该回调实现：在 inputBar 中删除整个表情字符串，比如，对于“[微笑]”，直接删除中括号以及括号中间的内容，而不是仅删除最右侧”]“。
 *
 *  @param faceView 委托者，表情视图，通常情况下表情视图只有且只有一个。
 */
- (void)faceViewDidBackDelete:(XMFaceView *)faceView;

@end

@interface XMFaceView : UIView

/**
 *  表情视图的 CollectionView
 *  包含多行表情，并配合 faceFlowLayout 进行灵活统一的视图布局。
 */
@property (nonatomic, strong) UICollectionView *faceCollectionView;

/**
 *  faceCollectionView 的流水布局
 *  配合 faceCollectionView，用来维护表情视图的布局，使表情排布更加美观。能够设置布局方向、行间距、cell 间距等。
 */
@property (nonatomic, strong) UICollectionViewFlowLayout *faceFlowLayout;

/**
 *  委托变量，被委托者
 *  需要实现 TFaceViewDelegate 协议中要求的功能。
 */
@property (nonatomic, weak) id<XMFaceViewDelegate> delegate;

/**
 *  滑动到指定表情分组。
 *  根据用户点击的表情分组的下标，切换到对应的表情分组下。
 *
 *  @param index 目的分组的组号索引，从0开始。
 */
- (void)scrollToFaceGroupIndex:(NSInteger)index;

/**
 *  设置数据。
 *  用来进行 TUIFaceView 的初始化或在需要时更新 faceView 中的数据。
 *
 *  @param data 需要设置的数据（TUIFaceGroup）。在此 NSMutableArray 中存放的对象为 TUIFaceGroup，即表情组。
 */
- (void)setData:(NSArray *)data;

@end

NS_ASSUME_NONNULL_END
