//
//  GPViewController.m
//  UICollectionView
//
//  Created by ggt on 2017/2/7.
//  Copyright © 2017年 GGT. All rights reserved.
//

#import "GPViewController.h"
#import "Masonry.h"
#import "GPPhotoModel.h"
#import "GPPhotoCell.h"
#import "GPWaterLayout.h"
#import "MJRefresh.h"

static NSString *urlString = @"http://www.id-bear.com/app/idbear/more";
static NSString *token = @"token=5tZKCR0k3alRkcUVnak9ha0VTNzFkeE13ZURENE9FY3Y3dkZ1RGIwdEErSVhDbXNwVDgxZ2RCdEl4RGR3PT0=&id=589f16b693629b4f2d036600a508e0b0";
static NSString *cellIdentifier = @"cellIdentifier";

@interface GPViewController () <UICollectionViewDataSource, UICollectionViewDelegate, GPWaterLayoutDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, assign) NSInteger currPage;

@end

@implementation GPViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.currPage = 1;
    self.view.backgroundColor = [UIColor whiteColor];
    [self requestData];
    [self setupUI];
    [self setConstraints];
}

#pragma mark - UI

- (void)setupUI {
    
    [self.view addSubview:self.collectionView];
}

#pragma mark - Constraints

- (void)setConstraints {
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

#pragma mark - Custom Accessors

#pragma mark - IBActions

#pragma mark - Public

#pragma mark - Private

/**
 网络请求数据
 */
- (void)requestData {
    
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSString *body = [NSString stringWithFormat:@"%@&currPage=%ld", token, (long)self.currPage];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    request.HTTPMethod = @"POST";
    request.HTTPBody = [body dataUsingEncoding:NSUTF8StringEncoding];
    NSURLSessionTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSArray *dictArray = [jsonDict valueForKeyPath:@"pageListVo.rows"];
        NSMutableArray *array = [NSMutableArray array];
        for (NSDictionary *dict in dictArray) {
            NSDictionary *imageDict = [[dict valueForKeyPath:@"imageVos"] firstObject];
            GPPhotoModel *model = [GPPhotoModel modelWithDict:imageDict];
            [array addObject:model];
        }
    
        dispatch_async(dispatch_get_main_queue(), ^{
            NSInteger j = self.dataSource.count;
            for (int i = 0; i < array.count; i++) {
                NSIndexPath *indexPath = [NSIndexPath indexPathForItem:(j + i) inSection:0];
                [self.dataSource addObject:array[i]];
                [self.collectionView insertItemsAtIndexPaths:@[indexPath]];
            }
            [self.collectionView.mj_footer endRefreshing];
        });
    }];
    [task resume];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.dataSource.count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    GPPhotoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    GPPhotoModel *model = self.dataSource[indexPath.row];
    cell.url =  model.imageUrl;
    
    return cell;
}

#pragma mark - UICollectionViewDelegate

#pragma mark - GPWaterLayoutDelegate

- (CGFloat)collectionViewLayout:(GPWaterLayout *)layout withWidth:(CGFloat)width andIndex:(NSIndexPath *)indexPath {
    
    GPPhotoModel *model = self.dataSource[indexPath.item];
    CGFloat height = width * (model.originalHeight / model.originalWidth);
    return height;
}

#pragma mark - Lazy

- (NSMutableArray *)dataSource {
    
    if (_dataSource == nil) {
        _dataSource = [[NSMutableArray alloc] init];
    }
    
    return _dataSource;
}

- (UICollectionView *)collectionView {
    
    if (_collectionView == nil) {
        
        GPWaterLayout *layout = [[GPWaterLayout alloc] init];
        layout.delegate = self;
        layout.columnCount = 2;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        [_collectionView registerClass:[GPPhotoCell class] forCellWithReuseIdentifier:cellIdentifier];
        _collectionView.backgroundColor = [UIColor colorWithWhite:0.5 alpha:1.0f];
        MJRefreshAutoFooter *footer = [MJRefreshAutoFooter footerWithRefreshingBlock:^{
            self.currPage++;
            [self requestData];
        }];
        _collectionView.mj_footer = footer;
    }
    
    return _collectionView;
}

@end
