//
//  KYScannerPresentModel.m
//  KYPhotoKit
//
//  Created by yxf on 2018/5/11.
//

#import "KYScannerPresentModel.h"

@interface KYScannerPresentModel ()

/*fake view*/
@property (nonatomic,weak)UIImageView *fakeView;

@end

@implementation KYScannerPresentModel

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

-(void)pop_animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext{
    UIView *containerView = [transitionContext containerView];
    containerView.backgroundColor = [UIColor blackColor];
    
    UIImage *modelImage = _touchImage;
    CGRect modelRect = _touchFrame;
    
    if (!_fakeView)
    {
        UIImageView *fakeImageView = [[UIImageView alloc] initWithFrame:modelRect];
        fakeImageView.contentMode = UIViewContentModeScaleAspectFill;
        fakeImageView.clipsToBounds = YES;
        [containerView addSubview:fakeImageView];
        fakeImageView.image = modelImage;
        _fakeView = fakeImageView;
    }
    UIViewController *fromVc = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVc = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    CGFloat animationTime = [self transitionDuration:transitionContext];
    __weak typeof(self) weakSelf = self;
    if (toVc.isBeingPresented)
    {//present
        //⚠️这里不能把fromVc.view添加到containerView上，不然containerView消失的时候fromVc.view也会跟着消失
        [UIView animateWithDuration:animationTime
                         animations:^{
                             weakSelf.fakeView.frame = toVc.view.frame;
                         } completion:^(BOOL finished) {
                             weakSelf.fakeView.hidden = YES;
                             [containerView addSubview:toVc.view];
                             [transitionContext completeTransition:YES];
                         }];
    }
    else
    {//dismiss
        _fakeView.image = modelImage;
        _fakeView.hidden = NO;
        fromVc.view.hidden = YES;
        [containerView bringSubviewToFront:_fakeView];
        [UIView animateWithDuration:animationTime
                         animations:^{
                             weakSelf.fakeView.frame = modelRect;
                             containerView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];
                         } completion:^(BOOL finished) {
                             [transitionContext completeTransition:YES];
                         }];
    }
}

-(void)push_animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext{
    UIView *containerView = [transitionContext containerView];
    containerView.backgroundColor = [UIColor blackColor];
    UIViewController *toVc = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
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
    }else{//dismiss
        [UIView animateWithDuration:animationTime animations:^{
            containerView.frame = CGRectMake(screenW, 0, screenW, screenH);
        } completion:^(BOOL finished) {
            [transitionContext completeTransition:YES];
        }];
    }
}

@end
