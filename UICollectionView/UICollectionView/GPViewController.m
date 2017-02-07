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

static NSString *urlString = @"http://www.id-bear.com/app/idbear/more";
static NSString *token = @"token=5tZKCR0k3alRkcUVnak9ha0VTNzFkeE13ZURENE9FY3Y3dkZ1RGIwdEErSVhDbXNwVDgxZ2RCdEl4RGR3PT0=&id=d6ce2fa5551b5f323bdb805910427c73";
static NSString *cellIdentifier = @"cellIdentifier";

@interface GPViewController () <UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *dataSource;

@end

@implementation GPViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
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
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    request.HTTPMethod = @"POST";
    request.HTTPBody = [token dataUsingEncoding:NSUTF8StringEncoding];
    NSURLSessionTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSArray *dictArray = [jsonDict valueForKeyPath:@"pageListVo.rows"];
        for (NSDictionary *dict in dictArray) {
            NSDictionary *imageDict = [[dict valueForKeyPath:@"imageVos"] firstObject];
            GPPhotoModel *model = [GPPhotoModel modelWithDict:imageDict];
            [self.dataSource addObject:model];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.collectionView reloadData];
        });
    }];
    [task resume];
}

#pragma mark - Protocol

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.dataSource.count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    GPPhotoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    GPPhotoModel *model = self.dataSource[indexPath.row];
    cell.url =  model.imageSourceUrl;
    
    return cell;
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
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.dataSource = self;
        [_collectionView registerClass:[GPPhotoCell class] forCellWithReuseIdentifier:cellIdentifier];
        _collectionView.backgroundColor = [UIColor colorWithWhite:0.5 alpha:1.0f];
    }
    
    return _collectionView;
}

@end
