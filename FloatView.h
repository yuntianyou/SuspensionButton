//
//  FloatView.h
//  SuspensionButton
//
//  Created by Jone on 15/9/7.
//  Copyright © 2015年 Jone. All rights reserved.
//

#import <UIKit/UIKit.h>
#define  windowWidth ([UIScreen mainScreen].bounds.size.width)
#define  windowHight ([UIScreen mainScreen].bounds.size.height)
#define SCREEN_Y 20
@interface FloatView : UIView
@property (nonatomic,strong) NSArray *imageArr;
+ (FloatView *)defaultFloatView;
-(void)hiddenSuspension;
-(void)showSuspension;
@end
