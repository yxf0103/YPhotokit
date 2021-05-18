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

@property (nonatomic,weak)UICollectionView *assetCollectionView;
@property (nonatomic,weak)UIButton *sendBtn;

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
}
#pragma mark - ui
-(void)setupUI{
    self.navigationItem.title = _album.album.localizedTitle;
    self.view.backgroundColor = [UIColor whiteColor];
    
    CGFloat bottomHeight = KYTABBARHEIGHT;
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, KYSCREENHEIGHT - bottomHeight, KYSCREENWIDTH, bottomHeight)];
    [self.view addSubview:bottomView];
    bottomView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.8];
    UIButton *sendBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [bottomView addSubview:sendBtn];
    [sendBtn setTitle:@"发送" forState:UIControlStateNormal];
    [sendBtn setTitleColor:KYColorRGB(0xff6542) forState:UIControlStateNormal];
    [sendBtn setTitleColor:KYColorRGB(0xe5e5ea) forState:UIControlStateDisabled];
    sendBtn.frame = CGRectMake(KYSCREENWIDTH - 10 - 45, 10, 45, 30);
    [sendBtn addTarget:self action:@selector(sendBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    sendBtn.enabled = NO;
    _sendBtn = sendBtn;
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.sectionInset = UIEdgeInsetsMake(KYAssetMargin, KYAssetMargin, KYAssetMargin, KYAssetMargin);
    CGFloat length = KYAssetItemLength;
    layout.itemSize = CGSizeMake(length, length);
    layout.minimumInteritemSpacing = 0;
    layout.minimumLineSpacing = KYAssetMargin;
    UICollectionView *assetView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, KYNAVIHEIGHT, KYSCREENWIDTH, KYSCREENHEIGHT - KYNAVIHEIGHT - bottomHeight) collectionViewLayout:layout];
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
        [KYPhotoSourceManager getAssetsFromAlbum:_album complete:^(NSArray<KYAsset *> * _Nullable assets) {
            [ws loadDataComplete];
            ws.assets = assets;
            [ws.assetCollectionView reloadData];
        }];
    }
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
        _sendBtn.enabled = self.selArray.count > 0;
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
    _sendBtn.enabled = self.selArray.count > 0;
}

-(void)sendBtnClicked:(UIButton *)btn{
    if (self.selArray.count == 0) {
        return;
    }
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    [_assetDelegate assetsVc:self sendImgs:self.selArray];
}

#pragma mark - KYPhotoLoadingDataProtocol
-(void)startLoadingData{
    [self.hud startAnimation];
}
-(void)loadDataComplete{
    [self.hud stopAnimation];
}

#pragma mark - KYImageScannerViewControllerDelegate
-(void)scannerVc:(KYImageScannerViewController *)scannerVc alphaChanged:(double)alpha{
    self.showStatusBar = alpha > 0.3;
}

- (CGRect)scannerVc:(KYImageScannerViewController *)scannerVc dismissAtIndex:(NSInteger)index{
    KYAssetCell *cell = (KYAssetCell *)[_assetCollectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0]];
    return [_assetCollectionView convertRect:cell.frame toView:[UIApplication sharedApplication].keyWindow];
}

-(void)scannerVc:(KYImageScannerViewController *)scannerVc selectItem:(NSInteger)index status:(BOOL)selected{
    KYAsset *asset = _assets[index];
    asset.selected = selected;
}

@end
