//
//  GPPhotoLayout.m
//  UICollectionView
//
//  Created by ggt on 2017/2/6.
//  Copyright © 2017年 GGT. All rights reserved.
//

#import "GPPhotoLayout.h"

static NSUInteger ZIndex = 1000;
static NSUInteger gap = 20;
static NSUInteger itemWH = 100;

@implementation GPPhotoLayout

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    
    return YES;
}

/**
 设置CollectionView的滚动范围

 @return 滚动范围
 */
- (CGSize)collectionViewContentSize {
    
    NSInteger sectionCount = [self.collectionView numberOfSections] - 1;
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:sectionCount];
    
    UICollectionViewLayoutAttributes *attributes = [self layoutAttributesForItemAtIndexPath:indexPath];
    
    CGFloat maxY = CGRectGetMaxY(attributes.frame) + gap;
    
    return CGSizeMake(0, maxY);
}

/**
 设置每个Item的属性
 */
- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    
    attributes.size = CGSizeMake(itemWH, itemWH);
    
    CGFloat centerX = indexPath.section % 2 == 1 ? self.collectionView.bounds.size.width * 0.75 : self.collectionView.bounds.size.width * 0.25;
    CGFloat centerY = (attributes.size.height + gap) * (indexPath.section / 2) + gap + attributes.size.height * 0.5;
    
    switch (indexPath.item) {
        case 0:
            attributes.center = CGPointMake(centerX, centerY);
            attributes.zIndex = ZIndex - indexPath.item;
            break;
        case 1:
            attributes.center = CGPointMake(centerX - 30, centerY);
            attributes.zIndex = ZIndex - indexPath.item;
            attributes.transform3D = CATransform3DMakeScale(0.8, 0.8, 1.0f);
            break;
        case 2:
            attributes.center = CGPointMake(centerX + 30, centerY);
            attributes.zIndex = ZIndex - indexPath.item;
            attributes.transform3D = CATransform3DMakeScale(0.8, 0.8, 1.0f);
            break;
        default:
            attributes.center = CGPointMake(centerX, centerY);
            attributes.hidden = YES;
            break;
    }
    
    return attributes;
}

/**
 返回属性数组
 */
- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSMutableArray *array = [NSMutableArray array];
    NSInteger sectionCount = [self.collectionView numberOfSections];
    for (int i = 0; i < sectionCount; i++) {
        NSInteger count = [self.collectionView numberOfItemsInSection:i];
        for (int j = 0; j < count; j++) {
            UICollectionViewLayoutAttributes *attrs = [self layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForItem:j inSection:i]];
            [array addObject:attrs];
        }
    }
    
    return array;
}

@end
