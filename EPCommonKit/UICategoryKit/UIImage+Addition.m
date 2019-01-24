//
//  UIImage+Addition.m
//  Epweike_Witkey
//
//  Created by Mac on 15/7/29.
//  Copyright (c) 2015年 zengxusheng. All rights reserved.
//

#import "UIImage+Addition.h"

@implementation UIImage(Addition)

//截取部分图像
-(UIImage*)getSubImage:(CGRect)rect
{
    CGImageRef subImageRef = CGImageCreateWithImageInRect(self.CGImage, rect);
    CGRect smallBounds = CGRectMake(0, 0, CGImageGetWidth(subImageRef), CGImageGetHeight(subImageRef));
    
    UIGraphicsBeginImageContext(smallBounds.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextDrawImage(context, smallBounds, subImageRef);
    UIImage* smallImage = [UIImage imageWithCGImage:subImageRef];
    CFRelease(subImageRef);
    UIGraphicsEndImageContext();
    
    return smallImage;
}

//+ (UIImage *)themeImageAndCache:(NSString *)fullPath
//{
//    if (!iPhone3)
//    {
//        NSString *extension = [fullPath pathExtension];
//        fullPath = [fullPath stringByDeletingPathExtension];
//        if ([fullPath hasSuffix:@"@2x"])
//        {
//            fullPath = [NSString stringWithFormat:@"%@.%@",fullPath,extension];
//        }
//        else
//        {
//            fullPath = [NSString stringWithFormat:@"%@@2x.%@",fullPath,extension];
//        }
//    }
//    UIImage *image = [UIImage cacheImageAndWaitWithIdentifier:fullPath size:CGSizeZero];
//    if (!image)
//    {
//        image = [UIImage imageWithContentsOfFile:fullPath];
//    }
//    return image;
//}


/*
 *  返回可拉伸图片
 *      image：图片对象
 */
- (UIImage *)resizeImage
{
    return [self resizableImageWithCapInsets:UIEdgeInsetsMake(self.size.height/2, self.size.width/2, self.size.height/2, self.size.width/2)];
}

/*
 *  不缓存的方式获取图片,限制为.png图片,不常用的图片用这种方法
 *
 *      name:图片文件名，不包括扩展名
 */
//+ (UIImage *)pngImageNamed:(NSString *)name
//{
//    NSString *bgPath = [[NSBundle mainBundle] pathForResource:name ofType:@"png"];
//    if (bgPath == nil)
//    {
//        bgPath = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%@@2x",name] ofType:@"png"];
//    }
//    UIImage *image = [UIImage cacheImageAndWaitWithIdentifier:bgPath size:CGSizeZero];
//    if (image == nil)
//    {
//        image = [UIImage imageWithContentsOfFile:bgPath];
//    }
//    return image;
//}

/*
 *  用于获取可拉伸图像，不缓存方式
 */
//+ (UIImage *)resizePngImageNamed:(NSString *)name
//{
//    UIImage *image = [self pngImageNamed:name];
//    return [image resizableImageWithCapInsets:UIEdgeInsetsMake(image.size.height/2, image.size.width/2, image.size.height/2, image.size.width/2)];
//}

/*
 *  用于获取可拉伸图像，缓存方式
 */
+ (UIImage *)resizeImageNamed:(NSString *)name
{
    UIImage *image = [self imageNamed:name];
    return [image resizableImageWithCapInsets:UIEdgeInsetsMake(image.size.height/2, image.size.width/2, image.size.height/2, image.size.width/2)];
}



typedef enum {
    ALPHA = 0,
    BLUE = 1,
    GREEN = 2,
    RED = 3
} PIXELS;

//图片变灰
- (UIImage *)convertToGrayscale
{
    CGSize size = [self size];
    int width = size.width;
    int height = size.height;
    
    // the pixels will be painted to this array
    uint32_t *pixels = (uint32_t *) malloc(width * height * sizeof(uint32_t));
    
    // clear the pixels so any transparency is preserved
    memset(pixels, 0, width * height * sizeof(uint32_t));
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    // create a context with RGBA pixels
    CGContextRef context = CGBitmapContextCreate(pixels, width, height, 8, width * sizeof(uint32_t), colorSpace,
                                                 kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedLast);
    
    // paint the bitmap to our context which will fill in the pixels array
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), [self CGImage]);
    
    for(int y = 0; y < height; y++)
    {
        for(int x = 0; x < width; x++)
        {
            uint8_t *rgbaPixel = (uint8_t *) &pixels[y * width + x];
            
            // convert to grayscale using recommended method: http://en.wikipedia.org/wiki/Grayscale#Converting_color_to_grayscale
            uint32_t gray = 0.3 * rgbaPixel[RED] + 0.59 * rgbaPixel[GREEN] + 0.11 * rgbaPixel[BLUE];
            
            // set the pixels to gray
            rgbaPixel[RED] = gray;
            rgbaPixel[GREEN] = gray;
            rgbaPixel[BLUE] = gray;
        }
    }
    
    // create a new CGImageRef from our context with the modified pixels
    CGImageRef image = CGBitmapContextCreateImage(context);
    
    // we're done with the context, color space, and pixels
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    free(pixels);
    
    // make a new UIImage to return
    UIImage *resultUIImage = [UIImage imageWithCGImage:image];
    
    // we're done with image now too
    CGImageRelease(image);
    
    return resultUIImage;
}

