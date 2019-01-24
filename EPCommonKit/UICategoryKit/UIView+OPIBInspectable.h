//
//  UIView+HDIBInspectable.h
//  YQW
//
//  Created by suziqiang on 16/7/15.
//  Copyright (c) 2016年 YQW. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (OPIBInspectable)

@property (assign, nonatomic) IBInspectable NSInteger cornerRadius;
@property (assign, nonatomic) IBInspectable NSInteger borderWidth;
@property (strong, nonatomic) IBInspectable UIColor *borderColor;

@end
