//
//  UIScrollView+EmptyState.h
//  RenRenProject
//
//  Created by BY on 2018/7/11.
//  Copyright © 2018年 epwk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <objc/runtime.h>
#import "UIScrollView+EmptyDataSet.h"

typedef void(^TapBlock)(void);

typedef NS_ENUM(NSInteger, EPEmptyDataType) {
    
    EPEmptyDataTypeDismiss = -1,      //消失
    EPEmptyDataTypeLoading = 0,       //加载中
    EPEmptyDataTypeNoData,            //无数据
    EPEmptyDataTypeError,             //加载错误
    EPEmptyDataTypeNoNetwork,         //无网络
    EPEmptyDataTypeBtn,               //有按钮
    EPEmptyDataTypeNoLogin,           /// 未登录
    
//    //自定义模块
//    EPEmptyDataTypeAuthSuccess,          //入驻认证 成功
//    EPEmptyDataTypeAuthError,            //入驻 认证失败
//    EPEmptyDataTypeAuthInProcessing,     //入驻认证 处理中
    
};


@interface UIScrollView (EmptyState)<DZNEmptyDataSetDelegate, DZNEmptyDataSetSource>

/// 加载的空白模板类型
@property (nonatomic, assign) EPEmptyDataType emptyDataType;
/// 描述
@property (nonatomic,copy) NSString *emptyDescription;
/// 详细描述
@property (nonatomic,copy) NSString *emptySubDescription;
/// 内容垂直挪动距离 不可为0；否则默认-30
@property (nonatomic, assign) CGFloat emptyVerticalOffset;


/**
 添加空白模板

 @param tapBlock 点击回调
 */
- (void)addEmptyPageWithBlock:(TapBlock)tapBlock;

/**
 添加空白模板
 
 @param title    空白页展示标题
 @param tapBlock 点击回调
 */
- (void)addEmptyPageWithTitle:(NSString *)title
                        block:(TapBlock)tapBlock;

/**
 添加空白模板
 
 @param title    空白页标题
 @param subTitle 空白页副标题
 @param tapBlock 点击回调
 */
- (void)addEmptyPageWithTitle:(NSString *)title
                     subTitle:(NSString *)subTitle
                        block:(TapBlock)tapBlock;

@end
