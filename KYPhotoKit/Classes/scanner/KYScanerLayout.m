//
//  KYScanerLayout.m
//  KYPhotoKit
//
//  Created by yxf on 2018/5/9.
//

#import "KYScanerLayout.h"

@interface KYScanerLayout ()

@property (nonatomic,assign)CGSize scanSize;

@property (nonatomic,assign)CGFloat margin;

@property (nonatomic,strong)NSMutableArray<UICollectionViewLayoutAttributes *> *attFrames;

@end

@implementation KYScanerLayout

+(instancetype)initWithItemSize:(CGSize)size margin:(CGFloat)margin{
    KYScanerLayout *layout = [[KYScanerLayout alloc] init];
    layout.scanSize = size;
    layout.margin = margin;
    return layout;
}

-(NSMutableArray *)attFrames{
    if (!_attFrames) {
        _attFrames = [NSMutableArray array];
    }
    return _attFrames;
}

-(void)prepareLayout{
    [super prepareLayout];
    [self.attFrames removeAllObjects];
    NSInteger itemCount = [self.collectionView numberOfItemsInSection:0];
    for (int i=0; i<itemCount; i++){
        UICollectionViewLayoutAttributes *attributes = [self layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForItem:i inSection:0]];
        [self.attFrames addObject:attributes];
    }
}


//核心方法，设置每个item的frame
-(UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath{
    //获取当前最小maxY的列
    CGFloat margin = indexPath.item == 0 ? 0 : self.margin;
    CGFloat currentY = 0;
    CGFloat currentX = CGRectGetMaxX(self.attFrames.lastObject.frame) + margin;
    CGFloat width = self.scanSize.width;
    CGFloat height = self.scanSize.height;
    CGRect currentFrame = CGRectMake(currentX, currentY, width, height);
    UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    attributes.frame = currentFrame;
    return attributes;
}

-(CGSize)collectionViewContentSize{
    return CGSizeMake(CGRectGetMaxX(self.attFrames.lastObject.frame), 0);
}

-(NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect{
    return self.attFrames;
}


@end
