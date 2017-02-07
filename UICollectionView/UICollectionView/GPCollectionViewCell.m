//
//  GPCollectionViewCell.m
//  UICollectionView
//
//  Created by ggt on 2017/2/6.
//  Copyright © 2017年 GGT. All rights reserved.
//

#import "GPCollectionViewCell.h"
#import "Masonry.h"

@interface GPCollectionViewCell ()

@property (nonatomic, weak) UIImageView *imgView;

@end

@implementation GPCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        [self setupUI];
    }
    
    return self;
}

#pragma mark - UI

- (void)setupUI {
    
    self.contentView.layer.cornerRadius = 10.0f;
    self.contentView.layer.masksToBounds = YES;
    
    UIImageView *imgView = [[UIImageView alloc] init];
    [self.contentView addSubview:imgView];
    self.imgView = imgView;
    [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
}

- (void)setImageName:(NSString *)imageName {
    
    _imageName = imageName;
    self.imgView.image = [UIImage imageNamed:imageName];
}

@end
