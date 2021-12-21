//
//  MCUserInfoViewController.m
//  MCOEM
//
//  Created by wza on 2020/4/16.
//  Copyright © 2020 MingChe. All rights reserved.
//

#import "MCUserInfoViewController.h"
#import "MCBindALIViewController.h"
@interface MCUserInfoViewController () <QMUITableViewDataSource, QMUITableViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property(nonatomic, strong) NSArray *dataArray;
@property(nonatomic, copy) NSString *aliPhone;
@property(nonatomic, copy) NSString *headImg;
@property(nonatomic, copy) NSString *nickname;

@end

@implementation MCUserInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNavigationBarTitle:@"个人信息" tintColor:UIColor.whiteColor];
    self.mc_tableview.dataSource = self;
    self.mc_tableview.delegate = self;
    self.mc_tableview.mj_header = nil;
    self.mc_tableview.separatorInset = UIEdgeInsetsZero;
    self.aliPhone = @"未绑定";
    [self reloadData];
    
    
}
-(void)refreshVC{
    
    self.dataArray = @[
        @{@"title":@"头像",
          @"subTitle":SharedUserInfo.headImg ?:@""},
        @{@"title":@"昵称",
          @"subTitle":SharedUserInfo.nickname ?:@"请填写昵称"},
        @{@"title":@"手机号",
          @"subTitle":SharedUserInfo.phone ?:@"-"},
        @{@"title":@"身份证号",
          @"subTitle":SharedUserInfo.idCardNo ?:@"-"},
        @{@"title":@"真实姓名",
          @"subTitle":SharedUserInfo.name?:@"-"},
        @{@"title":@"我的推荐人",
          @"subTitle":SharedUserInfo.promoteId ?:@"-"},
        @{@"title":@"认证时间",
          @"subTitle":SharedUserInfo.certificationTime ?:@"-"},
        @{@"title":@"当前等级",
          @"subTitle":SharedUserInfo.level ?:@"-"},
        @{@"title":@"ID编号",
          @"subTitle":SharedUserInfo.agentId ?:@"-"},
        @{@"title":@"实名状态",
          @"subTitle":[SharedUserInfo.certification isEqualToString:@"0"]? @"未实名" :@"已实名"},
    /*@{@"title":@"提现手续费",
      @"subTitle":[NSString stringWithFormat:@"%@元/笔",SharedUserInfo.withdrawFee]}*/
    ];
    [self.mc_tableview reloadData];
}
//- (void)viewWillAppear:(BOOL)animated {
//    [super viewWillAppear:animated];
//    [self requestAliPhone];
//}
- (void)requestAliPhone {
    NSString *userId = SharedUserInfo.userid;
    NSDictionary *defaultCardDic = @{@"userId":userId, @"type":@"3", @"nature":@"0", @"isDefault":@"1"};
    __weak __typeof(self)weakSelf = self;
    [MCSessionManager.shareManager mc_POST:@"/user/app/bank/query/byuseridandtype/andnature" parameters:defaultCardDic ok:^(NSDictionary * _Nonnull resp) {
        NSArray *result = resp[@"result"];
        NSDictionary *dict = result.firstObject;
        NSString *cardNo = [NSString stringWithFormat:@"%@", dict[@"cardNo"]];
        
        NSString *first = [cardNo substringWithRange:NSMakeRange(0, 3)];
        NSString *last = [cardNo substringFromIndex:cardNo.length-4];
        
        weakSelf.aliPhone = [NSString stringWithFormat:@"%@ **** %@", first, last];
        [weakSelf.mc_tableview reloadData];
    }];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
//    if (section == self.dataArray.count - 1) {
//        return 10;
//    } else {
//        return 1;
//    }
//}
//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    if (section == self.dataArray.count - 1) {
//        UIView *head = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)];
//        head.backgroundColor = [UIColor groupTableViewBackgroundColor];
//        return head;
//    }
//    return nil;
//}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.textColor = UIColorGrayDarken;
        cell.detailTextLabel.textColor = UIColorGrayDarken;
    }
    cell.accessoryType = UITableViewCellAccessoryNone;
    NSString *tit = [self.dataArray[indexPath.section] objectForKey:@"title"];
    NSString *subTit = [self.dataArray[indexPath.section] objectForKey:@"subTitle"];
    cell.textLabel.text = tit;

    
    if (indexPath.section == 0) {
        UIImageView * imv = [[UIImageView alloc]initWithFrame:CGRectMake(KScreenWidth-70, 7, 30, 30)];
        [cell addSubview:imv];
        imv.layer.masksToBounds = YES;
        imv.layer.cornerRadius = 15;
        
        [imv sd_setImageWithURL:subTit placeholderImage:[UIImage mc_imageNamed:@"321"]];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }else{
        cell.detailTextLabel.text = subTit;
        if (indexPath.section == 1) {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }

    }
  
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        [self getImageFromIpc];
    }
    
    if (indexPath.section == 1) {
            QMUIAlertController *alert = [QMUIAlertController alertControllerWithTitle:@"" message:@"" preferredStyle:QMUIAlertControllerStyleAlert];
        UITextField * tf = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, 320, 60)];
        tf.borderStyle = UITextBorderStyleRoundedRect;
        tf.placeholder = @"请输入要修改的昵称";
        tf.text = @"" ;
        tf.font = [UIFont systemFontOfSize:15];
        [alert addCustomView:tf];
        __weak typeof(self) weakSelf = self;

            [alert addAction:[QMUIAlertAction actionWithTitle:@"取消" style:QMUIAlertActionStyleCancel handler:nil]];
            [alert addAction:[QMUIAlertAction actionWithTitle:@"确认" style:QMUIAlertActionStyleDestructive handler:^(__kindof QMUIAlertController * _Nonnull aAlertController, QMUIAlertAction * _Nonnull action) {
                if (tf.text.length == 0) {
                    [MCToast showMessage:@"请输入要修改的用户名"];
                    return;
                }
                self.nickname = tf.text;
                [self changeInfo];
            }]];
            [alert showWithAnimated:YES];
    }
