//
//  ZCKit.h
//  ZCKit
//
//  Created by zhoucheng on 2016/10/10.
//  Copyright © 2016年 zhoucheng. All rights reserved.
//

#import <UIKit/UIKit.h>

//! Project version number for ZCKit.
FOUNDATION_EXPORT double ZCKitVersionNumber;

//! Project version string for ZCKit.
FOUNDATION_EXPORT const unsigned char ZCKitVersionString[];

// In this header, you should import all the public headers of your framework using statements like #import <ZCKit/PublicHeader.h>

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#pragma mark - Foundation Category
//NSArray
#import <ZCKit/NSArray+ZCUtilities.h>
#import <ZCKit/NSArray+ZCSaceAccess.h>
//NSDate
#import <ZCKit/NSDate+ZCUtilities.h>
#import <ZCKit/NSDate+ZCExtension.h>
#import <ZCKit/NSDate+ZCFormatter.h>
//NSData
#import <ZCKit/NSData+ZCMD5.h>
#import <ZCKit/NSData+ZCBase64.h>
#import <ZCkit/NSData+ZCEncrypt.h>
#import <ZCKit/NSData+ZCGzip.h>
#import <ZCKit/NSData+ZCAPNSToken.h>
//NSDictionary
#import <ZCKit/NSDictionary+ZCUtilities.h>
#import <ZCKit/NSDictionary+ZCSafeAccess.h>
#import <ZCKit/NSDictionary+ZCMerge.h>
#import <ZCKit/NSDictionary+ZCURL.h>
//NSFileManager
#import <ZCKit/NSFileManager+ZCPaths.h>
//NSIndexPath
#import <ZCKit/NSIndexPath+ZCOffset.h>
//NSNotificationCenter
#import <ZCKit/NSNotificationCenter+ZCMainThread.h>
//NSObject
#import <ZCKit/NSObject+ZCValue.h>
#import <ZCKit/NSObject+ZCKVOBlocks.h>
#import <ZCKit/NSObject+ZCAddProperty.h>
#import <ZCKit/NSObject+ZCAppInfo.h>
#import <ZCKit/NSObject+ZCEasyCopy.h>
#import <ZCKit/NSObject+ZCReflection.h>
#import <ZCKit/NSObject+ZCAssociatedObject.h>
#import <ZCKit/NSObject+ZCGCD.h>
//NSString
#import <ZCKit/NSString+ZCUtilities.h>
#import <ZCKit/NSString+ZCPinyin.h>
#import <ZCKit/NSString+ZCSize.h>
#import <ZCKit/NSString+ZCUrlEncode.h>
#import <ZCKit/NSString+ZCEncrypt.h>
#import <ZCKit/NSString+ZCBase64.h>
#import <ZCKit/NSString+ZCContains.h>
#import <ZCKit/NSString+ZCRegexCategory.h>
//NSTimer
#import <ZCKit/NSTimer+ZCBlocks.h>
#import <ZCKit/NSTimer+ZCAddition.h>
//NSURL
#import <ZCKit/NSURL+ZCQueryDictionary.h>
#import <ZCKit/NSURL+ZCParam.h>
//NSURLRequest
#import <ZCKit/NSURLRequest+ZCParamsFromDictionary.h>
#import <ZCKit/NSMutableURLRequest+ZCUpload.h>

#pragma mark - UIKit Category
//UIApplication
#import <ZCKit/UIApplication+ZCApplicationSize.h>
#import <ZCKit/UIApplication+ZCNetworkActivityIndicator.h>
#import <ZCKit/UIApplication+ZCKeyboardFrame.h>
//UIColor
#import <ZCKit/UIColor+ZCUtilities.h>
#import <ZCKit/UIColor+ZCWeb.h>
#import <ZCKit/UIColor+ZCHEX.h>
#import <ZCKit/UIColor+ZCRandom.h>
#import <ZCKit/UIColor+ZCGradient.h>
//UIView
#import <ZCKit/UIView+ZCUtilities.h>
#import <ZCKit/UIView+ZCSearch.h>
//UIAlertView
#import <ZCKit/UIAlertView+ZCBlock.h>
//UINavigationItem
#import <ZCKit/UINavigationItem+ZCLock.h>
#import <ZCKit/UINavigationItem+ZCLoading.h>
//UIButton
#import <ZCKit/UIButton+ZCBackgroundColor.h>
#import <ZCKit/UIButton+ZCSubmitting.h>
#import <ZCKit/UIButton+ZCBlock.h>
//UIControl
#import <ZCKit/UIControl+ZCBlock.h>
#import <ZCKit/UIControl+ZCActionBlocks.h>
//UIDevice
#import <ZCKit/UIDevice+ZCHardware.h>
//UIImage
#import <ZCKit/UIImage+ZCFileName.h>
#import <ZCKit/UIImage+ZCAnimatedGIF.h>
#import <ZCKit/UIImage+ZCColor.h>
#import <ZCKit/UIImage+ZCMerge.h>
#import <ZCKit/UIImage+ZCOrientation.h>
#import <ZCKit/UIImage+ZCCapture.h>
#import <ZCKit/UIImage+ZCBlur.h>
//UIImageView
#import <ZCKit/UIImageView+ZCAddition.h>
//UILabel
#import <ZCKit/UILabel+ZCAutoSize.h>
//UINavigationBar
#import <ZCKit/UINavigationBar+ZCCustomHeight.h>
//UINavigationController
#import <ZCKit/UINavigationController+ZCStackManager.h>
//UIBarButtonItem
#import <ZCKit/UIBarButtonItem+ZCAction.h>
//UIResponder
#import <ZCKit/UIResponder+FirstResponder.h>
//UIScreen
#import <ZCKit/UIScreen+ZCFrame.h>
//UIScrollView
#import <ZCKit/UIScrollView+ZCAddition.h>
#import <ZCKit/UIScrollView+ZCPages.h>
//UISearchBar
#import <ZCKit/UISearchBar+ZCBlocks.h>
//UITableViewCell
#import <ZCKit/UITableViewCell+ZCNIB.h>
//UITextField
#import <ZCKit/UITextField+ZCShake.h>
#import <ZCKit/UITextField+ZCBlocks.h>
//UITextView
#import <ZCKit/UITextView+ZCPlaceHolder.h>
//UIViewController
#import <ZCKit/UIViewController+ZCVisible.h>
#import <ZCKit/UIViewController+ZCStoreKit.h>
#import <ZCKit/UIViewController+ZCBackButtonItemTitle.h>
#import <ZCKit/UIViewController+ZCSystemBackButtonHandler.h>
//UIWebView
#import <ZCKit/UIWebView+ZCStyle.h>
#import <ZCKit/UIWebView+ZCJS.h>
//UIWindow
#import <ZCKit/UIWindow+ZCHierarchy.h>
//UIFont
#import <ZCKit/UIFont+ZCUtilities.h>


