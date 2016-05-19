//
//  ViewController.m
//  自定义删除Demo
//
//  Created by 孙云 on 16/5/19.
//  Copyright © 2016年 haidai. All rights reserved.
//

#import "ViewController.h"
#import "MyCell.h"
static NSString * const MYCELL = @"MyCell";
@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSMutableArray *array;
@property(nonatomic,strong)NSMutableArray *loveArray;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.array = [NSMutableArray arrayWithArray:[UIFont familyNames]];
    self.loveArray = [NSMutableArray array];
    [self initTableView];
    
    //获得通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(lookCell:) name:@"cellnot" object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark  not method
/**
 *  通知方法
 *
 *  @param user <#user description#>
 */
- (void)lookCell:(NSNotification *)user{

    NSDictionary *dic = user.userInfo;
    NSInteger index = [dic[@"cellindex"] integerValue];
    //获取所有的单元格,便利判断
    NSArray *array = _tableView.visibleCells;
    for (MyCell *cell in array) {
        //判断
        if (cell.showView.tag != index && cell.showView.contentOffset.x != 0) {
            [UIView animateWithDuration:0.1 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                [cell.showView setContentOffset:CGPointMake(0, 0)];
            } completion:nil];
        }
    }
    
}
#pragma mark  init
- (void)initTableView{

    _tableView = [[UITableView alloc]initWithFrame:self.view.bounds];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView registerClass:[MyCell class] forCellReuseIdentifier:MYCELL];
    
    [self.view addSubview:_tableView];
    
    //为了点击在空白处，判断是否有滑动的cell
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(TagTableView)];
    [self.tableView addGestureRecognizer:tap];
}
- (void)TagTableView{
    
    //获取所有的单元格,便利判断
    NSArray *array = _tableView.visibleCells;
    for (MyCell *cell in array) {
        //判断
        if (cell.showView.contentOffset.x != 0) {
            [UIView animateWithDuration:0.1 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                [cell.showView setContentOffset:CGPointMake(0, 0)];
            } completion:nil];
        }
    }

}
#pragma mark  tableview delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return 10;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    MyCell *cell = [tableView dequeueReusableCellWithIdentifier:MYCELL forIndexPath:indexPath];
    cell.nameLabel.text = self.array[indexPath.row];
    cell.deleBtn.tag = indexPath.row;
    cell.loveBtn.tag = indexPath.row;
    cell.showView.tag = indexPath.row;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    __block typeof(self)weakSelf = self;
    //删除
    cell.deleBlock = ^(NSInteger index){
    
        //删除操作
        [weakSelf.array removeObjectAtIndex:index];
        [weakSelf.tableView deleteRowsAtIndexPaths:[NSMutableArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    };
    //收藏
    cell.deleBlock = ^(NSInteger index){
    
        
    };
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    NSLog(@"%li",(long)indexPath.row);
}
/**
 *  让系统滑动取消
 *
 */
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{

    return NO;
}
#pragma mark  dealloc

- (void)dealloc{

    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

@end
