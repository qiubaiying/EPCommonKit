//
//  UIView+HDIBInspectable.m
//  YQW
//
//  Created by suziqiang on 16/7/15.
//  Copyright (c) 2016年 YQW. All rights reserved.
//

#import "UIView+OPIBInspectable.h"

@implementation UIView (OPIBInspectable)

#pragma mark - setCornerRadius/borderWidth/borderColor
- (void)setCornerRadius:(NSInteger)cornerRadius
{
    self.layer.cornerRadius = cornerRadius;
    self.layer.masksToBounds = cornerRadius > 0;
}

- (NSInteger)cornerRadius
{
    return self.layer.cornerRadius;
}

- (void)setBorderWidth:(NSInteger)borderWidth
{
    self.layer.borderWidth = borderWidth;
}

- (NSInteger)borderWidth
{
    return self.layer.borderWidth;
}

- (void)setBorderColor:(UIColor *)borderColor
{
    self.layer.borderColor = borderColor.CGColor;
}

- (UIColor *)borderColor
{
    return [UIColor colorWithCGColor:self.layer.borderColor];
}

@end
