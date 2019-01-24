//
//  EPFloatedWindow.h
//  Epweike_Witkey
//
//  Created by Mac on 16/2/17.
//  Copyright © 2016年 zengxusheng. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,EPFloatedWindowLocationType){
    EPFloatedWindowLocationType_LeftTop,//左上
    EPFloatedWindowLocationType_Left,//左边
    EPFloatedWindowLocationType_LeftBottom,//左下
    EPFloatedWindowLocationType_Center,//中间
    EPFloatedWindowLocationType_Right,//右边
    EPFloatedWindowLocationType_RightTop,//右上
    EPFloatedWindowLocationType_RightBottom,//右上
};//悬浮窗口位置

@class EPFloatedWindow;
@protocol EPFloatedWindowDelegate <NSObject>

- (void)epFloatedWindowDidTap:(EPFloatedWindow *)view;

@end

@interface EPFloatedWindow : UIImageView<UIGestureRecognizerDelegate>

@property (nonatomic,copy)NSString *urlString;
@property (nonatomic,retain)UIImage *defaultImage;//默认状态图片
@property (nonatomic,assign)EPFloatedWindowLocationType locationType;
@property (nonatomic,copy)void (^epFloatedWindowBlock)(NSString *url);
@property (nonatomic,weak)id <EPFloatedWindowDelegate>delegate;
/**
 *  初始化-1
 *
 *  @param frame
 *
 *  @return
 */
- (instancetype)initWithFrame:(CGRect)frame;
/**
 *  初始化-2
 *
 *  @param frame
 *  @param urlStr url链接
 *  @param defaultImg 默认图片
 *
 *  @return
 */
- (instancetype)initWithFrame:(CGRect)frame
                    urlString:(NSString *)urlStr
                   defaultImg:(UIImage *)defaultImg;

/**
 *  显示
 *
 *  @param superView 父视图
 */
- (void)showInView:(UIView *)superView;
@end
