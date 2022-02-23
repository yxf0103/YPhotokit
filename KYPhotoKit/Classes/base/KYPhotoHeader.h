//
//  KYPhotoHeader.h
//  Pods
//
//  Created by yxf on 2020/8/11.
//

#ifndef KYPhotoHeader_h
#define KYPhotoHeader_h

#ifdef DEBUG
#define KYLog(...)  NSLog(__VA_ARGS__)
#else
#define KYLog(...)
#endif

#define KYColorRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

//坐标
#define KYSCREENBOUNS  [UIScreen mainScreen].bounds
#define KYSCREENWIDTH  [UIScreen mainScreen].bounds.size.width
#define KYSCREENHEIGHT  [UIScreen mainScreen].bounds.size.height
#define KYSCREENSCALE  [UIScreen mainScreen].scale

#define KYISNORNALSCREEN  (KYSCREENHEIGHT < 800)
#define KYSAFEBOTTOM  (KYISNORNALSCREEN ? 0 : 34)
#define KYTOPBARHEIGTH [[UIApplication sharedApplication] statusBarFrame].size.height
#define KYNAVIHEIGHT  (44 + KYTOPBARHEIGTH)
#define KYTABBARHEIGHT  (KYISNORNALSCREEN ? 49 : (49 + KYSAFEBOTTOM))

#define KYHORIZONFIT(x) ((x) * KYSCREENWIDTH / 375.0)
#define KYVERTICALFIT(y) ((y) * KYSCREENHEIGHT / 667.0)


#endif /* KYPhotoHeader_h */
