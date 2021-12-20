//
//  MCNewsCell.m
//  MCOEM
//
//  Created by wza on 2020/5/11.
//  Copyright © 2020 MingChe. All rights reserved.
//

#import "MCNewsCell.h"
#import "MCDateStore.h"
#import "MCGradeName.h"

@interface MCNewsCell ()

@property (weak, nonatomic) IBOutlet UILabel *titLab;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;
@property (weak, nonatomic) IBOutlet UILabel *readNumLab;
@property (weak, nonatomic) IBOutlet UIImageView *imgView;

@property (weak, nonatomic) IBOutlet QMUILabel *limitLab;

@end

@implementation MCNewsCell

+ (instancetype)cellWithTableview:(UITableView *)tableview newsModel:(MCNewsModel *)model {
    static NSString *cellID = @"MCNewsCell";
    MCNewsCell *cell = [tableview dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        [tableview registerNib:[UINib nibWithNibName:cellID bundle:[NSBundle OEMSDKBundle]] forCellReuseIdentifier:cellID];
        cell = [tableview dequeueReusableCellWithIdentifier:cellID];
    }
    [cell.imgView sd_setImageWithURL:[NSURL URLWithString:model.logo] placeholderImage:[MCImageStore placeholderImageWithSize:CGSizeMake(50, 50)]];
    cell.titLab.text = model.name;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if ([model.createTime hasSuffix:@"000"]) {
        cell.timeLab.text = [MCDateStore compareCurrentTime:model.createTime];
    } else {
        cell.timeLab.text = model.createTime;
    }
    

    cell.readNumLab.text = [NSString stringWithFormat:@"阅读：%@",@"-"];
    
    
//    if ([model.background isEqualToString:@"Blue"]) {
//        cell.bgView.backgroundColor = [UIColor blueColor];
//    }else{
//        cell.bgView.backgroundColor = [UIColor redColor];
//
//    }
    return cell;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.imageView.layer.cornerRadius = 25;
//    self.limitLab.backgroundColor = MAINCOLOR;
//    self.limitLab.textColor = UIColor.whiteColor;
    
//    self.limitLab.contentEdgeInsets = UIEdgeInsetsMake(3, 5, 3, 5);
//    self.limitLab.layer.cornerRadius = 2.f;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
//    self.imgView.layer.cornerRadius = 4.f;
    
}

@end
