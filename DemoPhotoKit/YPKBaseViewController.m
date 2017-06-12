//
//  YPKBaseViewController.m
//  DemoPhotoKit
//
//  Created by yxf on 2017/6/12.
//  Copyright © 2017年 yxf. All rights reserved.
//

#import "YPKBaseViewController.h"

@interface YPKBaseViewController ()

/** indicator*/
@property(nonatomic,weak)UIActivityIndicatorView *indicatorView;

@end

@implementation YPKBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIActivityIndicatorView *indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    indicatorView.color = [UIColor redColor];
    indicatorView.center = CGPointMake(SCREENWIDTH / 2.0 , SCREENHEIGHT / 2.0);
    [self.view addSubview:indicatorView];
    self.indicatorView = indicatorView;
    indicatorView.hidesWhenStopped = YES;
    [indicatorView startAnimating];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
