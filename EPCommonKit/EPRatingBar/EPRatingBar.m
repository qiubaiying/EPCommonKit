//
//  EPRatingBar.m
//  EPWeiKe
//
//  Created by Mac on 15/6/4.
//  Copyright (c) 2015年 厦门思汉信息科技有限公司. All rights reserved.
//

#import "EPRatingBar.h"


@interface EPRatingBar()

@property (nonatomic,strong) UIView *bottomView;
@property (nonatomic,strong) UIView *topView;
@property (nonatomic,assign) CGFloat starWidth;

@end

@implementation EPRatingBar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        self.bottomView = [[UIView alloc] initWithFrame:self.bounds];
        self.topView = [[UIView alloc] initWithFrame:CGRectZero];
        
        [self addSubview:self.bottomView];
        [self addSubview:self.topView];
        
        self.topView.clipsToBounds = YES;
        self.topView.userInteractionEnabled = NO;
        self.bottomView.userInteractionEnabled = NO;
        self.userInteractionEnabled = YES;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
        [self addGestureRecognizer:tap];
        [self addGestureRecognizer:pan];
        
        CGFloat width = frame.size.width/7.0;
        self.starWidth = width;
        for(int i = 0;i<5;i++){
            
            UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, width, width)];
            img.center = CGPointMake(i*30 + width, frame.size.height/2);
            img.image = [UIImage imageNamed:@"my_ratingStar"];
            [self.bottomView addSubview:img];
            
            UIImageView *img2 = [[UIImageView alloc] initWithFrame:img.frame];
            img2.center = img.center;
            img2.image = [UIImage imageNamed:@"my_ratingStar_on"];
            [self.topView addSubview:img2];
        }
        self.enable = YES;
        
    }
    return self;
}

-(void)setStarViewWithFrame:(CGRect)frame
{
    // Initialization code
    self.backgroundColor = [UIColor clearColor];
    self.bottomView = [[UIView alloc] initWithFrame:self.bounds];
    self.topView = [[UIView alloc] initWithFrame:CGRectZero];
    
    [self addSubview:self.bottomView];
    [self addSubview:self.topView];
    
    self.topView.clipsToBounds = YES;
    self.topView.userInteractionEnabled = NO;
    self.bottomView.userInteractionEnabled = NO;
    self.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    [self addGestureRecognizer:tap];
    [self addGestureRecognizer:pan];
    
    CGFloat width = frame.size.width/10.0;
    self.starWidth = width;
    for(int i = 0;i<5;i++){
        
        UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, width, width)];
        img.center = CGPointMake(i*30 + width, frame.size.height/2);
        img.image = [UIImage imageNamed:@"my_ratingStar"];
        [self.bottomView addSubview:img];
        
        UIImageView *img2 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, width, width)];
        img2.center = CGPointMake(i*30 + width, frame.size.height/2);
        img2.image = [UIImage imageNamed:@"my_ratingStar_on"];
        [self.topView addSubview:img2];
    }
    self.enable = YES;

}

//设置星星个数
-(void)setStarNumber:(NSInteger)starNumber{
    if(_starNumber!=starNumber){
        _starNumber = starNumber;
        self.topView.frame = CGRectMake(0, 0, self.starWidth*(starNumber+1), self.bounds.size.height);
    }
}

//点击触发
-(void)tap:(UITapGestureRecognizer *)gesture{
    if(self.enable){
        CGPoint point = [gesture locationInView:self];
        NSInteger count = (ceil)(point.x/30);
        self.topView.frame = CGRectMake(0, 0, count*30 + 3, self.bounds.size.height);
        if(count>5){
            _starNumber = 5;
        }else{
            _starNumber = count;
        }
        if (self.selectBlock) {
            self.selectBlock((int)_starNumber);
        }
    }
}

//滑动触发
-(void)pan:(UIPanGestureRecognizer *)gesture{
    if(self.enable){
        CGPoint point = [gesture locationInView:self];
        NSInteger count = (ceil)(point.x/30);
        if(count>=0 && count<=5 && _starNumber!=count){
            self.topView.frame = CGRectMake(0, 0, count*30 + 3, self.bounds.size.height);
            _starNumber = count;
            if (self.selectBlock) {
                self.selectBlock((int)_starNumber);
            }
        }
    }
}

@end
