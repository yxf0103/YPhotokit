//
//  KYAssetsViewController.m
//  KYPhotoKit
//
//  Created by yxf on 2018/5/4.
//

#import "KYAssetsViewController.h"
#import "KYPhotoSourceManager.h"
#import "KYAssetCell.h"
#import "KYPhotoNaviViewController.h"
#import "KYHud.h"
#import "KYDisplayMacro.h"
#import "KYAsset+Action.h"

@implementation KYAssetviewModel

@end

@interface KYAssetsViewController ()<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

/*album*/
@property (nonatomic,strong)KYAlbum *album;

/*图片信息表格*/
@property (nonatomic,weak)UICollectionView *assetCollectionView;

/*assets*/
@property (nonatomic,strong)NSArray *assets;

@property (nonatomic,weak)KYHud *hud;

///选中的图片
@property (nonatomic,strong)NSMutableArray *selArray;

@end

static NSInteger const ky_max_sel_asset_num = 9;

@implementation KYAssetsViewController

-(instancetype)init{
    return [self initWithAlbum:nil];
}

-(instancetype)initWithAlbum:(KYAlbum *)album{
    if(self = [super init]){
        _album = album;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
    
    [self loadData];
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
}
#pragma mark - ui
-(void)setupUI{
    self.navigationItem.title = _album.album.localizedTitle;
    self.view.backgroundColor = [UIColor whiteColor];
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.sectionInset = UIEdgeInsetsMake(KYAssetMargin, KYAssetMargin, KYAssetMargin, KYAssetMargin);
    CGFloat length = KYAssetItemLength;
    layout.itemSize = CGSizeMake(length, length);
    layout.minimumInteritemSpacing = 0;
    layout.minimumLineSpacing = KYAssetMargin;
    UICollectionView *assetView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
    [self.view addSubview:assetView];
    [assetView registerClass:[KYAssetCell class] forCellWithReuseIdentifier:KYAssetCellIdentifier];
    _assetCollectionView = assetView;
    assetView.delegate = self;
    assetView.dataSource = self;
    assetView.backgroundColor = [UIColor whiteColor];
}

#pragma mark - data
-(void)loadData{
    if (_album) {
        __weak typeof(self) ws = self;
        [self startLoadingData];
        CGFloat width = KYAssetItemLength * KYSCREENSCALE;
        [KYPhotoSourceManager getAssetsFromAlbum:_album imageSize:CGSizeMake(width, width) complete:^(NSArray<KYAsset *> *assets) {
            [ws loadDataComplete];
            ws.assets = assets;
            [ws.assetCollectionView reloadData];
        }];
    }
}

#pragma mark - UICollectionViewDataSource,UICollectionViewDelegateFlowLayout
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSMutableArray *assetviewModels = [NSMutableArray array];
    UIWindow *keywindow = [UIApplication sharedApplication].delegate.window;
    for (int i=0; i<_assets.count; i++) {
        NSIndexPath *cellIndexPath = [NSIndexPath indexPathForItem:i inSection:0];
        UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:cellIndexPath];
        CGRect frame = [cell convertRect:cell.bounds toView:keywindow];
        KYAssetviewModel *viewmodel = [[KYAssetviewModel alloc] init];
        viewmodel.asset = _assets[i];
        viewmodel.originFrame = frame;
        [assetviewModels addObject:viewmodel];
    }
    if ([_assetDelegate respondsToSelector:@selector(assetsViewController:allAssets:selectAssetAtIndex:)]) {
        [_assetDelegate assetsViewController:self
                                   allAssets:assetviewModels
                          selectAssetAtIndex:indexPath.item];
    }
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    KYAssetCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:KYAssetCellIdentifier forIndexPath:indexPath];
    cell.asset = _assets[indexPath.item];
    __weak typeof(self) ws = self;
    cell.bindSelectAction = ^(KYAsset *asset, BOOL isSelected) {
        [ws asset:asset selChanged:isSelected];
    };
    return cell;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _assets.count;
}

#pragma mark - custom func
-(void)asset:(KYAsset *)asset selChanged:(BOOL)isSelected{
    if (isSelected) {
        if (self.selArray.count >= ky_max_sel_asset_num) {
            asset.selected = NO;
            return;
        }
        [self.selArray addObject:asset];
        asset.number = self.selArray.count;
        return;
    }
    NSInteger index = [self.selArray indexOfObject:asset];
    if (index == NSNotFound) {
        KYLog(@"错误:找不到:%ld",(long)_selArray.count);
        return;
    }
    for (NSInteger i=index+1; i<self.selArray.count; i++) {
        KYAsset *nextAsset = self.selArray[i];
        nextAsset.number -= 1;
    };
    [self.selArray removeObject:asset];
    asset.number = 0;
}

#pragma mark - KYPhotoLoadingDataProtocol
-(void)startLoadingData{
    [self.hud startAnimation];
}
-(void)loadDataComplete{
    [self.hud stopAnimation];
}

#pragma mark - getter
-(KYHud *)hud{
    if (!_hud) {
        KYHud *hud = [[KYHud alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
        hud.center = CGPointMake(KYSCREENWIDTH / 2, KYNAVIHEIGHT + 200);
        [self.view addSubview:hud];
        _hud = hud;
    }
    return _hud;
}

-(NSMutableArray *)selArray{
    if (!_selArray) {
        _selArray = [NSMutableArray array];
    }
    return _selArray;
}

#pragma mark - KYImageScannerViewControllerDelegate
-(void)scannerVcWillPresent:(KYImageScannerViewController *)scannerVc{}

-(void)scannerVcWillDismiss:(KYImageScannerViewController *)scannerVc{}

- (CGRect)scannerVc:(KYImageScannerViewController *)scannerVc dismissAtIndex:(NSInteger)index{
    KYAssetCell *cell = (KYAssetCell *)[_assetCollectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0]];
    return [_assetCollectionView convertRect:cell.frame toView:[UIApplication sharedApplication].keyWindow];
}

@end
