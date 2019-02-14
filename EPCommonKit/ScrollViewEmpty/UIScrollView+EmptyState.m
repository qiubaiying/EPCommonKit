//
//  UIScrollView+EmptyState.m
//  RenRenProject
//
//  Created by BY on 2018/7/11.
//  Copyright © 2018年 epwk. All rights reserved.
//

#import "UIScrollView+EmptyState.h"

static char const * const kEmptyDataType        = "emptyDataType";
static char const * const kEmptyDescription     = "emptyDescription";
static char const * const kEmptySubDescription  = "emptySubDescription";
static char const * const kEmptyVerticalOffset  = "emptyVerticalOffset";
static char const * const kTapBlock             = "tapBlock";

@interface UIScrollView()

@property (nonatomic, copy) TapBlock tapBlock;

@end

@implementation UIScrollView (EmptyState)

- (void)addEmptyPageWithBlock:(TapBlock)tapBlock {
    self.emptyDataSetDelegate = self;
    self.emptyDataSetSource = self;
    
    self.tapBlock = tapBlock;
}

- (void)addEmptyPageWithTitle:(NSString *)title
                        block:(TapBlock)tapBlock {
    self.emptyDescription = title;
    [self addEmptyPageWithBlock:tapBlock];
}

- (void)addEmptyPageWithTitle:(NSString *)title
                     subTitle:(NSString *)subTitle
                        block:(TapBlock)tapBlock {
    self.emptySubDescription = subTitle;
    [self addEmptyPageWithTitle:title block:tapBlock];
}

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    switch (self.emptyDataType) {
        case EPEmptyDataTypeLoading:
            return [UIImage imageNamed:@"loading"];
            break;
        case EPEmptyDataTypeNoData:
            return [UIImage imageNamed:@"loadingNoData_hs"];
            break;
        case EPEmptyDataTypeError:
            return [UIImage imageNamed:@"loadingError"];
            break;
        case EPEmptyDataTypeNoLogin:
            return [UIImage imageNamed:@"loadingNoData"];
            break;
//        case EPEmptyDataTypeAuthInProcessing:
//            return [UIImage imageNamed:@"authInProcessing"];
//            break;
//        case EPEmptyDataTypeAuthError:
//            return [UIImage imageNamed:@"authError"];
//            break;
//        case EPEmptyDataTypeAuthSuccess:
//            return [UIImage imageNamed:@"loadingError"];
//            break;
        default:
            break;
    }
    return [UIImage imageNamed:@"loadingNoData"];
}

- (CAAnimation *)imageAnimationForEmptyDataSet:(UIScrollView *)scrollView {
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform"];
    animation.fromValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
    animation.toValue = [NSValue valueWithCATransform3D: CATransform3DMakeRotation(M_PI_2, 0.0, 0.0, 1.0) ];
    animation.duration = 0.25;
    animation.cumulative = YES;
    animation.repeatCount = MAXFLOAT;
    
    return animation;
}

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *title = @"";
    NSDictionary *attributes = @{NSFontAttributeName:[UIFont boldSystemFontOfSize:18.0f],
                                 NSForegroundColorAttributeName:[UIColor darkGrayColor]};
    switch (self.emptyDataType) {
        case EPEmptyDataTypeLoading:
        {
            title = @"加载中...";
            attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:16.0f],
                           NSForegroundColorAttributeName:[UIColor grayColor]};
        }
            break;
        case EPEmptyDataTypeNoData:
        {
            title = self.description.length ? self.description : @"暂无数据";
            attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:16.0f],
                           NSForegroundColorAttributeName:[UIColor grayColor]};
        }
            break;
        case EPEmptyDataTypeError:
        {
            title = @"加载失败,点击重试";
            attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:16.0f],
                           NSForegroundColorAttributeName:[UIColor grayColor]};
        }
            break;
        case EPEmptyDataTypeNoLogin:
            title = @"请先登录";
            break;
//        case EPEmptyDataTypeAuthSuccess:
//            title = @"您已成功入驻";
//            break;
//        case EPEmptyDataTypeAuthError:
//            title = @"您的入驻信息审核失败";
//            break;
//        case EPEmptyDataTypeAuthInProcessing:
//            title = @"您的入驻申请还未处理";
//            break;
        default:
            break;
    }
    return [[NSAttributedString alloc] initWithString:title attributes:attributes];
}

- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = self.emptySubDescription;
    UIFont *font = [UIFont systemFontOfSize:16.0];
    UIColor *textColor = [UIColor lightGrayColor];
    
    NSMutableDictionary *attributes = [NSMutableDictionary new];
    NSMutableParagraphStyle *paragraph = [NSMutableParagraphStyle new];
    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    paragraph.alignment = NSTextAlignmentCenter;
    [attributes setObject:font forKey:NSFontAttributeName];
    [attributes setObject:textColor forKey:NSForegroundColorAttributeName];
    [attributes setObject:paragraph forKey:NSParagraphStyleAttributeName];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:text attributes:attributes];
    return attributedString;
    
