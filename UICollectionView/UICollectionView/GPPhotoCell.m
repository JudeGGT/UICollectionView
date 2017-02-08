//
//  GPPhotoCell.m
//  UICollectionView
//
//  Created by ggt on 2017/2/7.
//  Copyright © 2017年 GGT. All rights reserved.
//

#import "GPPhotoCell.h"
#import "Masonry.h"
#import "UIImageView+WebCache.h"

@interface GPPhotoCell ()

@property (nonatomic, weak) UIImageView *imgView;

@end

@implementation GPPhotoCell

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
    imgView.backgroundColor = [UIColor colorWithWhite:0.3 alpha:1.0f];
    [self.contentView addSubview:imgView];
    self.imgView = imgView;
    [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
}

- (void)setUrl:(NSString *)url {
    
    _url = url;
    
    [self.imgView sd_setImageWithURL:[NSURL URLWithString:url]];
}

@end
