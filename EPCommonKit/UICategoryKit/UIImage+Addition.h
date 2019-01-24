//
//  UIImage+Addition.h
//  Epweike_Witkey
//
//  Created by Mac on 15/7/29.
//  Copyright (c) 2015年 zengxusheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage(Addition)

//截取部分图像
-(UIImage *)getSubImage:(CGRect)rect;

/*
 *  由本身返回可拉伸图片
 */
- (UIImage *)resizeImage;

/*
 *  不缓存的方式获取图片,限制为.png图片,不常用的图片用这种方法
 *
 *      name:图片文件名，不包括扩展名
 */
//+ (UIImage *)pngImageNamed:(NSString *)name;

/*
 *  用于获取可拉伸图像，不缓存方式
 *
 *      name:图片文件名，不包括扩展名
 */
//+ (UIImage *)resizePngImageNamed:(NSString *)name;

/*
 *  用于获取可拉伸图像，缓存方式
 *
 *      name:图片文件名，包括扩展名
 */
+ (UIImage *)resizeImageNamed:(NSString *)name;

//图片变灰
- (UIImage *)convertToGrayscale;

//获取灰色图片
+ (UIImage*)getGrayImage:(UIImage*)sourceImage;

//返回 黏贴图片到self 于 point 的 uiimage
- (UIImage *)addImage:(UIImage *)source atPoint:(CGPoint)point;

//返回重置图片大小的图片(scale = 1)
- (UIImage *)resizeImageWithSize:(CGSize)size;
//返回重置图片大小的图片
- (UIImage *)resizeImageWithSize:(CGSize)size scale:(CGFloat)scale;

/**
 *  压缩保存图片
 *
 *  @param path     要保存的全路径
 *  @param limitLen 限制文件大小(0-不压缩直接保存)
 *
 *  @return 压缩后的图片
 */
- (UIImage *)saveToPath:(NSString *)path limitDataLen:(int64_t)limitLen;

/*
 *  保持原来的长宽比，生成一个缩略图
 *  image:原图
 *  limitSize:限制缩略的最大size
 */
+ (UIImage *)thumbnailWithImageWithoutScale:(UIImage *)image limitSize:(CGSize)limitSize;

//等比压缩
- (UIImage *)scaleImageWithSize:(CGSize)size;
/**
 *	根据给定颜色生成图片
 *
 *	@param color 颜色
 *
 *	@return 图片
 */
+ (UIImage *)imageWithColor:(UIColor *)color;

/**
 *	根据给定颜色,大小生成图片
 *
 *	@param color 颜色
 *	@param size  大小
 *
 *	@return 图片
 */
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;

/**
 *	根据给定颜色,大小,圆角半径生成图片
 *
 *	@param color        颜色
 *	@param cornerRadius 圆角半径
 *	@param size         大小
 *
 *	@return UIImage
 */
+ (UIImage *)imageWithColor:(UIColor *)color cornerRadius:(CGFloat)cornerRadius size:(CGSize)size;

/**
 *	渐变颜色图片
 *
 *	@param size      大小
 *	@param from      开始颜色
 *	@param to        结束颜色
 *	@param direction 方向,米字型的8个方向
 *
 *	@return 图片
 */
+ (UIImage *)gradientImageWithSize:(CGSize)size fromColor:(UIColor *)from toColor:(UIColor *)to direction:(CGVector)direction;

/**
 *	生成图片,4条边界可选
 *
 *	@param color          背景色
 *	@param size           大小
 *	@param edge           边界
 *	@param separatorColor 边界颜色
 *
 *	@return UIImage
 */
+ (UIImage *)imageWithColor:(UIColor *)color
                       size:(CGSize)size
                  separator:(UIRectEdge)edge
             separatorColor:(UIColor *)separatorColor;

//获取增值服务图标
+(UIImage *)getZengZhiIconWithId:(NSString *)strId;
//获取 稿件状态 图标
+ (UIImage *)imageWithWorkStatus:(int)status;

@end
