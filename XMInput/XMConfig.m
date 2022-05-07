//
//  XMConfig.m
//  XMInputDemo
//
//  Created by XM on 2022/5/5.
//

#import "XMConfig.h"

@implementation XMConfig

+ (XMConfig *)defaultConfig {
    static dispatch_once_t onceToken;
    static XMConfig *config;
    dispatch_once(&onceToken, ^{
        config = [[XMConfig alloc] init];
    });
    return config;
}

- (instancetype)init {
    if(self == [super init]){
        [self defaultFace];
    }
    return self;
}

- (void)defaultFace {
    NSMutableArray *faceGroups = [NSMutableArray array];
    // emoji group
    NSMutableArray *emojiFaces = [NSMutableArray array];
    NSString *path = [[NSBundle mainBundle] pathForResource:@"emoji" ofType:@"plist"];
    NSArray *emojis = [NSArray arrayWithContentsOfFile:path];
    for (NSDictionary *dic in emojis) {
        XMFaceCellData *data = [[XMFaceCellData alloc] init];
        NSString *faceId = [dic objectForKey:@"face_id"];
        NSString *name = [dic objectForKey:@"face_name"];
        data.faceId = faceId;
        data.name = name;
        data.path = name;
        [emojiFaces addObject:data];
        [self.emojiCache setObject:data forKey:data.name];
    }
    if(emojiFaces.count != 0){
        XMFaceGroup *emojiGroup = [[XMFaceGroup alloc] init];
        emojiGroup.groupIndex = 0;
        emojiGroup.groupPath = @"";
        emojiGroup.faces = emojiFaces;
        emojiGroup.rowCount = 3;
        emojiGroup.itemCountPerRow = 9;
        emojiGroup.needBackDelete = YES;
        emojiGroup.menuPath = @"";
        [faceGroups addObject:emojiGroup];
    }
    self.faceGroups = faceGroups;
}

#pragma mark - 懒加载
- (NSCache *)emojiCache{
    if (!_emojiCache) {
        _emojiCache = [[NSCache alloc] init];
    }
    return _emojiCache;
}

@end
