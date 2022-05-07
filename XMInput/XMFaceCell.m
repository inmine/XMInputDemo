//
//  XMFaceCell.m
//  XMInputDemo
//
//  Created by XM on 2022/5/5.
//

#import "XMFaceCell.h"

@implementation XMFaceCell

- (instancetype)initWithFrame:(CGRect)frame {
    if(self == [super initWithFrame:frame]){
        [self setupViews];
    }
    return self;
}

- (void)setupViews {
    UIImageView *face = [[UIImageView alloc] init];
    face.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:face];
    self.face = face;
}

- (void)setData:(XMFaceCellData *)data {
    UIImage *image = [UIImage imageNamed:data.name];
    self.face.image = image;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.face.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
}

@end
