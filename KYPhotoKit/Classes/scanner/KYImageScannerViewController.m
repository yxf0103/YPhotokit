//
//  KYImageScannerViewController.m
//  KYPhotoKit
//
//  Created by yxf on 2018/5/4.
//

#import "KYImageScannerViewController.h"
#import "KYImageScannerCell.h"
#import "KYScanerLayout.h"
#import "KYScannerPresentModel.h"
#import "KYPhotoSourceTool.h"
#import "KYScannerImage.h"

#define KYScannerMargin 10

@interface KYImageScannerViewController ()<UICollectionViewDelegateFlowLayout,
UICollectionViewDataSource,
KYImageScannerCellDelegate>{
    UIButton *_selBtn;
    UIButton *_sendBtn;
}

@property (nonatomic,weak)UICollectionView *imageCollectionView;

@property (nonatomic,strong)KYScannerImage *currentImg;

@end

@implementation KYImageScannerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor clearColor];
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat height = [UIScreen mainScreen].bounds.size.height;
    
    //images
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
    [self addTopView];
//    [self addBottomview];
    
    [collectionView reloadData];
    if (_images.count > _index) {
        collectionView.contentOffset = CGPointMake(_index * (width + KYScannerMargin), 0);
        _currentImg = _images[_index];
        _selBtn.selected = _currentImg.imgSelected;
    }
}

-(void)addTopView{
    UIView *topBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KYSCREENWIDTH, 64)];
    topBar.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.8];
    [self.view addSubview:topBar];
    
    UIButton *popbackBtn = [self btnWithImg:@"navigationbar_icon_back_white"
                                     selImg:@""
                                     action:@selector(popBackBtnClicked)];
    [topBar addSubview:popbackBtn];
    popbackBtn.frame = CGRectMake(10, 20, 44, 44);
    
    UIButton *selBtn = [self btnWithImg:@"tag_normal"
                                 selImg:@"tag_sel"
                                 action:@selector(selectBtnClicked:)];
    [topBar addSubview:selBtn];
    selBtn.frame = CGRectMake(KYSCREENWIDTH - 10 - 44, 20, 44, 44);
    _selBtn = selBtn;
}

-(void)addBottomview{
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
}

-(UIButton *)btnWithImg:(NSString *)img selImg:(NSString *)selImg action:(SEL)action{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *image = [KYPhotoSourceTool imageWithName:img
                                                 type:@"png"];
    [btn setImage:image forState:UIControlStateNormal];
    if (selImg.length > 0) {
        image = [KYPhotoSourceTool imageWithName:selImg
                                            type:@"png"];
        [btn setImage:image forState:UIControlStateSelected];
    }
    btn.imageEdgeInsets = UIEdgeInsetsMake(7, 7, 7, 7);
    [btn addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    return btn;
}

-(BOOL)prefersStatusBarHidden{
    return YES;
}

#pragma mark - action
-(void)popBackBtnClicked{
    KYScannerPresentModel *model = [self.transitioningDelegate animationControllerForDismissedController:self];
    model.popBack = YES;
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)selectBtnClicked:(UIButton *)btn{
    NSInteger index = [_images indexOfObject:_currentImg];
    if (index == NSNotFound) {
        return;
    }
    if ([_scannerDelegate scannerVc:self shouldChangeItemStateAtIndex:index]) {
        btn.selected = !btn.isSelected;
        _currentImg.imgSelected = btn.isSelected;
    }
}

-(void)sendBtnClicked:(UIButton *)btn{
    
    UIViewController *parentVC = self.presentingViewController;
    UIViewController *bottomVC;
    while (parentVC) {
        bottomVC = parentVC;
        parentVC = parentVC.presentingViewController;
    }
    [bottomVC dismissViewControllerAnimated:YES completion:nil];
    
    //发送图片
    
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

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    [self scrollViewDidEndScrollingAnimation:scrollView];
}

-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    NSInteger index = (scrollView.contentOffset.x + 10) / KYSCREENWIDTH;
    if (index < 0 || index >= _images.count) {
        return;
    }
    _currentImg = _images[index];
    _selBtn.selected = _currentImg.imgSelected;
}


#pragma mark - KYImageScannerCellDelegate
-(void)imgScannerCell:(KYImageScannerCell *)cell alphaChangedWithRate:(CGFloat)rate{
    self.view.superview.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:rate];
    [_scannerDelegate scannerVc:self alphaChanged:rate];
}

-(void)imgScannerCell:(KYImageScannerCell *)cell dismissWithImg:(UIImage *)image windowFrame:(CGRect)windowFrame{
    KYScannerPresentModel *model = [self.transitioningDelegate animationControllerForDismissedController:self];
    model.touchImage = image;
    model.touchFrame = windowFrame;
    if ([_scannerDelegate respondsToSelector:@selector(scannerVc:dismissAtIndex:)]) {
        NSInteger index = [_imageCollectionView indexPathForCell:cell].item;
        model.destFrame = [_scannerDelegate scannerVc:self dismissAtIndex:index];
    }
    model.popBack = NO;
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
