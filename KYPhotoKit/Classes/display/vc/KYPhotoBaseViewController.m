//
//  KYPhotoBaseViewController.m
//  KYPhotoKit
//
//  Created by yxf on 2021/5/17.
//

#import "KYPhotoBaseViewController.h"
#import "KYPhotoSourceTool.h"

@interface KYPhotoBaseViewController (){
    UIView *_naviView;
    UILabel *_naviTitleLabel;
}

@end

@implementation KYPhotoBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KYSCREENWIDTH, KYNAVIHEIGHT)];
    [self.view addSubview:view];
    view.backgroundColor = KYColorRGB(0x240F39);
    _naviView = view;
    
    UILabel *titleLabel = [[UILabel alloc] init];
    [view addSubview:titleLabel];
    titleLabel.textColor = KYColorRGB(0xD8D8D8);
    titleLabel.font = [UIFont systemFontOfSize:17];
    titleLabel.frame = CGRectMake((KYSCREENWIDTH - 100) / 2, KYNAVIHEIGHT - 44, 100, 44);
    _naviTitleLabel = titleLabel;
    self.showStatusBar = YES;
    
    if ([self.navigationController.viewControllers indexOfObject:self] > 0) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        UIImage *image = [KYPhotoSourceTool imageWithName:@"navigationbar_icon_back_white" type:@"png"];
        [btn setImage:image forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(leftBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        btn.frame = CGRectMake(10, KYNAVIHEIGHT - 44, 44, 44);
        btn.imageEdgeInsets = UIEdgeInsetsMake(7, 7, 7, 7);
        [view addSubview:btn];
    }
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    _naviTitleLabel.text = self.title;
}


//MARK: setter
-(void)setShowStatusBar:(BOOL)showStatusBar{
    _showStatusBar = showStatusBar;
    [self setNeedsStatusBarAppearanceUpdate];
}

//MARK: getter
-(UIView *)naviView{
    return _naviView;
}

-(BOOL)prefersStatusBarHidden{
    return !_showStatusBar;
}

//MARK: action
-(void)leftBtnClicked:(UIButton *)btn{
    [self.navigationController popViewControllerAnimated:YES];
}



@end
