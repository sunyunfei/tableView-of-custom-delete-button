//
//  MyCell.m
//  自定义删除Demo
//
//  Created by 孙云 on 16/5/19.
//  Copyright © 2016年 haidai. All rights reserved.
//

#import "MyCell.h"
#define K_WIDTH [UIScreen mainScreen].bounds.size.width
#define K_HEIGHT [UIScreen mainScreen].bounds.size.height
@interface MyCell()<UIScrollViewDelegate,UIGestureRecognizerDelegate>
{

    CGFloat lastOffset;
    BOOL flag;
}
@end
@implementation MyCell
#pragma mark init
//构造
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{

    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

        //上面覆盖视图
        _showView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.contentView.frame.size.width, self.contentView.frame.size.height)];
        _showView.backgroundColor = [UIColor lightGrayColor];
        _showView.decelerationRate = 0.1;
        _showView.delegate = self;
        _showView.bounces = NO;
        _showView.showsVerticalScrollIndicator = NO;
        _showView.showsHorizontalScrollIndicator = NO;
        _showView.contentSize = CGSizeMake(self.contentView.frame.size.width + 120, self.contentView.frame.size.height);
        [self.contentView addSubview:_showView];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapThing)];
        [self.showView addGestureRecognizer:tap];
        
        //显示部分
        _nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.contentView.frame.size.width, self.contentView.frame.size.height)];
        _nameLabel.textAlignment = NSTextAlignmentCenter;
        [_showView addSubview:_nameLabel];
        
        //底部按钮显示
        //dele
        _deleBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        _deleBtn.frame = CGRectMake(self.contentView.frame.size.width , 0, 60, self.contentView.frame.size.height);
        _deleBtn.backgroundColor = [UIColor redColor];
        [_deleBtn setTitle:@"删除" forState:UIControlStateNormal];
        [_deleBtn addTarget:self action:@selector(clickDele:) forControlEvents:UIControlEventTouchUpInside];
        [_showView addSubview:_deleBtn];
        
        //love
        _loveBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        _loveBtn.frame = CGRectMake(self.contentView.frame.size.width + 60, 0, 60, self.contentView.frame.size.height);
        _loveBtn.backgroundColor = [UIColor yellowColor];
        [_loveBtn setTitle:@"收藏" forState:UIControlStateNormal];
        [_loveBtn addTarget:self action:@selector(clickLove:) forControlEvents:UIControlEventTouchUpInside];
        [_showView addSubview:_loveBtn];
        

    }
    return self;
}
#pragma mark cell return origin state

- (void)prepareForReuse{

    [super prepareForReuse];
    _showView.contentOffset = CGPointMake(0, 0);
}
#pragma mark  btn method

- (void)clickDele:(UIButton *)sender{

    NSLog(@"dele");
    if (self.deleBlock) {
        self.deleBlock(sender.tag);
    }
}
- (void)clickLove:(UIButton *)sender{

    NSLog(@"love");
    if (self.loveBlock) {
        self.loveBlock(sender.tag);
    }
}

#pragma mark scrollview delegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{

    //首先发送一个通知，去查看其他的cell有没有移动，如果有，恢复
    NSDictionary *dic = @{@"cellindex":[NSString stringWithFormat:@"%li",(long)_showView.tag]};
    [[NSNotificationCenter defaultCenter]postNotificationName:@"cellnot" object:nil userInfo:dic];
    
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{

    
    
    //判断
    CGFloat offsetX = _showView.contentOffset.x;
    if (offsetX > lastOffset + 1) {
        [UIView animateWithDuration:0.1 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
           [_showView setContentOffset:CGPointMake(120, 0)];
        } completion:nil];
        
    }else if (offsetX < lastOffset){
    
        [UIView animateWithDuration:0.1 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            [_showView setContentOffset:CGPointMake(0, 0)];
        } completion:nil];

    }
    lastOffset = offsetX;
}
#pragma mark  tag method

- (void)tapThing{

    
    //判断是否处于滑动状态
    if (_showView.contentOffset.x != 0) {
        [UIView animateWithDuration:0.1 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            [_showView setContentOffset:CGPointMake(0, 0)];
        } completion:nil];
    }else{
    
       NSLog(@"%li",(long)_showView.tag);
        //首先发送一个通知，去查看其他的cell有没有移动，如果有，恢复
        NSDictionary *dic = @{@"cellindex":[NSString stringWithFormat:@"%li",(long)_showView.tag]};
        [[NSNotificationCenter defaultCenter]postNotificationName:@"cellnot" object:nil userInfo:dic];
    }
}
#pragma mark gesture delegate   aim  mutable gesture can coexist

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{

    return YES;
}
@end
