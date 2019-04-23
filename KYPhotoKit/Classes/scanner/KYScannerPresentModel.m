//
//  KYScannerPresentModel.m
//  KYPhotoKit
//
//  Created by yxf on 2018/5/11.
//

#import "KYScannerPresentModel.h"

@interface KYScannerPresentModel ()

/*fake view*/
@property (nonatomic,strong)UIImageView *fakeView;

@end

@implementation KYScannerPresentModel

#pragma mark - UIViewControllerAnimatedTransitioning
- (NSTimeInterval)transitionDuration:(nullable id <UIViewControllerContextTransitioning>)transitionContext{
    return 0.25;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext{
    switch (self.modalType) {
        case KYScannerPresentPop:
            [self pop_animateTransition:transitionContext];
            break;
        case KYScannerPresentPush:
            [self push_animateTransition:transitionContext];
            break;
        default:
            break;
    }
}

#pragma makr - getter
-(UIImageView *)fakeView{
    if (!_fakeView)
    {
        _fakeView = [[UIImageView alloc] initWithFrame:_touchFrame];
        _fakeView.contentMode = UIViewContentModeScaleAspectFill;
        _fakeView.clipsToBounds = YES;
        _fakeView.image = _touchImage;
    }
    return _fakeView;
}

#pragma mark - animation
-(void)pop_animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext{
    UIView *containerView = [transitionContext containerView];
    containerView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.1];
    [containerView addSubview:self.fakeView];
    
    UIViewController *fromVc = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVc = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    CGFloat animationTime = [self transitionDuration:transitionContext];
    __weak typeof(self) weakSelf = self;
    if (toVc.isBeingPresented)
    {//present
        //⚠️这里不能把fromVc.view添加到containerView上，不然containerView消失的时候fromVc.view也会跟着消失
        [UIView animateWithDuration:animationTime
                         animations:^{
                             weakSelf.fakeView.frame = weakSelf.destFrame;
                             containerView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:1];
                         } completion:^(BOOL finished) {
                             weakSelf.fakeView.hidden = YES;
                             [containerView addSubview:toVc.view];
                             [transitionContext completeTransition:YES];
                         }];
        return;
    }
    //dismiss
    [self scaleToDismiss:transitionContext containerView:containerView fromVc:fromVc time:animationTime];
}

-(void)push_animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext{
    UIView *containerView = [transitionContext containerView];
    containerView.backgroundColor = [UIColor blackColor];
    UIViewController *toVc = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIViewController *fromVc = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    CGFloat animationTime = [self transitionDuration:transitionContext];
    CGFloat screenW = [UIScreen mainScreen].bounds.size.width;
    CGFloat screenH = [UIScreen mainScreen].bounds.size.height;
    if(toVc.isBeingPresented){//present
        containerView.frame = CGRectMake(screenW, 0, screenW, screenH);
        [containerView addSubview:toVc.view];
        [UIView animateWithDuration:animationTime animations:^{
            containerView.frame = CGRectMake(0, 0, screenW, screenH);
        } completion:^(BOOL finished) {
            [transitionContext completeTransition:YES];
        }];
        return;
    }
    //dismiss
    if (_popBack) {
        [UIView animateWithDuration:animationTime animations:^{
            containerView.frame = CGRectMake(screenW, 0, screenW, screenH);
        } completion:^(BOOL finished) {
            [transitionContext completeTransition:YES];
        }];
        return;
    }
    [self scaleToDismiss:transitionContext containerView:containerView fromVc:fromVc time:animationTime];
    
}

-(void)scaleToDismiss:(id <UIViewControllerContextTransitioning>)transitionContext
        containerView:(UIView *)containerView
               fromVc:(UIViewController *)fromVc
                 time:(NSTimeInterval)animationTime{
    self.fakeView.image = _touchImage;
    self.fakeView.frame = _touchFrame;
    self.fakeView.hidden = NO;
    fromVc.view.hidden = YES;
    if (![containerView.subviews containsObject:self.fakeView]) {
        [containerView addSubview:self.fakeView];
    }
    [containerView bringSubviewToFront:_fakeView];
    
    BOOL fakeHide = CGRectGetMinY(self.destFrame) >= CGRectGetMaxY([UIScreen mainScreen].bounds) || CGRectGetMaxY(self.destFrame) <= 0;
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:animationTime
                     animations:^{
                         if (fakeHide) {
                             weakSelf.fakeView.hidden = YES;
                         }else{
                             weakSelf.fakeView.frame = self.destFrame;
                         }
                         containerView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.1];
                     } completion:^(BOOL finished) {
                         [transitionContext completeTransition:YES];
                     }];
}

@end
