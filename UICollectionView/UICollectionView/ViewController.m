//
//  ViewController.m
//  UICollectionView
//
//  Created by ggt on 2017/2/4.
//  Copyright © 2017年 GGT. All rights reserved.
//

#import "ViewController.h"
#import "GPLineLayout.h"
#import "Masonry.h"
#import "GPCollectionViewCell.h"
#import "GPPhotoLayout.h"

static NSString *itemIdentifier = @"item";

@interface ViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSArray *dataSource;

@end

@implementation ViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupUI];
    [self setConstraints];
}

#pragma mark - UI

/**
 UI
 */
- (void)setupUI {
    
    // CollectionView
    [self.view addSubview:self.collectionView];
}

#pragma mark - Constraints

/**
 设置约束
 */
- (void)setConstraints {
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

#pragma mark - Custom Accessors

#pragma mark - IBActions

#pragma mark - Public

#pragma mark - Private

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.dataSource.count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return 30;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    GPCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:itemIdentifier forIndexPath:indexPath];
    cell.imageName = self.dataSource[indexPath.item];
    
    return cell;
}

#pragma mark - UICollectionViewDelegate

#pragma mark - UICollectionViewDelegateFlowLayout

#pragma mark - Lazy

- (UICollectionView *)collectionView {
    
    if (_collectionView == nil) {
        
        GPPhotoLayout *flowLayout = [[GPPhotoLayout alloc] init];
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.translatesAutoresizingMaskIntoConstraints = NO;
        [_collectionView registerClass:[GPCollectionViewCell class] forCellWithReuseIdentifier:itemIdentifier];
        _collectionView.backgroundColor = [UIColor colorWithRed:110/255.0f green:110/255.0f blue:110/255.0f alpha:1.0f];
        _collectionView.showsHorizontalScrollIndicator = NO;
    }
    
    return _collectionView;

}

- (NSArray *)dataSource {
    
    if (_dataSource == nil) {
        NSMutableArray *arra = [NSMutableArray array];
        for (int i = 1; i <= 20; i++) {
            [arra addObject:[NSString stringWithFormat:@"%d", i]];
        }
        _dataSource = arra;
    }
    
    return _dataSource;

}

@end
