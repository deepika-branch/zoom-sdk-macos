//
//  ZPBundleHelper.h
//  SaasBeePTUIModule
//
//  Created by sanshi on 11-12-8.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "zoom_client_conf.h"

@interface ZPBundleHelper : NSObject


+ (NSBundle *)resBundle;
+ (NSString *)resBundlePath;
+ (NSString *)resBundlePathForResource:(NSString *)resName ofType:(NSString *)typeName;
+ (NSString *)mainResBundlePathForResource:(NSString *)resName ofType:(NSString *)typeName;
+ (NSImage *)resBundleImageForResource:(NSString *)resName ofType:(NSString *)typeName;
+ (NSImage *)getAvatarByPath:(NSString*)inPath;
+ (BOOL)removeAvatarByPath:(NSString*)inPath;//ZOOM-123364

+ (NSImage *)getImageByName:(NSString*)resName;//[Zoom-33534]
+ (NSString *)getImagePathByImage:(NSImage*)inImage; //ZOOM-71195
+ (NSImage *)getDarkImageByName:(NSString *)resName;

+ (NSString *)resolveImagePath:(NSString *)imagePath;
+ (NSString*)localizedString:(NSString *)theKey;
+ (NSString*)localizedString:(NSString *)theKey value:(NSString*)value;
+ (void)cleanUp;
+ (NSString*)localizedEnString:(NSString *)theKey value:(NSString*)value;
+ (BOOL)hasValidZoomCodeSign:(NSString*)path;

//for sdk
+ (void)setCustomBundlePath:(NSString*)bundlePath fileName:(NSString*)fileName;
#ifdef BUILD_FOR_SDK
+ (NSString *)resBundlePathForSDKElectron:(NSString *)originPath;
+ (void)setCustomLocalizationFileName:(NSString*)fileName;
+ (NSString*)getLocalizationFileName;
#endif

+ (BOOL)isRetinaImagesInstalled;
+ (NSString*)getBundlePathForRetinaImages;

+ (NSString *)getBundleVersion:(NSString *)bundlePath;
+ (BOOL)needDownloadWithLatestVersion:(NSString*)inLatestVersion currentVersion:(NSString*)inCurrentVersion;

@end
