//
//  KDHomeBillManageViewController.m
//  KaDeShiJie
//
//  Created by mac on 2021/11/23.
//  Copyright © 2021 SS001. All rights reserved.
//

#import "KDHomeBillManageViewController.h"
#import "KDHomeBillManagerTableViewCell.h"

@interface KDHomeBillManageViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableview;

@end

@implementation KDHomeBillManageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavigationBarTitle:@"账单管理" tintColor:[UIColor whiteColor]];
    [self.tableview registerNib:[UINib nibWithNibName:@"KDHomeBillManagerTableViewCell" bundle:nil] forCellReuseIdentifier:@"KDHomeBillManagerTableViewCell"];
    
}


#pragma mark - QMUITableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 133;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    KDHomeBillManagerTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"KDHomeBillManagerTableViewCell" forIndexPath:indexPath];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

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
