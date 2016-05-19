//
//  MyCell.h
//  自定义删除Demo
//
//  Created by 孙云 on 16/5/19.
//  Copyright © 2016年 haidai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyCell : UITableViewCell
@property(nonatomic,strong)UILabel *nameLabel;
@property(nonatomic,strong)UIButton *deleBtn;
@property(nonatomic,strong)UIButton *loveBtn;
@property(nonatomic,strong)UIScrollView *showView;//滑动视图
@property(nonatomic,copy)void(^deleBlock)(NSInteger index);
@property(nonatomic,copy)void(^loveBlock)(NSInteger index);
@end
