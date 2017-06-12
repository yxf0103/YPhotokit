//
//  YPKAlbumsViewController.m
//  DemoPhotoKit
//
//  Created by yxf on 2017/6/12.
//  Copyright © 2017年 yxf. All rights reserved.
//

#import "YPKAlbumsViewController.h"
#import "YPKAlbumCell.h"
#import "YPKManager.h"
#import "YPKAlbumModel.h"
#import "YPKImagesViewController.h"

@interface YPKAlbumsViewController ()<UITableViewDelegate,UITableViewDataSource>

/** table album*/
@property(nonatomic,weak)UITableView *albumView;

/** albums */
@property(nonatomic,strong)NSMutableArray *albums;

@end

@implementation YPKAlbumsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blueColor];
    
    UITableView *albumTableView = [[UITableView alloc] initWithFrame:self.view.bounds
                                                               style:UITableViewStylePlain];
    [self.view addSubview:albumTableView];
    _albumView = albumTableView;
    albumTableView.delegate = self;
    albumTableView.dataSource = self;
    [albumTableView registerClass:[YPKAlbumCell class] forCellReuseIdentifier:albumCellIdentifier];
    albumTableView.rowHeight = 70;
    [albumTableView setTableFooterView:[[UIView alloc] init]];
    
    [self.view bringSubviewToFront:self.indicatorView];
    
    YPKWeakSelf;
    [YPKManager getAllAlbums:^(NSArray<YPKAlbumModel *> *collections, NSError *error) {
        [weakSelf.indicatorView stopAnimating];
        weakSelf.albums = [NSMutableArray arrayWithArray:collections];
        [weakSelf.albumView reloadData];
    }];
    self.navigationItem.title = @"相册";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDelegate
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YPKAlbumCell *cell = [tableView dequeueReusableCellWithIdentifier:albumCellIdentifier
                                                         forIndexPath:indexPath];
    cell.album = _albums[indexPath.row];
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _albums.count;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    YPKAlbumModel *model = self.albums[indexPath.row];
    YPKImagesViewController *vc = [YPKImagesViewController initWithAlbum:model];
    [self.navigationController pushViewController:vc animated:YES];
}


@end
