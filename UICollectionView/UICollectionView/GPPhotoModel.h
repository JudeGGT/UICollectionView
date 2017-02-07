//
//  GPPhotoModel.h
//  UICollectionView
//
//  Created by ggt on 2017/2/7.
//  Copyright © 2017年 GGT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GPPhotoModel : NSObject

@property (nonatomic, copy) NSString *imageSourceUrl; /**< 图片链接 */
@property (nonatomic, assign) CGFloat originalHeight; /**< 图片高度 */
@property (nonatomic, assign) CGFloat originalWidth; /**< 图片宽度 */

+ (instancetype)modelWithDict:(NSDictionary *)dict;
- (instancetype)initWithDict:(NSDictionary *)dict;

@end
