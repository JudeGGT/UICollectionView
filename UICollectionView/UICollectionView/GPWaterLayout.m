//
//  GPWaterLayout.m
//  UICollectionView
//
//  Created by ggt on 2017/2/4.
//  Copyright © 2017年 GGT. All rights reserved.
//

#import "GPWaterLayout.h"

@interface GPWaterLayout ()

@property (nonatomic, strong) NSMutableDictionary *minYDict; /**< 存放Y最小值 */
@property (nonatomic, strong) NSArray *attributesArray;

@end

@implementation GPWaterLayout

- (instancetype)init {
    
    if (self = [super init]) {
        
        self.collectionViewMargin = UIEdgeInsetsMake(20, 10, 10, 10);
        self.columnCount = 3;
        self.rowMargin = 10;
        self.columnMargin = 10;
    }
    
    return self;
}

- (NSMutableDictionary *)minYDict {
    
    if (_minYDict == nil) {
        _minYDict = [[NSMutableDictionary alloc] init];
    }
    
    return _minYDict;
}

- (NSArray *)attributesArray {
    
    if (_attributesArray == nil) {
        _attributesArray = [[NSArray alloc] init];
    }
    
    return _attributesArray;
}

- (CGSize)collectionViewContentSize {
    
    // 先找出Y值最大的一列
    __block NSString *maxY = @"0";
    [self.minYDict enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull column, NSNumber *  _Nonnull minY, BOOL * _Nonnull stop) {
        if ([minY floatValue] > [self.minYDict[maxY] floatValue]) {
            maxY = column;
        }
    }];
    CGFloat height = [[self.minYDict objectForKey:maxY] floatValue] - self.rowMargin + self.collectionViewMargin.bottom;
    return CGSizeMake(0, height);
}


/**
 每次CollectionView布局都会调用此方法
 */
- (void)prepareLayout {
    [super prepareLayout];
    
    // 初始化存放最小值的字典
    for (int i = 0; i < self.columnCount; i++) {
        NSString *key = [NSString stringWithFormat:@"%d", i];
        [self.minYDict setObject:@(self.collectionViewMargin.top) forKey:key];
    }
    
    
    NSMutableArray *array = [NSMutableArray array];
    NSInteger sectionCount = [self.collectionView numberOfSections];
    for (int i = 0; i < sectionCount; i++) {
        NSInteger count = [self.collectionView numberOfItemsInSection:i];
        for (int j = 0; j < count; j++) {
            UICollectionViewLayoutAttributes *attrs = [self layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForItem:j inSection:i]];
            [array addObject:attrs];
        }
    }
    
    self.attributesArray = array;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    
    return YES;
}


/**
 设置Item出现动画
 */
- (UICollectionViewLayoutAttributes*)initialLayoutAttributesForAppearingItemAtIndexPath:(NSIndexPath *)itemIndexPath
{
    
    UICollectionViewLayoutAttributes *attr = [self layoutAttributesForItemAtIndexPath:itemIndexPath];
    
    attr.transform = CGAffineTransformRotate(CGAffineTransformMakeScale(0.5, 0.5), M_PI);
    attr.center = CGPointMake(CGRectGetMidX(self.collectionView.bounds), CGRectGetMaxY(self.collectionView.bounds));
    
    return attr;
}

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    
    return self.attributesArray;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    
    // 假设最短的那一列的第0列
    __block NSString *minColumn = @"0";
    // 找出最短的那一列
    [self.minYDict enumerateKeysAndObjectsUsingBlock:^(NSString *column, NSNumber *minY, BOOL *stop) {
        if ([minY floatValue] < [self.minYDict[minColumn] floatValue]) {
            minColumn = column;
        }
    }];
    
    // 计算宽度
    CGFloat width = (self.collectionView.bounds.size.width - self.collectionViewMargin.left - self.collectionViewMargin.right - self.columnMargin * (self.columnCount - 1)) / self.columnCount;
    // 计算高度
    CGFloat height = [self.delegate collectionViewLayout:self withWidth:width andIndex:indexPath];
    // 计算Y
    CGFloat y = [self.minYDict[minColumn] floatValue];
    // 计算X
    CGFloat x = self.collectionViewMargin.left + (width + self.columnMargin) * [minColumn integerValue];
    
    [self.minYDict setObject:@(y + height + self.rowMargin) forKey:minColumn];
    
    attributes.frame = CGRectMake(x, y, width, height);
    
    return attributes;
}

@end
