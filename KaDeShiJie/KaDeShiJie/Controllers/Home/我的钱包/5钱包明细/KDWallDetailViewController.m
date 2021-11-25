//
//  KDWallDetailViewController.m
//  KaDeShiJie
//
//  Created by mac on 2021/11/25.
//  Copyright © 2021 SS001. All rights reserved.
//

#import "KDWallDetailViewController.h"
#import "KDWallDetailTableViewCell.h"

@interface KDWallDetailViewController ()< QMUITableViewDataSource, QMUITableViewDelegate>

@end

@implementation KDWallDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavigationBarTitle:@"提现记录" backgroundImage:[UIImage qmui_imageWithColor:[UIColor mainColor]]];
    [self.navigationController.navigationBar setShadowImage:nil];

    
    self.mc_tableview.delegate = self;
    self.mc_tableview.dataSource = self;
    [self.mc_tableview registerNib:[UINib nibWithNibName:@"KDWallDetailTableViewCell" bundle:nil] forCellReuseIdentifier:@"KDWallDetailTableViewCell"];

    
}
#pragma mark - QMUITableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    KDWallDetailTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"KDWallDetailTableViewCell" forIndexPath:indexPath];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

}
- (void)layoutTableView
{
    self.mc_tableview.frame = CGRectMake(0, 10, SCREEN_WIDTH, SCREEN_HEIGHT - NavigationContentTop);
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