//    if (indexPath.section == self.dataArray.count - 1) {
//        [MCVerifyStore verifyRealName:^(MCUserInfo * _Nonnull userinfo) {
//            [self.navigationController pushViewController:[MCBindALIViewController new] animated:YES];
//        }];
//
//    }
}
-(void)changeInfo{
    if (!self.headImg) {
        self.headImg = SharedUserInfo.headImg;
    }
    
    if (!self.nickname) {
        self.nickname = SharedUserInfo.nickname;
    }
    
    [MCSessionManager.shareManager mc_put:@"/api/v1/player/user/info" parameters:@{@"headImg":self.headImg,@"nickname":self.nickname} ok:^(NSDictionary * _Nonnull respDic) {
        [self reloadData];

    } other:^(NSDictionary * _Nonnull respDic) {
        
    } failure:^(NSError * _Nonnull error) {
        
    }];
}
- (void)reloadData {
    // 头部数据
    __weak typeof(self) weakSelf = self;
    [[MCModelStore shared] reloadUserInfo:^(MCUserInfo * _Nonnull userInfo) {
        SharedUserInfo = userInfo;
        [weakSelf refreshVC];
    }];
}
    

#pragma mark --- PRIVATE METHOD
#pragma mark --- 调用系统相册的方法
- (void)getImageFromIpc {
    
    // 1. 判断是否可以打开相册
//    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
//
//        return;
//    }
    // 2. 创建图片选择控制器
    UIImagePickerController *ipc = [[UIImagePickerController alloc] init];
    /**
     typedef NS_ENUM(NSInteger, UIImagePickerControllerSourceType) {
     UIImagePickerControllerSourceTypePhotoLibrary, // 相册
     UIImagePickerControllerSourceTypeCamera, // 用相机拍摄获取
     UIImagePickerControllerSourceTypeSavedPhotosAlbum // 相簿
     }
     */
    // 3. 设置打开照片相册类型(显示所有相薄)
    ipc.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    // 4. 设置代理
    ipc.delegate = self;
    // 5. modal出这个控制器
    [self presentViewController:ipc animated:YES completion:nil];
}
#pragma mark --- UIImagePickerControllerDelegate代理方法
// 1. 选择图片时调用
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    // 销毁控制器
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    [self requestDataForUploadImages:info[UIImagePickerControllerOriginalImage] fileName:@"headImg"];
}

// 2. 取消选择时调用
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}
//------ 上传图片 ------//
- (void)requestDataForUploadImages:(UIImage *)selectImg fileName:(NSString *)name{
    NSString *phone = SharedUserInfo.phone;
    NSDictionary *uploadDic = @{};
    NSArray *imagesArr = @[selectImg];
    __weak __typeof(self)weakSelf = self;
    [MCSessionManager.shareManager mc_UPLOAD:@"/api/v1/player/upload/App" parameters:uploadDic images:imagesArr remoteFields:nil imageNames:@[name] imageScale:0.0001 imageType:nil ok:^(NSDictionary * _Nonnull resp) {
        NSDictionary * dic = [NSDictionary dictionaryWithDictionary:resp];
        // 设置图片
        weakSelf.headImg = dic[@"fileUrl"];
        [weakSelf changeInfo];

    } other:nil failure:nil];
}
    
@end
