# KYPhotoKit

an iOS photos libary with system photos.

[![CI Status](https://img.shields.io/travis/massyxf/KYPhotoKit.svg?style=flat)](https://travis-ci.org/massyxf/KYPhotoKit)
[![Version](https://img.shields.io/cocoapods/v/KYPhotoKit.svg?style=flat)](https://cocoapods.org/pods/KYPhotoKit)
[![License](https://img.shields.io/cocoapods/l/KYPhotoKit.svg?style=flat)](https://cocoapods.org/pods/KYPhotoKit)
[![Platform](https://img.shields.io/cocoapods/p/KYPhotoKit.svg?style=flat)](https://cocoapods.org/pods/KYPhotoKit)

## Example
<video id="video" controls="" preload="none">
<source id="mp4" src="https://v.youku.com/v_show/id_XNTE1ODY4MzY2OA==.html" type="video/mp4">
</video>

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

KYPhotoKit is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'KYPhotoKit'
```

## how to use
### 1.资源类: KYPhotoSourceManager
#### 1.1 获取所有相册
```
+(void)getAllAlbums:(KYGetAlbumsBlock _Nullable )complete;
```
#### 1.2 获取某个相册的所有图片
```
+(void)getAssetsFromAlbum:(KYAlbum *)album complete:(KYGetAssetsBlock)complete
```
`可以使用自定义UI来展示这里的图片和相册资源，也可以使用本kit的图片浏览器 `
### 2.展示相册列表和图片列表
```
[KYPhotoSourceManager requestSystemPhotoLibAuth:^(PHAuthorizationStatus statu) {
    dispatch_sync(dispatch_get_main_queue(), ^{
        if (statu == PHAuthorizationStatusAuthorized) {
            KYPhotoNaviViewController *navi = [KYPhotoNaviViewController photoNavicontroller];
            navi.modalPresentationStyle = UIModalPresentationFullScreen;
            navi.photoDelegate = self;
            [self presentViewController:navi animated:YES completion:nil];
        }else{
            NSLog(@"相册未授权");
        }
    });
}];
```

### 3.图片浏览器
```
NSMutableArray<KYScannerImage *> *scannerimgs = [NSMutableArray array];
[assets enumerateObjectsUsingBlock:^(KYAssetviewModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
    KYScannerImage *image = [[KYScannerImage alloc] init];
    image.originImage = obj.asset.thumImage;
    image.originFrame = obj.originFrame;
    image.imgSelected = obj.asset.number > 0;
    image.asset = obj.asset;
    [scannerimgs addObject:image];
}];
KYImageScannerViewController *imgVc = [[KYImageScannerViewController alloc] init];
imgVc.modalPresentationStyle = UIModalPresentationCustom;
imgVc.transitioningDelegate = self;
imgVc.modalPresentationCapturesStatusBarAppearance = YES;
imgVc.scannerDelegate = subVc;
imgVc.images = scannerimgs;
imgVc.index = index;

self.presentModel.touchFrame = scannerimgs[index].originFrame;
self.presentModel.destFrame = scannerimgs[index].destFrame;
self.presentModel.touchImage = scannerimgs[index].originImage;

[photoVc presentViewController:imgVc animated:YES completion:nil];
```

## Author

massyxf, messy007@163.com

## License

KYPhotoKit is available under the MIT license. See the LICENSE file for more info.
