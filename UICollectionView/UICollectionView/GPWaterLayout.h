//
//  GPWaterLayout.h
//  UICollectionView
//
//  Created by ggt on 2017/2/4.
//  Copyright © 2017年 GGT. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GPWaterLayout;

@protocol GPWaterLayoutDelegate <NSObject>

- (CGFloat)collectionViewLayout:(GPWaterLayout *)layout withWidth:(CGFloat)width andIndex:(NSIndexPath *)indexPath;

@end

@interface GPWaterLayout : UICollectionViewLayout

@property (nonatomic, assign) CGFloat columnCount; /**< 显示多少列 */
@property (nonatomic, assign) UIEdgeInsets collectionViewMargin; /**< 边框间距 */
@property (nonatomic, assign) CGFloat rowMargin; /**< 每行的间距 */
@property (nonatomic, assign) CGFloat columnMargin; /**< 每列的间距 */
@property (nonatomic, weak) id <GPWaterLayoutDelegate> delegate; /**< 协议 */

@end
