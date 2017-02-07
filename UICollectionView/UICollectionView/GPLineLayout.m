//
//  GPLineLayout.m
//  UICollectionView
//
//  Created by ggt on 2017/2/4.
//  Copyright © 2017年 GGT. All rights reserved.
//

#import "GPLineLayout.h"

static CGFloat ItemWH = 100;

@implementation GPLineLayout

/**
 初始化
 */
- (void)prepareLayout {
    [super prepareLayout];
    
    self.itemSize = CGSizeMake(ItemWH, ItemWH);
    self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.minimumLineSpacing = ItemWH;
    CGFloat inset = (self.collectionView.bounds.size.width - ItemWH) * 0.5;
    self.sectionInset = UIEdgeInsetsMake(0, inset, 0, inset);
}


/**
 设置CollectionView停止滚动的位置

 @param proposedContentOffset 原本的偏移量
 @param velocity 速度
 */
- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity {
    
    // 1.先计算可视范围
    CGRect lastRect;
    lastRect.origin = proposedContentOffset;
    lastRect.size = self.collectionView.bounds.size;
    
    // 2.计算中心X
    CGFloat centerX = proposedContentOffset.x + self.collectionView.bounds.size.width * 0.5;
    
    // 3.获取各个Item的属性
    NSArray *attributeArray = [self layoutAttributesForElementsInRect:lastRect];
    
    // 4.设置最小值
    CGFloat minX = MAXFLOAT;
    for (UICollectionViewLayoutAttributes *attribute in attributeArray) {
        
        if (ABS(attribute.center.x - centerX) < ABS(minX)) {
            minX = attribute.center.x - centerX;
        }
    }
    
    return CGPointMake(proposedContentOffset.x + minX, 0);
}

/**
 设置每次都可以刷新界面
 */
- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    
    return YES;
}

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    
    NSArray *attributesArray = [super layoutAttributesForElementsInRect:rect];
    // 计算屏幕的中心X位置
    CGFloat centerX = self.collectionView.contentOffset.x + self.collectionView.bounds.size.width * 0.5;
    CGFloat halfCenterX = centerX * 0.5;
    // 计算可视范围
    CGRect seeRect;
    seeRect.origin = self.collectionView.contentOffset;
    seeRect.size = self.collectionView.bounds.size;
    for (UICollectionViewLayoutAttributes *attributes in attributesArray) {
        // 如果当前屏幕没有显示则不计算
        if (!CGRectIntersectsRect(seeRect, attributes.frame)) continue;
        // 获取到Item的中心X
        CGFloat itemCenterX = attributes.center.x;
        itemCenterX = itemCenterX > halfCenterX ? itemCenterX : halfCenterX;
        // 计算缩放比例
        CGFloat scale = 1 + (0.6 - ABS(centerX - itemCenterX) / self.collectionView.bounds.size.width);
        // 设置Item
        attributes.transform3D = CATransform3DMakeScale(scale, scale, 1.0f);
    }
    
    return attributesArray;
}

@end