#pragma mark - fileDataCache
//fileDataCache
#import <ZCKit/ZCFileDataCache.h>
#import <ZCKit/ZCSQDataCache.h>

#pragma mark - GeneralView
//GeneralView
#import <ZCKit/ZCAlertView.h>
#import <ZCKit/ZCTableView.h>
#import <ZCKit/ZCMenuView.h>
#import <ZCKit/ZCTableViewCell.h>
#import <ZCKit/ZCSelectDatePickerView.h>
#import <ZCKit/ZCSelectPickerView.h>
#import <ZCKit/ZCDragLoadingView.h>
#import <ZCKit/ZCImageView.h>
#import <ZCKit/ZCCycleScrollView.h>
#import <ZCKit/ZCButton.h>
#import <ZCKit/ZCNoMessageView.h>
#import <ZCKit/ZCTextView.h>
#import <ZCKit/ZCBarButtonItem.h>
#import <ZCKit/ZCTextField.h>

#pragma mark - model
//model
#import <ZCKit/ZCBaseModel.h>

#pragma mark - Controller
//Controller
#import <ZCKit/ZCDataController.h>
#import <ZCKit/ZCNavigationController.h>
#import <ZCKit/ZCTableDataController.h>
#import <ZCKit/ZCViewController.h>
#import <ZCKit/ZCRefreshTableDataController.h>

//#pragma mark DataOutlet
#import <ZCKit/UIView+ZCDataOutlet.h>
#import <ZCKit/UIControl+ZCDataOutlet.h>
//#import <ZCKit/ZCDataOutlet.h>
//#import <ZCKit/ZCDataOutletContainer.h>

#import <ZCKit/ZCTableSource.h>

#pragma mark - ZCCommonUtilities
#import <ZCKit/ZCLoadImageHelper.h>
#import <ZCKit/ZCURLCacheObject.h>
#import <ZCKit/ZCURLDataSource.h>
#import <ZCKit/ZCBaseRequest.h>
#import <ZCKit/ZCBaseResponse.h>
#import <ZCKit/ZCNetworkMethod.h>

#pragma mark - SDWebImage
#import <ZCKit/MKAnnotationView+ZCSD_WebCache.h>
#import <ZCKit/NSData+ZCSD_ImageContentType.h>
#import <ZCKit/NSImage+ZCSD_WebCache.h>
#import <ZCKit/UIButton+ZCSD_WebCache.h>
#import <ZCKit/UIImage+ZCSD_GIF.h>
#import <ZCKit/UIImage+ZCSD_MultiFormat.h>
#import <ZCKit/UIImage+ZCSD_WebP.h>
#import <ZCKit/UIImageView+ZCSD_HighlightedWebCache.h>
#import <ZCKit/UIImageView+ZCSD_WebCache.h>
#import <ZCKit/UIView+ZCSD_WebCache.h>
#import <ZCKit/UIView+ZCSD_WebCacheOperation.h>
#import <ZCKit/ZC_FLAnimatedImageView+WebCache.h>

#import <ZCKit/ZC_SDImageCache.h>
#import <ZCKit/ZC_SDImageCacheConfig.h>
#import <ZCKit/ZC_SDWebImageCompat.h>
#import <ZCKit/ZC_SDWebImageDecoder.h>
#import <ZCKit/ZC_SDWebImageDownloader.h>
#import <ZCKit/ZC_SDWebImageDownloaderOperation.h>
#import <ZCKit/ZC_SDWebImageManager.h>
#import <ZCKit/ZC_SDWebImageOperation.h>
#import <ZCKit/ZC_SDWebImagePrefetcher.h>

#pragma mark - AFNetworking
#import <ZCKit/ZC_AFNetworking.h>

#pragma mark - FLAnimatedImageView
#import <ZCKit/ZC_FLAnimatedImageView.h>
#import <ZCKit/ZC_FLAnimatedImage.h>

#import <ZCKit/ZCPContext.h>
#import <ZCKit/ZCRegisterObject.h>
//protocol
#import <ZCKit/IZCAction.h>
#import <ZCKit/IZCContext.h>
#import <ZCKit/IZCServiceContext.h>
#import <ZCKit/IZCAuthContext.h>
#import <ZCKit/IZCTask.h>
#import <ZCKit/IZCServiceContainer.h>
#import <ZCKit/IZCService.h>
#import <ZCKit/IZCUIViewController.h>
#import <ZCKit/IZCRegisterObject.h>