//获取灰色图片
+ (UIImage*)getGrayImage:(UIImage*)sourceImage
{
    int width = sourceImage.size.width;
    int height = sourceImage.size.height;
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray();
    CGContextRef context = CGBitmapContextCreate (nil,width,height,8,0,colorSpace,kCGBitmapAlphaInfoMask);
    CGColorSpaceRelease(colorSpace);
    
    if (context == NULL) {
        return nil;
    }
    
    CGContextDrawImage(context,CGRectMake(0, 0, width, height), sourceImage.CGImage);
    CGImageRef grayImageRef = CGBitmapContextCreateImage(context);
    UIImage *grayImage = [UIImage imageWithCGImage:grayImageRef];
    CGContextRelease(context);
    CGImageRelease(grayImageRef);
    
    return grayImage;
}

//返回 黏贴图片到self 于 point 的 uiimage
- (UIImage *)addImage:(UIImage *)source atPoint:(CGPoint)point
{
    CGSize sourceSize = source.size;
    //计算新图尺寸
    CGSize newSize = CGSizeMake(MAX(sourceSize.width+point.x, self.size.width),
                                MAX(sourceSize.height+point.y, self.size.height));
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0);
    
    [self drawInRect:CGRectMake(0, 0, newSize.width, newSize.height) blendMode:kCGBlendModeNormal alpha:1];
    [source drawAtPoint:point blendMode:kCGBlendModeNormal alpha:1.0];
    
    //获取当前图形环境
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //设置画笔颜色
    CGContextSetRGBStrokeColor(context, 1.0, 1.0, 1.0, 0.0);
    //设置画笔大小
    CGContextStrokeRect(context, CGRectMake(0, 0, newSize.width, newSize.height));
    UIImage *testImage = UIGraphicsGetImageFromCurrentImageContext();
    //结束
    UIGraphicsEndImageContext();
    return testImage;
}

#pragma mark - 裁剪图片、缩略图生成、图片压缩保存...

//返回重置图片大小的图片(使用设备的scale)
- (UIImage *)resizeImageWithSize:(CGSize)size;
{
    return [self resizeImageWithSize:size scale:1];
}

