//
//  ViewController.m
//  GesturePassword
//
//  Created by 金文武 on 2018/10/23.
//  Copyright © 2018年 金文武. All rights reserved.
//

#import "ViewController.h"
#import "OpenGestureCell.h"
#import "GesturePasswordViewController.h"
#import "DefineTheme.h"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource,OpenGestureCellDelegate,GesturePasswordVCDelegate>
@property (weak, nonatomic) IBOutlet UITableView *listView;
@property (nonatomic, strong)NSMutableArray *dataSource;
@property (assign, nonatomic) BOOL gestureSwitch;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self initView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self initData];
    [self.listView reloadData];
}

- (void)initView
{
}

- (void)initData
{
    self.dataSource = [[NSMutableArray alloc] initWithObjects:@"是否启动手势", nil];
    NSDictionary *dic = [[NSUserDefaults standardUserDefaults] objectForKey:GESTUREPASSWORDSWITCH];
    self.gestureSwitch =  [[dic objectForKey:@"startUpGesturePSD"] boolValue];
    if (_gestureSwitch && self.dataSource.count != 2) {
        [self.dataSource addObject:@"重置手势密码"];
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        OpenGestureCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OpenGestureCell" forIndexPath:indexPath];
        cell.delagate = self;
        [cell initData:self.gestureSwitch];
        return cell;
    }else{
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        cell.textLabel.text = self.dataSource[indexPath.row];
        return cell;
    }
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 1) {
        GesturePasswordViewController *gestureVC = [[UIStoryboard storyboardWithName:@"GesturePassword" bundle:nil]instantiateInitialViewController];
        gestureVC.hidesBottomBarWhenPushed = YES;
        gestureVC.status = GesturePasswordStatusReset;
        gestureVC.delegate = self;
        [self.navigationController pushViewController:gestureVC animated:YES];
    }
}

#pragma mark - OpenGestureCellDelegate
- (void)choiceAction:(UIButton *)sender
{
    UISwitch *switchButton = (UISwitch*)sender;
    BOOL isButtonOn = [switchButton isOn];
    if (isButtonOn) {
        GesturePasswordViewController *gestureVC = [[UIStoryboard storyboardWithName:@"GesturePassword" bundle:nil]instantiateInitialViewController];
        gestureVC.hidesBottomBarWhenPushed = YES;
        gestureVC.status = GesturePasswordStatusSet;
        gestureVC.delegate = self;
        [self.navigationController pushViewController:gestureVC animated:YES];
    }else{
        NSUserDefaults *userdefault = [NSUserDefaults standardUserDefaults];
        [userdefault setObject:@{@"startUpGesturePSD":@(NO)} forKey:GESTUREPASSWORDSWITCH];
        [userdefault removeObjectForKey:GESTUREPASSWORD];
        [userdefault synchronize];
        self.gestureSwitch = NO;
        [self.dataSource removeLastObject];
        [self.listView reloadData];
    }
}

#pragma mark -GesturePasswordVCDelegate
- (void)updateTableView
{
    //    [self.data addObject:@"重置手势密码"];
    //    [self.tableView reloadData];
}
@end
