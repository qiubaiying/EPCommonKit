//
//  EPRatingBar.h
//  EPWeiKe
//
//  Created by Mac on 15/6/4.
//  Copyright (c) 2015年 厦门思汉信息科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EPRatingBar : UIView

/*
 *星级个数
 */
@property (nonatomic) NSInteger starNumber;

/*
 *是否允许评价
 */
@property (nonatomic,assign) BOOL enable;

@property (copy, nonatomic) void(^selectBlock)(int);//选择 或 滑动星星后 回调

-(void)setStarViewWithFrame:(CGRect)frame;



@end
