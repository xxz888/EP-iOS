//
//  KDTixianjiluViewController.m
//  KaDeShiJie
//
//  Created by mac on 2021/11/24.
//  Copyright © 2021 SS001. All rights reserved.
//

#import "KDTixianjiluViewController.h"
#import "KDTixianjiluTableViewCell.h"

@interface KDTixianjiluViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation KDTixianjiluViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    
    [self setNavigationBarTitle:@"提现记录" backgroundImage:[UIImage qmui_imageWithColor:[UIColor mainColor]]];
    [self.navigationController.navigationBar setShadowImage:nil];

    [self.tableView registerNib:[UINib nibWithNibName:@"KDTixianjiluTableViewCell" bundle:nil] forCellReuseIdentifier:@"KDTixianjiluTableViewCell"];
    self.tableView.backgroundColor=self.view.backgroundColor=[UIColor qmui_colorWithHexString:@"#F6F6F6"];
}


#pragma mark - QMUITableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 127;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    KDTixianjiluTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"KDTixianjiluTableViewCell" forIndexPath:indexPath];
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
