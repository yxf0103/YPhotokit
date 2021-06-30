//
//  KYAlbumsViewController.m
//  KYPhotoKit
//
//  Created by yxf on 2018/5/3.
//

#import "KYAlbumsViewController.h"
#import "KYAlbumCell.h"
#import "KYPhotoSourceManager.h"
#import "KYAssetsViewController.h"
#import "KYPhotoConfig.h"

@interface KYAlbumsViewController ()<UITableViewDelegate,UITableViewDataSource>

/*相册表*/
@property (nonatomic,weak)UITableView *albumsTableView;

/*albums*/
@property (nonatomic,strong)NSArray *albums;

@end

@implementation KYAlbumsViewController

-(instancetype)init{
    if (self = [super init]) {
        self.navigationItem.title = @"相册";
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
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"关闭" style:UIBarButtonItemStyleDone target:self action:@selector(dismiss)];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, KYNAVIHEIGHT, KYSCREENWIDTH, KYSCREENHEIGHT - KYNAVIHEIGHT) style:UITableViewStylePlain];
    [tableView registerClass:[KYAlbumCell class] forCellReuseIdentifier:KYAlbumCellIdentifier];
    [self.view addSubview:tableView];
    _albumsTableView = tableView;
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.rowHeight = 70;
}

#pragma mark - data
-(void)loadData{
    __weak typeof(self) ws = self;
    [self startLoadingData];
    [KYPhotoSourceManager getAllAlbums:^(NSArray<KYAlbum *> *albums) {
        NSMutableArray *retArr = [NSMutableArray array];
        KYPhotoConfig *config = [KYPhotoConfig shareConfig];
        if (config.showEmptyAlbum) {
            [retArr addObjectsFromArray:albums];
        }else{
            [albums enumerateObjectsUsingBlock:^(KYAlbum * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if (obj.count > 0) {
                    [retArr addObject:obj];
                }
            }];
        }
        __strong typeof(ws) ss = ws;
        [ss loadDataComplete];
        ss.albums = retArr;
        [ss.albumsTableView reloadData];
    }];
}

#pragma mark - action
-(void)dismiss{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - UITableViewDelegate,UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.albums.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    KYAlbumCell *cell = [tableView dequeueReusableCellWithIdentifier:KYAlbumCellIdentifier forIndexPath:indexPath];
    cell.album = _albums[indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    KYAlbum *album = _albums[indexPath.row];
    KYAssetsViewController *assetsVc = [[KYAssetsViewController alloc] initWithAlbum:album];
    [self.navigationController pushViewController:assetsVc animated:YES];
}


#pragma mark - KYPhotoLoadingDataProtocol
-(void)startLoadingData{}
-(void)loadDataComplete{}

@end
