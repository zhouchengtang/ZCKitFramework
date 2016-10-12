//
//  ZCImageView.h
//  ZCKit
//
//  Created by zhoucheng on 16/4/21.
//  Copyright © 2016年 t_zc. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol IZCImageView <NSObject>

@property(nonatomic,assign,getter = isLoaded) BOOL loaded;
@property(nonatomic,retain) NSString * defaultSrc;
@property(nonatomic,retain) NSString * src;
@property(nonatomic,assign,getter = isLoading) BOOL loading;
@property(nonatomic,retain) NSString * reuseFileURI;
@property(nonatomic,assign,getter = isLocalAsyncLoad) BOOL localAsyncLoad;

-(void) setImage:(UIImage *) image;

-(void) setImage:(UIImage *) image isLocal:(BOOL) isLocal;

-(void) setDefaultImage:(UIImage *) image;

@end

@interface ZCImageView : UIImageView<IZCImageView>

@property(nonatomic,retain) UIImage * defaultImage;
@property(nonatomic,assign,getter = isFitWidth) BOOL fitWidth;
@property(nonatomic,assign,getter = isFitHeight) BOOL fitHeight;
@property(nonatomic,assign) CGFloat maxWidth;
@property(nonatomic,assign) CGFloat maxHeight;
@property(nonatomic,assign) CGFloat cornerRadius;
@property(nonatomic)CGFloat borderWidth;
@property(nonatomic, strong)NSString *borderColor;

@end