//    switch (self.emptyDataType) {
//        case EPEmptyDataTypeAuthSuccess:
//        {
//            text = @"请勿重新提交入驻申请";
//            NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:text attributes:attributes];
//            return attributedString;
//        }
//            break;
//        case EPEmptyDataTypeAuthError:
//        {
//            if (self.description) {
//                text = self.emptySubDescription;
//                NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:text attributes:attributes];
//                return attributedString;
//            }
//        }
//            break;
//        case EPEmptyDataTypeAuthInProcessing:
//        {
//            text = @"请耐心等待，也可联系客服400-700-8555处理！";
//            NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:text attributes:attributes];
//            return attributedString;
//        }
//            break;
//        default:
//            break;
//
//
//    }
    return nil;
}
//有按钮  按钮标题
- (NSAttributedString *)buttonTitleForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state
{
    UIFont *font = [UIFont systemFontOfSize:17.0];
    UIColor *textColor = [UIColor whiteColor];
    NSMutableDictionary *attributes = [NSMutableDictionary new];
    [attributes setObject:font forKey:NSFontAttributeName];
    [attributes setObject:textColor forKey:NSForegroundColorAttributeName];
    
//    if (self.emptyDataType == EPEmptyDataTypeAuthError) {
//        NSString *text = @"重新申请";
//        return [[NSAttributedString alloc] initWithString:text attributes:attributes];
//    }
    
    return nil;
}

//有按钮  按钮背景
- (UIImage *)buttonBackgroundImageForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state
{
//    if (self.emptyDataType == EPEmptyDataTypeAuthError) {
//        UIImage *image = [UIImage imageNamed:@"btnBackground"];
//        image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(image.size.height*0.5, image.size.width*0.5, image.size.height*0.5, image.size.width*0.5) resizingMode:UIImageResizingModeStretch];
//        return image;
//    }
    
    return nil;
}
//按钮图标
- (UIImage *)buttonImageForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state
{
//    if (self.emptyDataType == EPEmptyDataTypeAuthError) {
//        UIImage *image = [UIImage imageNamed:@"reSubmit"];
//        return image;
//    }
    return nil;
}


//* 图片和文件的距离
- (CGFloat)spaceHeightForEmptyDataSet:(UIScrollView *)scrollView {
    return 15.0f;
}

/** 垂直挪动 */
- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView {
    if (fabs(self.emptyVerticalOffset) > 0.001) {
        return self.emptyVerticalOffset;
    }
    return -30;
}

/** 可以滑动 */
- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView {
    return YES;
}

- (BOOL)emptyDataSetShouldAnimateImageView:(UIScrollView *)scrollView
{
    BOOL isLoading = self.emptyDataType==EPEmptyDataTypeLoading?YES:NO;
    return isLoading;
}

- (BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView{
    if (self.emptyDataType == EPEmptyDataTypeDismiss) {
        return NO;
    }
    return YES;
}

- (BOOL)emptyDataSetShouldAllowTouch:(UIScrollView *)scrollView
{
    if (self.emptyDataType == EPEmptyDataTypeError ||
        self.emptyDataType == EPEmptyDataTypeNoNetwork ||
        self.emptyDataType == EPEmptyDataTypeBtn ||
        self.emptyDataType == EPEmptyDataTypeNoLogin) {
        return YES;
    }
    return NO;
}

- (void)emptyDataSet:(UIScrollView *)scrollView didTapView:(UIView *)view
{
    if (self.emptyDataType == EPEmptyDataTypeError || self.emptyDataType == EPEmptyDataTypeNoNetwork) {
        self.emptyDataType = EPEmptyDataTypeLoading;
        [self reloadEmptyDataSet];
    }
    if (self.tapBlock) {
        self.tapBlock();
    }
}


- (void)emptyDataSet:(UIScrollView *)scrollView didTapButton:(UIButton *)button
{
    if (self.tapBlock) {
        self.tapBlock();
    }
}
#pragma mark - objc_setAssociatedObject

- (void)setEmptyDataType:(EPEmptyDataType)emptyDataType {
    objc_setAssociatedObject(self, kEmptyDataType, @(emptyDataType), OBJC_ASSOCIATION_ASSIGN);
    [self reloadEmptyDataSet];
}

- (EPEmptyDataType)emptyDataType {
    return [objc_getAssociatedObject(self, kEmptyDataType) integerValue];
}


- (void)setTapBlock:(TapBlock)tapBlock {
    objc_setAssociatedObject(self, kTapBlock, tapBlock, OBJC_ASSOCIATION_COPY);
}

- (TapBlock)tapBlock {
    return objc_getAssociatedObject(self, kTapBlock);
}

- (void)setEmptyDescription:(NSString *)emptyDescription {
    objc_setAssociatedObject(self, kEmptyDescription, emptyDescription, OBJC_ASSOCIATION_COPY);
}

- (NSString *)emptyDescription {
    return objc_getAssociatedObject(self, kEmptyDescription);
}

- (void)setEmptySubDescription:(NSString *)emptySubDescription {
    objc_setAssociatedObject(self, kEmptySubDescription, emptySubDescription, OBJC_ASSOCIATION_COPY);
}

- (NSString *)emptySubDescription {
    return objc_getAssociatedObject(self, kEmptySubDescription);

}

- (void)setEmptyVerticalOffset:(CGFloat)emptyVerticalOffset {
    objc_setAssociatedObject(self, kEmptyVerticalOffset, @(emptyVerticalOffset), OBJC_ASSOCIATION_ASSIGN);
}

- (CGFloat)emptyVerticalOffset {
    return [objc_getAssociatedObject(self, kEmptyVerticalOffset) floatValue];
}

@end
