//
//  CategoryUtil.h
//  CategoryUtil
//
//  Created by Mac on 15/7/29.
//  Copyright (c) 2015年 zengxusheng. All rights reserved.
//

#ifndef CategoryUtil_CategoryUtil_h
#define CategoryUtil_CategoryUtil_h

#import <Foundation/Foundation.h>
#import "UIImage+Addition.h"
#import "UIImageView+Addition.h"
#import "UIColor+Addition.h"
#import "NSDate+Helper.h"
#import "NSString+Addition.h"
#import "UILabel+Addition.h"


//判断是否是iPhone X
#define iPhone4 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)
#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)
#define iPhone6 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) : NO)
#define iPhone6plus ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? (CGSizeEqualToSize(CGSizeMake(1125, 2001), [[UIScreen mainScreen] currentMode].size) || CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size)) : NO)

//设备屏幕大小
#define DeviceBoundsSize    [[UIScreen mainScreen] bounds].size                         // 包含状态栏
#define DeviceSize          [[UIScreen mainScreen] applicationFrame].size               // 不包含状态栏
#define StatusBarSize       [[UIApplication sharedApplication] statusBarFrame].size     // 状态栏
#define SelfNavSize         (CGSize){DeviceBoundsSize.width,44}                         // 当前导航栏
#define SelfToolBarSize     (CGSize){DeviceBoundsSize.width,49}                         // 当前工具栏
#define VisibleScreenFrame  (CGRect){0,0,DeviceBoundsSize.width,DeviceBoundsSize.height - SelfNavSize.height - StatusBarSize.height}    //不包含状态栏和导航栏

#define ScreenWith DeviceBoundsSize.width  //屏幕宽度
#define ScreenHeight DeviceBoundsSize.height  //屏幕高度
#define ScreenWithRatio DeviceBoundsSize.width/320  //屏幕宽度比例

// 自定义弹窗的宽度
#define AlertViewWidth VisibleScreenFrame.size.width - 44



//字体
#define systemFont(size)    [UIFont systemFontOfSize:size]
#define boldSystemFont(size) [UIFont boldSystemFontOfSize:size]

//5和6图片转换比例
#define IMAGECONVERTRATIO   640.00/750.00

// 普通按钮高度
#define kDefaultButtonsHeight   42.0

// 普通输入框高度
#define kTextFiledHight 42.0

//个人中心头像CELL
#define kHeadCellHeight 162

// 服务  收藏 参与的任务 高度
#define kThreeItemCellHeight 55

// 普通CELL高度
#define kCustomCellHeight   42.0

//CELL正标题字体大小
#define kTextFont systemFont(14)

//CELL副标题字体大小
#define kDetailTextFont systemFont(11)

//加载更多最大数
#define kMaxLoadMore    10

// 透明
#define CLEARCOLOR  [UIColor clearColor]



// RGBA获取颜色
#define COLOR(R,G,B,A)  [UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:A]
#define colorWithRGB(r, g, b) ([UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0])

// 根据时间格式和时间返回字符串
#define TIMESTR(format) [format stringFromDate:[NSDate date]]
// 连接字符串
#define APPENDSTR(a,b)  [a stringByAppendingString:b]

// NSIndexPath
#define IndexPath(row,section) [NSIndexPath indexPathForRow:row inSection:section]

#define IS_IOS6    [[UIDevice currentDevice].systemVersion floatValue] >= 6.0

#define IS_IOS7    [[UIDevice currentDevice].systemVersion floatValue] >= 7.0

#define IS_IOS8    [[UIDevice currentDevice].systemVersion floatValue] >= 8.0

#define IS_IOS9    [[UIDevice currentDevice].systemVersion floatValue] >= 9.0

#define IS_IOS10    [[UIDevice currentDevice].systemVersion floatValue] >= 10.0

#endif
