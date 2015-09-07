//
//  ExceptionInfovView.m
//  SuspensionButton
//
//  Created by Jone on 15/9/7.
//  Copyright © 2015年 Jone. All rights reserved.
//

#import "ExceptionInfovView.h"
#import "DetailExceptionInfo.h"
@interface ExceptionInfovView ()<DetailExceptionInfoDelegate>{
    UITableView *table;
    
    NSArray *infoArray;
}

@end

@implementation ExceptionInfovView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
@synthesize delegate,arrCount;
-(id)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]) {
        
//        infoArray=[[IDDatabaseService shareDatabaseServer]uploadexcepInfocount];
        
        UIView *view =[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
        view.backgroundColor=[UIColor whiteColor];
        [self addSubview:view];
        
        UIButton *backBtn =[UIButton buttonWithType:UIButtonTypeCustom];
        backBtn.frame=CGRectMake(0, 0, view.frame.size.width-220, view.frame.size.height);
        [backBtn setTitle:@"Menu" forState:UIControlStateNormal];
        [backBtn addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
        backBtn.titleLabel.font=[UIFont systemFontOfSize:14];
        backBtn.titleLabel.textAlignment=NSTextAlignmentLeft;
        [backBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [view addSubview:backBtn];
        
        UILabel *titleLabel =[[UILabel alloc]initWithFrame:CGRectMake(backBtn.frame.size.width, 0, 120, backBtn.frame.size.height)];
        titleLabel.text=@"Exception";
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
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [infoArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        
        UILabel *timeLab =[[UILabel alloc]initWithFrame:CGRectMake(0, 0,270, 40)];
        timeLab.tag=100;
        timeLab.font=[UIFont systemFontOfSize:9];
        [cell addSubview:timeLab];
        
        UILabel *countLab =[[UILabel alloc]initWithFrame:CGRectMake(0, timeLab.bounds.size.height, 100, 40)];
        countLab.tag=101;
        countLab.font=[UIFont systemFontOfSize:9];
        [cell addSubview:countLab];
        
        UILabel *objectLab =[[UILabel alloc]initWithFrame:CGRectMake(0, countLab.bounds.size.height+timeLab.bounds.size.height, 50, 40)];
        objectLab.tag=102;
        objectLab.font=[UIFont systemFontOfSize:9];
        [cell addSubview:objectLab];
        
        UITextView *objectView =[[UITextView alloc]initWithFrame:CGRectMake(objectLab.frame.size.width, objectLab.frame.origin.y, cell.frame.size.width-objectLab.frame.size.width-10, 40)];
        objectView.editable=NO;
        objectView.tag=103;
        objectView.font=[UIFont systemFontOfSize:9];
        [cell addSubview:objectView];
        
    }
    
    UILabel *timeLab =(UILabel *)[cell viewWithTag:100];
    UILabel *countLab =(UILabel *)[cell viewWithTag:101];
    UILabel *objectLab=(UILabel *)[cell viewWithTag:102];
    UITextView *objcView =(UITextView *)[cell viewWithTag:103];
    
    NSDictionary *item = [infoArray objectAtIndex:indexPath.row];
    
    NSString *timelab = [NSString stringWithFormat:@"%@",item[@"timetag"]];
    long timeInterval =(long)[timelab longLongValue];
    NSDate *detaildate = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    NSString *time = [NSString stringWithFormat:@"时间:%@",detaildate];
    timeLab.text = time;
    
    NSString *countlab = [NSString stringWithFormat:@"次数:%@",item[@"count"]];
    countLab.text = countlab;
    
    NSString *objectlab = [NSString stringWithFormat:@"对象:"];
    objectLab.text = objectlab;
    
    NSString *objectss = [NSString stringWithFormat:@"%@",item[@"object"]];
    objcView.text = objectss;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 125;
}
#pragma mark-----UITableViewDelegate
-(void)tableView:(nonnull UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    [table deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *item = [infoArray objectAtIndex:indexPath.row];
    UIWindow *window =(UIWindow *)[self superview];
    
    DetailExceptionInfo *detaileView =[DetailExceptionInfo shareDetailView];
    detaileView.hidden=NO;
    detaileView.frame=CGRectMake(0, SCREEN_HEIGHT , window.frame.size.width, window.frame.size.height);
    detaileView.infoDic=item;
    detaileView.delegate=self;
    detaileView.tag=10000;
    [window addSubview:detaileView];
    
    
    [UIView animateWithDuration:0.5 animations:^{
        detaileView.frame=CGRectMake(0,0, window.frame.size.width, window.frame.size.height);
    } completion:^(BOOL finished) {
        if (finished) {
            self.hidden=YES;
        }
    }];
    
}
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView;
{
    return NO;
}
#pragma mark-----buttonClick
-(void)buttonClick{
    if ([delegate respondsToSelector:@selector(comeBack)]) {
        [delegate comeBack];
    }
}

-(void)comeBackToException{
    self.hidden=NO;
    UIWindow *window =(UIWindow *)[self superview];
    DetailExceptionInfo *detailView =(DetailExceptionInfo *)[window viewWithTag:10000];
    [UIView animateWithDuration:0.5 animations:^{
        detailView.frame=CGRectMake(0, SCREEN_HEIGHT, window.bounds.size.width, window.bounds.size.height);
    } completion:^(BOOL finished) {
        if (finished) {
            detailView.hidden=YES;
        }
    }];
    
}


@end
