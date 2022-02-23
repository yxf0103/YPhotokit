//
//  KYPhotoSourceTool.m
//  KYPhotoKit
//
//  Created by yxf on 2020/8/11.
//

#import "KYPhotoSourceTool.h"

NSBundle *kyBunble(void){
    static dispatch_once_t onceToken;
    static NSBundle *bundle = nil;
    dispatch_once(&onceToken, ^{
        NSBundle *frameworkBundle = [NSBundle bundleForClass:[KYPhotoSourceTool class]];
        NSString *path = [frameworkBundle pathForResource:@"KYPhotoKit" ofType:@"bundle"];
        bundle = [NSBundle bundleWithPath:path];
    });
    return bundle;
}

NSBundle *KYPhotoLocalizationBundle(void) {
    static NSBundle *_localizationBundle = nil;
    if (!_localizationBundle) {
        // 检查本机语言
        NSString *localIdentifier = [NSLocale preferredLanguages].firstObject;
        // 支持的国际化语言
        NSArray<NSString *> *localizations = [[NSBundle mainBundle] localizations];
        // 默认语言
        __block NSString *localization = @"en";
        [localizations enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSString *languageCode = [[NSLocale componentsFromLocaleIdentifier:obj] objectForKey:NSLocaleLanguageCode] ;
            if ([localIdentifier hasPrefix:languageCode]) {  // 匹配语言编码
                localization = obj;
                *stop = YES;
            }
        }];
        NSString *bundlePath = [[NSBundle mainBundle] pathForResource:localization ofType:@"lproj"];
        _localizationBundle = [NSBundle bundleWithPath:bundlePath];
    }
    return _localizationBundle;
}

NSString *TALocalizationStringWithKey(NSString *key,NSString *_Nullable defaultValue){
    NSBundle *bundle = KYPhotoLocalizationBundle();
    return [bundle localizedStringForKey:(key) value:@"" table: nil];
}


@implementation KYPhotoSourceTool

+(UIImage *)imageWithName:(NSString *_Nullable)name type:(NSString *_Nullable)type{
    NSString *path = [self filepathWithName:name type:type];
    return [[UIImage alloc] initWithContentsOfFile:path];
}

+(NSString *)filepathWithName:(NSString *_Nullable)name type:(NSString *_Nullable)type{
    return [kyBunble() pathForResource:name ofType:type];
}


@end
