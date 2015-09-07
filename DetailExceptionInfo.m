//
//  DetailExceptionInfo.m
//  SuspensionButton
//
//  Created by Jone on 15/9/7.
//  Copyright © 2015年 Jone. All rights reserved.
//

#import "DetailExceptionInfo.h"
static DetailExceptionInfo *detail;

@interface DetailExceptionInfo ()<UITableViewDataSource,UITableViewDelegate>{
    UITableView *table;
}

@end
@implementation DetailExceptionInfo

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
@synthesize delegate,infoDic;
+(instancetype)shareDetailView{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        detail=[[DetailExceptionInfo alloc]init];
    });
    return detail;
}
-(id)init{
    if (self=[super init]) {
        
        
        UIView *view =[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
        view.backgroundColor=[UIColor whiteColor];
        [self addSubview:view];
        
        UIButton *backBtn =[UIButton buttonWithType:UIButtonTypeCustom];
        backBtn.frame=CGRectMake(0, 0, view.frame.size.width-220, view.frame.size.height);
        [backBtn setTitle:@"Exception" forState:UIControlStateNormal];
        [backBtn addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
        backBtn.titleLabel.font=[UIFont systemFontOfSize:14];
        backBtn.titleLabel.textAlignment=NSTextAlignmentLeft;
        [backBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [view addSubview:backBtn];
        
        UILabel *titleLabel =[[UILabel alloc]initWithFrame:CGRectMake(backBtn.frame.size.width, 0, 120, backBtn.frame.size.height)];
        titleLabel.text=@"DetailInfo";
        titleLabel.textAlignment=NSTextAlignmentCenter;
        titleLabel.textColor=[UIColor blackColor];
        [view addSubview:titleLabel];
        
        table =[[UITableView alloc]initWithFrame:CGRectMake(0, view.frame.origin.y+40, SCREEN_WIDTH, SCREEN_HEIGHT-40-20) style:UITableViewStylePlain];
        table.delegate=self;
        table.dataSource=self;
        [self addSubview:table];
        
    }
    return self;
}

#pragma mark------UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 7;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        if (indexPath.row==0) {
            UILabel *lab=[[UILabel alloc]initWithFrame:CGRectMake(0, 5, 70, 50)];
            lab.font=[UIFont systemFontOfSize:15];
            lab.tag=100;
            [cell addSubview:lab];
            
            UITextView *textView =[[UITextView alloc]initWithFrame:CGRectMake(lab.frame.size.width, lab.frame.origin.y, 320-lab.frame.size.width, lab.frame.size.height)];
            textView.tag=108;
            textView.editable=NO;
            textView.font=[UIFont systemFontOfSize:15];
            [cell addSubview:textView];
        }
        if (indexPath.row==1) {
            UILabel *lab=[[UILabel alloc]initWithFrame:CGRectMake(0, 5, 320, 50)];
            lab.font=[UIFont systemFontOfSize:15];
            lab.tag=101;
            [cell addSubview:lab];
        }
        if (indexPath.row==2) {
            UILabel *lab=[[UILabel alloc]initWithFrame:CGRectMake(0, 5, 320, 50)];
            lab.font=[UIFont systemFontOfSize:15];
            lab.tag=102;
            [cell addSubview:lab];
        }
        if (indexPath.row==3) {
            UILabel *lab=[[UILabel alloc]initWithFrame:CGRectMake(0, 5, 320, 50)];
            lab.font=[UIFont systemFontOfSize:15];
            lab.tag=103;
            [cell addSubview:lab];
        }
        if (indexPath.row==4) {
            UILabel *lab=[[UILabel alloc]initWithFrame:CGRectMake(0, 5, 50, 50)];
            lab.font=[UIFont systemFontOfSize:15];
            lab.tag=104;
            [cell addSubview:lab];
            
            UITextView *textView =[[UITextView alloc]initWithFrame:CGRectMake(lab.frame.size.width,  lab.frame.origin.y, 320-lab.frame.size.width, 50)];
            textView.editable=NO;
            textView.tag=105;
            textView.font=[UIFont systemFontOfSize:15];
            [cell addSubview:textView];
        }
        if (indexPath.row==5) {
            UILabel *lab=[[UILabel alloc]initWithFrame:CGRectMake(0, 5, 60, 50)];
            lab.font=[UIFont systemFontOfSize:15];
            lab.tag=106;
            [cell addSubview:lab];
            
            UITextView *textView =[[UITextView alloc]initWithFrame:CGRectMake(lab.frame.size.width, lab.frame.origin.y, 320-lab.frame.size.width, lab.frame.size.height)];
            textView.tag=109;
            textView.editable=NO;
            textView.font=[UIFont systemFontOfSize:15];
            [cell addSubview:textView];
        }
        if (indexPath.row==6) {
            UILabel *lab=[[UILabel alloc]initWithFrame:CGRectMake(0, 5, 70, 50)];
            lab.font=[UIFont systemFontOfSize:15];
            lab.tag=107;
            [cell addSubview:lab];
            
            UITextView *textView =[[UITextView alloc]initWithFrame:CGRectMake(lab.frame.size.width, lab.frame.origin.y, 320-lab.frame.size.width, lab.frame.size.height)];
            textView.tag=110;
            textView.editable=NO;
            textView.font=[UIFont systemFontOfSize:15];
            [cell addSubview:textView];
        }
        
    }
    
    
    if (indexPath.row==0) {
        UILabel *deviceIdLab=(UILabel *)[cell viewWithTag:100];
        deviceIdLab.text=[NSString stringWithFormat:@"deviceid:"];
        
        UITextView *deviceView =(UITextView *)[cell viewWithTag:108];
        deviceView.text=[NSString stringWithFormat:@"%@",self.infoDic[@"deviceId"]];
    }
    if (indexPath.row==1) {
        UILabel *timeLab =(UILabel *)[cell viewWithTag:101];
        timeLab.text=[NSString stringWithFormat:@"time:  %@",self.infoDic[@"timetag"]];
    }
    if (indexPath.row==2) {
        UILabel *countLab =(UILabel *)[cell viewWithTag:102];
        countLab.text =[NSString stringWithFormat:@"count:  %@",self.infoDic[@"count"]];
    }
    if (indexPath.row==3) {
        UILabel *codeLab =(UILabel *)[cell viewWithTag:103];
        codeLab.text=[NSString stringWithFormat:@"code:  %@",self.infoDic[@"code"]];
        
    }
    if (indexPath.row==4) {
        UILabel *objectLab =(UILabel *)[cell viewWithTag:104];
        UITextView *objectTextView =(UITextView *)[cell viewWithTag:105];
        
        objectLab.text=@"object: ";
        objectTextView.text=[NSString stringWithFormat:@"%@",self.infoDic[@"object"]];
    }
    if (indexPath.row==5) {
        UILabel *detailLab =(UILabel *)[cell viewWithTag:106];
        detailLab.text=[NSString stringWithFormat:@"detail:"];
        
        UITextView *deviceView =(UITextView *)[cell viewWithTag:109];
        deviceView.text=[NSString stringWithFormat:@"%@",self.infoDic[@"detail"]];
    }
    if (indexPath.row==6) {
        UILabel *callStackLab =(UILabel *)[cell viewWithTag:107];
        callStackLab.text=[NSString stringWithFormat:@"callStack:"];
        
        UITextView *deviceView =(UITextView *)[cell viewWithTag:110];
        deviceView.text=[NSString stringWithFormat:@"%@",self.infoDic[@"callStack"]];
    }
    
    return cell;
}

#pragma mark------UITableViewDelegate
-(void)tableView:(nonnull UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    [table deselectRowAtIndexPath:indexPath animated:YES];
}
-(CGFloat)tableView:(nonnull UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    return 70;
}
#pragma mark-------buttonClick
-(void)buttonClick{
    if ([delegate respondsToSelector:@selector(comeBackToException)]) {
        [delegate comeBackToException];
    }
}

@end
