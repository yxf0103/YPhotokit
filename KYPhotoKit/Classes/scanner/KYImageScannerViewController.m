//
//  KYImageScannerViewController.m
//  KYPhotoKit
//
//  Created by yxf on 2018/5/4.
//

#import "KYImageScannerViewController.h"
#import "KYImageScannerCell.h"
#import "KYScanerLayout.h"

#define KYScannerMargin 10

@interface KYImageScannerViewController ()<UICollectionViewDelegateFlowLayout,UICollectionViewDataSource,KYImageScannerCellDelegate>

@property (nonatomic,weak)UICollectionView *imageCollectionView;


@end

@implementation KYImageScannerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor clearColor];
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat height = [UIScreen mainScreen].bounds.size.height;
    CGRect frame = CGRectMake(0, 0, width, height);
    KYScanerLayout *layout = [KYScanerLayout initWithItemSize:frame.size margin:KYScannerMargin];
    frame.size.width += KYScannerMargin;
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:frame collectionViewLayout:layout];
    [self.view addSubview:collectionView];
    [collectionView registerClass:[KYImageScannerCell class] forCellWithReuseIdentifier:KYImageScannerCellId];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    collectionView.pagingEnabled = YES;
    collectionView.backgroundColor = [UIColor clearColor];
    _imageCollectionView = collectionView;
    [collectionView reloadData];
    if (_images.count > _index) {
        collectionView.contentOffset = CGPointMake(_index * (width + KYScannerMargin), 0);
    }
}

#pragma mark - show
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self showStatusBar];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self hideStatusBar];
}
#pragma mark - custom func
-(void)hideStatusBar{
    if ([self.ky_delegate respondsToSelector:@selector(scannerVcWillPresent:)]) {
        [self.ky_delegate scannerVcWillPresent:self];
    }
}

-(void)showStatusBar{
    if ([self.ky_delegate respondsToSelector:@selector(scannerVcWillDismiss:)]) {
        [self.ky_delegate scannerVcWillDismiss:self];
    }
}

#pragma mark - UICollectionViewDelegate,UICollectionViewDataSource
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _images.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    KYImageScannerCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:KYImageScannerCellId forIndexPath:indexPath];
    cell.scannerImg = _images[indexPath.item];
    cell.delegate = self;
    return cell;
}

#pragma mark - KYImageScannerCellDelegate
-(void)imgScannerCell:(KYImageScannerCell *)cell alphaChangedWithRate:(CGFloat)rate{
    if (rate == 1) {
        [self hideStatusBar];
    }else{
        [self showStatusBar];
    }
    self.view.superview.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:rate];
}

-(void)imgScannerCell:(KYImageScannerCell *)cell dismissWithImg:(UIImage *)image windowFrame:(CGRect)windowFrame{
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
