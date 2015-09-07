//
//  DetailExceptionInfo.h
//  SuspensionButton
//
//  Created by Jone on 15/9/7.
//  Copyright © 2015年 Jone. All rights reserved.
//

#import <UIKit/UIKit.h>
#define  SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define  SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)
#define SCREEN_Y 20

@protocol DetailExceptionInfoDelegate  <NSObject>

@optional
-(void)comeBackToException;

@end
@interface DetailExceptionInfo : UIView{
    id<DetailExceptionInfoDelegate>delegate;
}
@property(nonatomic)id<DetailExceptionInfoDelegate>delegate;
@property(nonatomic,retain)NSDictionary *infoDic;
+(instancetype)shareDetailView;


@end
