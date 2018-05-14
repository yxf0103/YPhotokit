//
//  KYHud.m
//  KYPhotoKit
//
//  Created by yxf on 2018/5/8.
//

#import "KYHud.h"

#define KYHubCircleAnimation        @"KYHubCircleAnimation"
#define KYHubIndicatorAnimation     @"KYHubIndicatorAnimation"

@interface KYHud (){
    CAReplicatorLayer *_replicatotLayer;
}

@end

@implementation KYHud

-(instancetype)init{
    return [self initWithFrame:CGRectZero style:KYHudCircle backgroundColor:[UIColor grayColor] loadingColor:[UIColor whiteColor] cornerRadius:5];
}

-(instancetype)initWithFrame:(CGRect)frame{
    return [self initWithFrame:frame
                         style:KYHudCircle
               backgroundColor:[UIColor grayColor]
                  loadingColor:[UIColor whiteColor]
                  cornerRadius:5];
}

-(instancetype)initWithFrame:(CGRect)frame style:(KYHudStyle)style backgroundColor:(UIColor *)bgColor loadingColor:(UIColor *)loadingColor cornerRadius:(CGFloat)radius{
    if (self = [super initWithFrame:frame]) {
        _style = style;
        _bgColor = bgColor;
        _loadingColor = loadingColor;
        _radius = radius;
        [self setupUI];
    }
    return self;
}

#pragma mark - getter
-(KYHudStyle)style{
    if (_style < 0 || _style > 1) {
        return KYHudCircle;
    }
    return _style;
}

-(UIColor *)bgColor{
    if (!_bgColor) {
        _bgColor = [UIColor grayColor];
    }
    return _bgColor;
}

-(UIColor *)loadingColor{
    if (!_loadingColor) {
        _loadingColor = [UIColor whiteColor];
    }
    return _loadingColor;
}

-(CGFloat)radius{
    if (_radius <= 0) {
        _radius = 5;
    }
    return _radius;
}

#pragma mark - ui
-(void)setupUI{
    if (self.style == KYHudCircle) {
        [self addCircleLayer];
        return;
    }
    
    if (self.style == KYHudIndicator) {
        [self addIndicatorLayer];
        return;
    }
}

-(void)addCircleLayer{
    CGFloat width = CGRectGetWidth(self.frame);
    CGFloat height = CGRectGetHeight(self.frame);
    
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(width / 2.0, height / 2.0)
                                                        radius:width / 2.0
                                                    startAngle:0
                                                      endAngle:2 *M_PI
                                                     clockwise:YES];
    //背景管道
    CAShapeLayer *bottomLayer = [CAShapeLayer layer];
    bottomLayer.path = path.CGPath;
    bottomLayer.fillColor = [UIColor clearColor].CGColor;
    bottomLayer.strokeColor = [UIColor lightGrayColor].CGColor;
    bottomLayer.lineWidth = 3;
    bottomLayer.strokeStart = 0;
    bottomLayer.strokeEnd = 1.0;
    [self.layer addSublayer:bottomLayer];
    
    //前景管道
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.path = path.CGPath;
    shapeLayer.fillColor = [UIColor clearColor].CGColor;
    shapeLayer.strokeColor = self.tintColor.CGColor;
    shapeLayer.lineWidth = 3;
    shapeLayer.strokeStart = 0;
    shapeLayer.strokeEnd = 0.33;
    [self.layer addSublayer:shapeLayer];
}

-(void)addIndicatorLayer{
    CGRect frame = self.frame;
    CAReplicatorLayer * replicatorLayer = [CAReplicatorLayer new];
    replicatorLayer.bounds = CGRectMake(0, 0, frame.size.width, frame.size.height);
    replicatorLayer.position = CGPointMake(frame.size.width/2, frame.size.height/2);
    [self.layer addSublayer:replicatorLayer];
    CALayer * circle = [CALayer new];
    circle.bounds = CGRectMake(0, 0, 15, 15);
    circle.position = CGPointMake(frame.size.width/2, frame.size.height/2 - 55);
    circle.cornerRadius = 7.5;
    circle.backgroundColor = self.loadingColor.CGColor;
    [replicatorLayer addSublayer:circle];
    
    //复制15个同样的layer
    replicatorLayer.instanceCount = 15;
    CGFloat angle = 2 * M_PI/ 15.;
    replicatorLayer.instanceTransform = CATransform3DMakeRotation(angle, 0, 0, 1);
    replicatorLayer.instanceDelay = 1./15.;//延迟动画开始时间 以造成旋转的效果
    
    _replicatotLayer = replicatorLayer;
}

#pragma mark - action
-(void)startAnimation{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.hidden = NO;
        [self.layer removeAllAnimations];
        if (self.style == KYHudCircle) {
            [self animationWithCircle];
        }else if (self.style == KYHudIndicator){
            [self animationWithIndicator];
        }
    });
}

-(void)stopAnimation{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.hidden = YES;
        [self.layer removeAllAnimations];
        [self->_replicatotLayer removeAllAnimations];
    });
}

#pragma mark - custom func
-(void)animationWithCircle{
    //自旋动画
    CABasicAnimation *viewAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    viewAnimation.toValue = @(-M_PI * 2);
    viewAnimation.duration = 0.8;
    viewAnimation.repeatCount = MAXFLOAT;
    viewAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [self.layer addAnimation:viewAnimation forKey:KYHubCircleAnimation];
}

-(void)animationWithIndicator{
    //分身术
    CABasicAnimation *scale = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scale.fromValue = @1;
    scale.toValue = @0.1;
    scale.duration = 1;
    scale.repeatCount = HUGE;
    _replicatotLayer.transform = CATransform3DMakeScale(0.01, 0.01, 0.01);
    [_replicatotLayer addAnimation:scale forKey:KYHubIndicatorAnimation];
}

@end
