//
//  ExceptionInfovView.h
//  SuspensionButton
//
//  Created by Jone on 15/9/7.
//  Copyright © 2015年 Jone. All rights reserved.
//

#import <UIKit/UIKit.h>
#define  SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define  SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)
#define SCREEN_Y 20

@protocol ExceptionInfovViewDelegate <NSObject>
@optional
-(void)comeBack;
@end

@interface ExceptionInfovView : UIView<UITableViewDataSource,UITableViewDelegate>{
    id<ExceptionInfovViewDelegate>delegate;
}
@property(nonatomic)id<ExceptionInfovViewDelegate>delegate;
@property(nonatomic)NSInteger arrCount;
-(id)initWithFrame:(CGRect)frame;


@end
