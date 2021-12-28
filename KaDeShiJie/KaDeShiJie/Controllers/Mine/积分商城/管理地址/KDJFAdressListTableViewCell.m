//
//  KDJFAdressListTableViewCell.m
//  KaDeShiJie
//
//  Created by apple on 2021/6/15.
//  Copyright © 2021 SS001. All rights reserved.
//

#import "KDJFAdressListTableViewCell.h"
#import "KDJFAdressManagerViewController.h"
@implementation KDJFAdressListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (IBAction)editAction:(id)sender {
    
    
    KDJFAdressManagerViewController * vc = [[KDJFAdressManagerViewController alloc]init];
    vc.whereCome = NO;
    vc.startDic = self.startDic;
    [MCLATESTCONTROLLER.navigationController pushViewController:vc animated:YES];

}
- (IBAction)delAction:(id)sender {

    kWeakSelf(self)
    QMUIAlertController *alert = [QMUIAlertController alertControllerWithTitle:@"温馨提示" message:@"确定要删除此地址吗？" preferredStyle:QMUIAlertControllerStyleAlert];
    [alert addAction:[QMUIAlertAction actionWithTitle:@"取消" style:QMUIAlertActionStyleDefault handler:nil]];
    [alert addAction:[QMUIAlertAction actionWithTitle:@"删除" style:QMUIAlertActionStyleDefault handler:^(__kindof QMUIAlertController * _Nonnull aAlertController, QMUIAlertAction * _Nonnull action) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
         
            [MCSessionManager.shareManager mc_put:@"/api/v1/player/shop/address" parameters:@{@"status":@"Delete",@"id":[NSString stringWithFormat:@"%@",self.startDic[@"id"]]} ok:^(NSDictionary * _Nonnull respDic) {
                [MCToast showMessage:@"删除成功"];
                if (weakself.refreshUIBlock) {
                    weakself.refreshUIBlock();
                 }
            } other:^(NSDictionary * _Nonnull respDic) {
                
            } failure:^(NSError * _Nonnull error) {
                
            }];
        });

    }]];
    [alert showWithAnimated:YES];
    
    
}

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"KDJFAdressListTableViewCell";
    KDJFAdressListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        [tableView registerNib:[UINib nibWithNibName:@"KDJFAdressListTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:ID];
        cell = [tableView dequeueReusableCellWithIdentifier:ID];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
