//
//  XMFaceView.m
//  XMInputDemo
//
//  Created by XM on 2022/5/5.
//

#import "XMFaceView.h"
#import "XMFaceCell.h"
#import "XMFaceGroup.h"

#define XMFaceCell_ReuseId @"XMFaceCell"

@interface XMFaceView () <UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) NSArray *faceGroups;
@property (nonatomic, strong) NSMutableArray *sectionIndexInGroup;
@property (nonatomic, strong) NSMutableArray *groupIndexInSection;
@property (nonatomic, strong) NSMutableDictionary *itemIndexs;
@property (nonatomic, assign) NSInteger sectionCount;
@property (nonatomic, assign) NSInteger curGroupIndex;
@end

@implementation XMFaceView

- (instancetype)initWithFrame:(CGRect)frame {
    if(self == [super initWithFrame:frame]){
        [self setupViews];
    }
    return self;
}

- (void)setupViews {
    self.backgroundColor = kColorFromRGB(0xF6F7F9);

    UICollectionViewFlowLayout *faceFlowLayout = [[UICollectionViewFlowLayout alloc] init];
    faceFlowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    faceFlowLayout.minimumLineSpacing = 12;
    faceFlowLayout.minimumInteritemSpacing = 0;
    faceFlowLayout.sectionInset = UIEdgeInsetsMake(14, 14, 60, 14);
    faceFlowLayout.itemSize = CGSizeMake((kScreen_Width - faceFlowLayout.sectionInset.left - faceFlowLayout.sectionInset.right)/7.0, 36);

    UICollectionView *faceCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:faceFlowLayout];
    faceCollectionView.frame = self.bounds;
    faceCollectionView.collectionViewLayout = faceFlowLayout;
    faceCollectionView.delegate = self;
    faceCollectionView.dataSource = self;
    faceCollectionView.showsHorizontalScrollIndicator = NO;
    faceCollectionView.showsVerticalScrollIndicator = NO;
    faceCollectionView.backgroundColor = self.backgroundColor;
    faceCollectionView.alwaysBounceHorizontal = NO;
    [self addSubview:faceCollectionView];
    self.faceCollectionView = faceCollectionView;
    
    [faceCollectionView registerClass:[XMFaceCell class] forCellWithReuseIdentifier:XMFaceCell_ReuseId];
    
    UIButton *deleteBtn = [[UIButton alloc] init];
    deleteBtn.backgroundColor = kColorFromRGB(0xF6F7F9);
    deleteBtn.frame = CGRectMake(kScreen_Width - 78, self.frame.size.height - 60, 78, 60);
    [deleteBtn setImage:[UIImage imageNamed:@"ic_emoji_delete"] forState:UIControlStateNormal];
    [deleteBtn addTarget:self action:@selector(deleteBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:deleteBtn];
}

- (void)setData:(NSArray *)data {
    _faceGroups = data;

//    _sectionIndexInGroup = [NSMutableArray array];
//    _groupIndexInSection = [NSMutableArray array];
//    _itemIndexs = [NSMutableDictionary dictionary];

//    NSInteger sectionIndex = 0;
//    for (NSInteger groupIndex = 0; groupIndex < _faceGroups.count; ++groupIndex) {
//        XMFaceGroup *group = _faceGroups[groupIndex];
//        [_sectionIndexInGroup addObject:@(sectionIndex)];
//        int itemCount = group.rowCount * group.itemCountPerRow;
//        int sectionCount = ceil(group.faces.count * 1.0 / (itemCount  - (group.needBackDelete ? 1 : 0)));
//        for (int sectionIndex = 0; sectionIndex < sectionCount; ++sectionIndex) {
//            [_groupIndexInSection addObject:@(groupIndex)];
//        }
//        sectionIndex += sectionCount;
//    }
//    _sectionCount = sectionIndex;


//    for (NSInteger curSection = 0; curSection < _sectionCount; ++curSection) {
//        NSNumber *groupIndex = _groupIndexInSection[curSection];
//        NSNumber *groupSectionIndex = _sectionIndexInGroup[groupIndex.integerValue];
//        XMFaceGroup *face = _faceGroups[groupIndex.integerValue];
//        NSInteger itemCount = face.rowCount * face.itemCountPerRow - face.needBackDelete;
//        NSInteger groupSection = curSection - groupSectionIndex.integerValue;
//        for (NSInteger itemIndex = 0; itemIndex < itemCount; ++itemIndex) {
//            // transpose line/row
//            NSInteger row = itemIndex % face.rowCount;
//            NSInteger column = itemIndex / face.rowCount;
//            NSInteger reIndex = face.itemCountPerRow * row + column + groupSection * itemCount;
//            [_itemIndexs setObject:@(reIndex) forKey:[NSIndexPath indexPathForRow:itemIndex inSection:curSection]];
//        }
//    }
    [_faceCollectionView reloadData];
}

#pragma mark - UICollectionViewDelegate,UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.faceGroups.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    XMFaceGroup *group = self.faceGroups[section];
    return group.faces.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    XMFaceCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:XMFaceCell_ReuseId forIndexPath:indexPath];
    XMFaceGroup *group = self.faceGroups[indexPath.section];
    XMFaceCellData *data = group.faces[indexPath.item];
    [cell setData:data];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if(self.delegate && [self.delegate respondsToSelector:@selector(faceView:didSelectItemAtIndexPath:)]){
        [self.delegate faceView:self didSelectItemAtIndexPath:indexPath];
    }
}

#pragma mark - click
- (void)deleteBtnClick:(UIButton *)sender {
    if(self.delegate && [self.delegate respondsToSelector:@selector(faceViewDidBackDelete:)]){
        [self.delegate faceViewDidBackDelete:self];
    }
}

@end