//返回重置图片大小的图片
- (UIImage *)resizeImageWithSize:(CGSize)size scale:(CGFloat)scale
{
    size = CGSizeMake(floorf(size.width), floorf(size.height));
    UIGraphicsBeginImageContextWithOptions(size, NO, scale);
    [self drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *temp = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return temp;
}

/**
 *  压缩保存图片
 *
 *  @param path     要保存的全路径
 *  @param limitLen 限制文件大小(0-不压缩直接保存)
 *
 *  @return 压缩后的图片
 */
- (UIImage *)saveToPath:(NSString *)path limitDataLen:(int64_t)limitLen
{
    float compression = 1.0;
    NSData *imageData = UIImageJPEGRepresentation(self, compression);
    while (imageData.length > limitLen && compression > 0)
    {
        compression -= .1;
        imageData = UIImageJPEGRepresentation(self, compression);
        //无限制不压缩
        if (limitLen == 0) {
            break;
        }
    }
    
    [imageData writeToFile:path atomically:YES];
    
    //无压缩
    if (limitLen == 0) {
        return self;
    }
    
    //压缩后的图片
    UIImage *image = [[UIImage alloc] initWithData:imageData];
    return image;
}



/*
 *  保持原来的长宽比，生成一个缩略图
 *  image:原图
 *  limitSize:限制缩略的最大size
 */
+ (UIImage *)thumbnailWithImageWithoutScale:(UIImage *)image limitSize:(CGSize)limitSize
{
    //缩略图
    UIImage *newImage = nil;
    if (image == nil)
    {
        return nil;
    }
    //原图size
    CGSize oldSize = image.size;
    CGSize newSize = oldSize;
    
    //高宽比
    double aspectRatio = oldSize.height/oldSize.width;
    //宽高比
    double aspectRatioT = oldSize.width/oldSize.height;
    
    //宽度超过限制
    if (oldSize.width > limitSize.width)
    {
        newSize.width = limitSize.width;
        newSize.height = limitSize.width*aspectRatio;
    }
    //高度超标
    if (newSize.height > limitSize.height)
    {
        newSize.height = limitSize.height;
        newSize.width = limitSize.height*aspectRatioT;
    }
    
    //无变化 且图片方法正常 直接返回原图
    if (CGSizeEqualToSize(newSize, oldSize)
        && image.imageOrientation == UIImageOrientationUp)
    {
        return image;
    }
    
    newImage = [image resizeImageWithSize:newSize];
    return newImage;
}

//等比压缩
- (UIImage *)scaleImageWithSize:(CGSize)size
{
    UIGraphicsBeginImageContext(size);
    CGRect rect = {{0,0}, size};
    [self drawInRect:rect];
    UIImage *compressedImg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return compressedImg;
}

/**
 *	根据给定颜色生成图片
 *
 *	@param color 颜色
 *
 *	@return 图片
 */
+ (UIImage *)imageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

/**
 *	根据给定颜色,大小生成图片
 *
 *	@param color 颜色
 *	@param size  大小
 *
 *	@return 图片
 */
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size
{
    return [UIImage imageWithColor:color cornerRadius:0 size:size];
}

/**
 *	根据给定颜色,大小,圆角半径生成图片
 *
 *	@param color        颜色
 *	@param cornerRadius 圆角半径
 *	@param size         大小
 *
 *	@return UIImage
 */
+ (UIImage *)imageWithColor:(UIColor *)color cornerRadius:(CGFloat)cornerRadius size:(CGSize)size
{
    UIGraphicsBeginImageContextWithOptions(size, NO, [UIScreen mainScreen].scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, size.width, size.height) cornerRadius:cornerRadius];
    CGContextAddPath(context, path.CGPath);
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillPath(context);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

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
+ (UIImage *)gradientImageWithSize:(CGSize)size fromColor:(UIColor *)from toColor:(UIColor *)to direction:(CGVector)direction
{
    UIGraphicsBeginImageContextWithOptions(size, NO, [UIScreen mainScreen].scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGPoint startPoint, endPoint;
    if (direction.dx > 0)
    {
        startPoint.x = 0;
        endPoint.x = size.width;
    }
    else if (direction.dx == 0)
    {
        startPoint.x = 0;
        endPoint.x = 0;
    }
    else
    {
        endPoint.x = 0;
        startPoint.x = size.width;
    }
    if (direction.dy > 0)
    {
        startPoint.y = 0;
        endPoint.y = size.height;
    }
    else if (direction.dy == 0)
    {
        startPoint.y = 0;
        endPoint.y = 0;
    }
    else
    {
        endPoint.y = 0;
        startPoint.y = size.height;
    }
    
    CGColorSpaceRef rgb = CGColorSpaceCreateDeviceRGB();
    NSArray *colorArray = @[(id)from.CGColor, (id)to.CGColor];
    CGFloat locations[] = {0.0,1.0};
    CGGradientRef gradient = CGGradientCreateWithColors(rgb, (__bridge CFArrayRef)(colorArray), locations);
    CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, 0);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    CGColorSpaceRelease(rgb);
    CGGradientRelease(gradient);
    return image;
}

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
             separatorColor:(UIColor *)separatorColor
{
    size = CGSizeMake(floorf(size.width), floorf(size.height));
    
    UIGraphicsBeginImageContextWithOptions(size, NO, [UIScreen mainScreen].scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, CGRectMake(0, 0, size.width, size.height));
    
    if (separatorColor && edge != UIRectEdgeNone)
    {
        CGFloat lineWidth = 0.5;
        CGContextSetLineWidth(context, lineWidth/2);
        if (edge & UIRectEdgeTop)
        {
            CGContextMoveToPoint(context, 0, 0+lineWidth/2);
            CGContextAddLineToPoint(context, size.width, 0+lineWidth/2);
        }
        if (edge & UIRectEdgeLeft)
        {
            CGContextMoveToPoint(context, 0+lineWidth/2, 0);
            CGContextAddLineToPoint(context, 0+lineWidth/2, size.height);
        }
        if (edge & UIRectEdgeBottom)
        {
            CGContextMoveToPoint(context, 0, size.height-lineWidth/2);
            CGContextAddLineToPoint(context, size.width, size.height-lineWidth/2);
        }
        if (edge & UIRectEdgeRight)
        {
            CGContextMoveToPoint(context, size.width-lineWidth/2, 0);
            CGContextAddLineToPoint(context, size.width-lineWidth/2, size.height);
        }
        
        CGContextSetLineCap(context, kCGLineCapSquare);
        CGContextSetStrokeColorWithColor(context, separatorColor.CGColor);
        CGContextStrokePath(context);
    }
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

//获取增值服务图标
+(UIImage *)getZengZhiIconWithId:(NSString *)strId
{
    int i = [strId intValue];
    UIImage *img = [[UIImage alloc] init];
    switch (i) {
        case 2:
            img = [UIImage imageNamed:@"serviceDing"];  //顶
            break;
        case 3:
            img = [UIImage imageNamed:@"serviceJi"]; //急
            break;
        case 4:
            img = [UIImage imageNamed:@"servicePing"];//屏
            break;
        case 6:
            img = [UIImage imageNamed:@"serviceYin"];//隐
            break;
        case 13:
            img = [UIImage imageNamed:@"serviceWei"];//卫
            break;
        default:
            break;
    }
    return img;
}
//获取 稿件状态 图标
+ (UIImage *)imageWithWorkStatus:(int)status
{
    NSString *imgName = nil;
    if (status>0&&status<=5) {
        imgName = [NSString stringWithFormat:@"bid_%d.png",status];
    }
    else if (status == 11) imgName = @"zhongBiao.png";
    else if (status == 12) imgName = @"heGe.png";
    else if (status == 13) imgName = @"ruWei.png";
    else if (status == 14) imgName = @"beiXuan.png";
    else if (status == 15) imgName = @"taoTai.png";
    
    if (imgName) {
        return [UIImage imageNamed:imgName];
    }
    return nil;
}


@end
