//
//  KYImageScannerCell.m
//  KYPhotoKit
//
//  Created by yxf on 2018/5/4.
//

#import "KYImageScannerCell.h"
#import "KYScannerImage.h"

NSString * const KYImageScannerCellId = @"KYImageScannerCellId";

@interface KYImageScannerCell()<UIScrollViewDelegate,UIGestureRecognizerDelegate>{
    CGPoint _panFirstTouchPoint;
    CGFloat _panTime;
}

/*bg scrollview*/
@property (nonatomic,weak)UIScrollView *bgScrollView;

/*image view*/
@property (nonatomic,weak)UIImageView *imgView;

/*pan*/
@property (nonatomic,weak)UIPanGestureRecognizer *panGesture;
/*刚接触时的坐标*/
@property (nonatomic,assign)CGPoint firstTouchPoint;

@end

@implementation KYImageScannerCell

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        UIScrollView *scrollView = [[UIScrollView alloc] init];
        [self.contentView addSubview:scrollView];
        scrollView.maximumZoomScale = 2.0;
        scrollView.delegate = self;
        scrollView.showsHorizontalScrollIndicator = NO;
        scrollView.showsVerticalScrollIndicator = NO;
        _bgScrollView = scrollView;
        
        UIImageView *imgView = [[UIImageView alloc] init];
        [scrollView addSubview:imgView];
        _imgView = imgView;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImg:)];
        [scrollView addGestureRecognizer:tap];
        
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panImg:)];
        [scrollView addGestureRecognizer:pan];
        pan.delegate = self;
        _panGesture = pan;
    }
    return self;
}

-(void)setScannerImg:(KYScannerImage *)scannerImg{
    _scannerImg = scannerImg;
    _bgScrollView.frame = self.contentView.bounds;
    _bgScrollView.zoomScale = 1.0;
    _bgScrollView.contentSize = CGSizeZero;
    _imgView.image = scannerImg.originImage;
    _imgView.frame = [KYImageScannerCell destFrameWithImage:scannerImg.originImage];
}

#pragma mark - UIScrollViewDelegate
-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    return _imgView;
}

//缩放图片的时候将图片放在中间
- (void)scrollViewDidZoom:(UIScrollView *)scrollView{
    CGFloat offsetX = (scrollView.bounds.size.width > scrollView.contentSize.width)?
    (scrollView.bounds.size.width - scrollView.contentSize.width) * 0.5 : 0.0;
    CGFloat offsetY = (scrollView.bounds.size.height > scrollView.contentSize.height)?
    (scrollView.bounds.size.height - scrollView.contentSize.height) * 0.5 : 0.0;
    self.imgView.center = CGPointMake(scrollView.contentSize.width * 0.5 + offsetX,
                                      scrollView.contentSize.height * 0.5 + offsetY);
}

#pragma mark - gesture
-(IBAction)tapImg:(UITapGestureRecognizer *)tapGesture{
    self.bgScrollView.zoomScale = 1.0;
    self.bgScrollView.contentSize = CGSizeZero;
    [self hideAction];
}

-(IBAction)panImg:(UIPanGestureRecognizer *)panGesture{
    CGPoint point = [panGesture translationInView:self.window];
    switch (panGesture.state) {
        case UIGestureRecognizerStateBegan:
            _panFirstTouchPoint = point;
            _panTime = CFAbsoluteTimeGetCurrent();
            break;
        case UIGestureRecognizerStateChanged:{
            //缩放比例(背景的渐变比例)
            CGFloat screenH = [UIScreen mainScreen].bounds.size.height;
            CGFloat scaleRate = 1 - 2 * point.y / screenH;
            if (scaleRate > 1) {
                scaleRate = 1;
            }
            //设置最小的缩放比例为0.5
            if (scaleRate < 0.5) {
                scaleRate = 0.5;
            }
            
            CGAffineTransform transform1 = CGAffineTransformMakeTranslation((point.x - _panFirstTouchPoint.x), (point.y - _panFirstTouchPoint.y));
            self.imgView.transform = CGAffineTransformScale(transform1, scaleRate, scaleRate);
            [self alphaAction:scaleRate];
        }
            break;
        case UIGestureRecognizerStateEnded:{
            CGFloat endTime = CFAbsoluteTimeGetCurrent();
            if (endTime - _panTime > 1) {
                [UIView animateWithDuration:0.2 animations:^{
                    CGAffineTransform transform1 = CGAffineTransformMakeTranslation(0,0);
                    self.imgView.transform = CGAffineTransformScale(transform1, 1, 1);
                }];
                [self alphaAction:1];
            }else{
                [self hideAction];
            }
        }
            break;
        default:
            break;
    }
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    if (gestureRecognizer == self.panGesture) {
        //记录刚接触时的坐标
        _firstTouchPoint = [touch locationInView:self.window];
    }
    return YES;
}

-(BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    //判断是否左右滑动，滑动区间设置为+-10
    CGPoint touchPoint = [gestureRecognizer locationInView:self.window];
    CGFloat dirTop = _firstTouchPoint.y - touchPoint.y;
    if (dirTop > -10) { //&& dirTop < 10
        return NO;
    }
    //判断是否左右滑动
    CGFloat dirLift = _firstTouchPoint.x - touchPoint.x;
    if (dirLift > -10 && dirLift < 10 && self.imgView.frame.size.height > [UIScreen mainScreen].bounds.size.height) {
        return NO;
    }
    
    return YES;
}


#pragma mark - public
+(CGRect)destFrameWithImage:(UIImage *)image{
    //1.保证宽度占满屏幕
    //2.修改高度,如果高度大于屏幕高度，修改宽度
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    if(fabs(image.size.height)<1e-6){
        return CGRectZero;
    }
    CGFloat imgRate = image.size.width / image.size.height;
    if (fabs(imgRate)<1e-6) {
        return CGRectZero;
    }
    CGFloat imgWidth = screenWidth;
    CGFloat imgHeight = imgWidth / imgRate;
    if (imgHeight > screenHeight) {
        imgHeight = screenHeight;
        imgWidth = imgHeight * imgRate;
    }
    
    CGFloat x = (screenWidth - imgWidth) / 2;
    CGFloat y = (screenHeight - imgHeight) / 2;
    
    return CGRectMake(x, y, imgWidth, imgHeight);
}

#pragma mark - custom func
-(void)hideAction{
    if ([self.delegate respondsToSelector:@selector(imgScannerCell:dismissWithImg:windowFrame:)]) {
        UIImage *image = self.imgView.image;
        CGRect frame = [self.imgView convertRect:self.imgView.bounds toView:self.window];
        [self.delegate imgScannerCell:self dismissWithImg:image windowFrame:frame];
    }
}

-(void)alphaAction:(CGFloat)alpha{
    if ([self.delegate respondsToSelector:@selector(imgScannerCell:alphaChangedWithRate:)]) {
        [self.delegate imgScannerCell:self alphaChangedWithRate:alpha];
    }
}


@end
