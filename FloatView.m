//
//  FloatView.m
//  SuspensionButton
//
//  Created by Jone on 15/9/7.
//  Copyright © 2015年 Jone. All rights reserved.
//

#import "FloatView.h"

#import "ExceptionInfovView.h"
typedef NS_ENUM (NSUInteger, LocationTag)
{
    kLocationTag_top = 1,
    kLocationTag_left,
    kLocationTag_bottom,
    kLocationTag_right
};

static const NSTimeInterval kAnimationDuration = 0.25f;
static FloatView *__floatView = nil;

@interface FloatView ()<ExceptionInfovViewDelegate>
{
    UIWindow        *_boardWindow;               //底部window
    UIView          *_boardView;                 //底部view
    UIImageView     *_floatImageView;            //漂浮的menu按钮
    UILabel *lab;
    
    UIWindow *window;
    
    NSMutableArray  *_buttonArray;               //展开的button数组
    NSArray         *_buttonImgArray;            //图片背景
    
    BOOL            _showMenu;                   //menu是否展开
    BOOL            _showAnimation;              //animation动画展示
    BOOL            _showKeyBoard;               //键盘是否展开
    LocationTag     _locationTag;                //menu贴在哪个方向
    
    CGRect          _moveWindowRect;             //移动后window.frame
    CGRect          _showKeyBoardWindowRect;     //键盘展开后的window.frame
    CGSize          _keyBoardSize;               //键盘的尺寸
    
    ExceptionInfovView *view ;
    
    NSArray *array;//小圆点显示的数字
}

@property(nonatomic)CGRect rect;

@end

@implementation FloatView
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    _buttonArray = nil;
    _buttonImgArray = nil;
    _boardWindow = nil;
    _boardView = nil;
    _floatImageView = nil;
}

- (id)init
{
    self = [super init];
    if (self) {
        if (self.imageArr) {
            _buttonImgArray = self.imageArr;
        }
        _showMenu = NO;
        _showAnimation = NO;
        _showKeyBoard = NO;
        _buttonArray = [[NSMutableArray alloc]init];
        _locationTag = kLocationTag_left;
        
        //初始化背景window
        _boardWindow = [[UIWindow alloc] initWithFrame:CGRectMake(0, 0, 60, 60)];
        _boardWindow.backgroundColor = [UIColor clearColor];
        _boardWindow.windowLevel = 3000;
        _boardWindow.layer.cornerRadius=30;
        //        _boardWindow.clipsToBounds = YES;
        [_boardWindow makeKeyAndVisible];
        
        
        //初始化背景view
        _boardView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 60, 60)];
        _boardView.backgroundColor = [UIColor clearColor];
        [_boardWindow addSubview:_boardView];
        
        //初始化漂浮menu
        _floatImageView = [[UIImageView alloc]init];
        [self setImgaeNameWithMove:NO];
        [_floatImageView setUserInteractionEnabled:YES];
        [_floatImageView setFrame:CGRectMake(0, 0, 60, 60)];
        [_boardView addSubview:_floatImageView];
        
//        NSArray *arr =[[IDDatabaseService shareDatabaseServer] uploadexcepInfocount];
        lab =[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
        lab.layer.cornerRadius=10;
        lab.center=CGPointMake(_boardWindow.center.x-20, _boardWindow.center.y-20);
        lab.clipsToBounds=YES;
        lab.font=[UIFont systemFontOfSize:10];
        lab.backgroundColor=[UIColor redColor];
        lab.textAlignment=NSTextAlignmentCenter;
//        lab.text=[NSString stringWithFormat:@"%ld",(unsigned long)arr.count];
        [_boardView addSubview:lab];
        [lab bringSubviewToFront:_boardView];
        
        //手势
        UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panImgV:)];
        [_floatImageView addGestureRecognizer:panGestureRecognizer];
        
        UITapGestureRecognizer * tapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapImgV:)];
        [_floatImageView addGestureRecognizer:tapGestureRecognizer];
        
        window =[[UIWindow alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT-20)];
        window.windowLevel=4000;
        [window makeKeyAndVisible];
        CGRect frame =CGRectMake(0, 0, window.frame.size.width, window.frame.size.height);
        view =[[ExceptionInfovView alloc]initWithFrame:frame];
        view.delegate=self;
//        view.arrCount=arr.count;
        [window addSubview:view];
        
    }
    return self;
}

+ (FloatView *)defaultFloatView{
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        __floatView = [[FloatView alloc] init];
    });
    return __floatView;
}

#pragma mark - GestureRecognizer
#pragma mark UIPanGestureRecognizer
- (void)panImgV:(UIPanGestureRecognizer*)panGestureRecognizer
{
    //判断是否展开
    if (_showMenu) {
        return;
    }
    UIView * moveView = panGestureRecognizer.view.superview.superview;
    [UIView animateWithDuration:kAnimationDuration animations:^{
        if (panGestureRecognizer.state == UIGestureRecognizerStateBegan || panGestureRecognizer.state == UIGestureRecognizerStateChanged) {
            CGPoint translation = [panGestureRecognizer translationInView:moveView.superview];
            [moveView setCenter:(CGPoint){moveView.center.x + translation.x, moveView.center.y + translation.y}];
            [panGestureRecognizer setTranslation:CGPointZero inView:moveView.superview];
            [self setImgaeNameWithMove:YES];
        }
        if (panGestureRecognizer.state == UIGestureRecognizerStateEnded) {
            if (_boardWindow.frame.origin.y + _boardWindow.frame.size.height > windowHight - _keyBoardSize.height) {
                if (_showKeyBoard) {
                    if (moveView.frame.origin.x < 0) {
                        [moveView setCenter:(CGPoint){moveView.frame.size.width/2,windowHight - _keyBoardSize.height - _boardWindow.frame.size.height/2}];
                    }else if (moveView.frame.origin.x + moveView.frame.size.width > windowWidth)
                    {
                        [moveView setCenter:(CGPoint){windowWidth - moveView.frame.size.width/2,windowHight - _keyBoardSize.height - _boardWindow.frame.size.height/2}];
                    }else
                    {
                        [moveView setCenter:(CGPoint){moveView.center.x,windowHight - _keyBoardSize.height - _boardWindow.frame.size.height/2}];
                    }
                    _showKeyBoardWindowRect = CGRectMake(_boardWindow.frame.origin.x, windowHight - moveView.frame.size.height, 60, 60);
                    _locationTag = kLocationTag_bottom;
                }else
                {
                    [self moveEndWithMoveView:moveView];
                    _showKeyBoardWindowRect = _boardWindow.frame;
                }
            }else
            {
                [self moveEndWithMoveView:moveView];
                _showKeyBoardWindowRect = _boardWindow.frame;
            }
            [self setImgaeNameWithMove:NO];
        }
    }];
}

- (void)moveEndWithMoveView:(UIView*)moveView
{
    if (moveView.frame.origin.y <= 40) {
        if (moveView.frame.origin.x < 0) {
            [moveView setCenter:(CGPoint){moveView.frame.size.width/2,moveView.frame.size.height/2}];
            _locationTag = kLocationTag_left;
        }else if (moveView.frame.origin.x + moveView.frame.size.width > windowWidth) {
            [moveView setCenter:(CGPoint){windowWidth - moveView.frame.size.width/2,moveView.frame.size.height/2}];
            _locationTag = kLocationTag_right;
        }else
        {
            [moveView setCenter:(CGPoint){moveView.center.x,moveView.frame.size.height/2}];
            _locationTag = kLocationTag_top;
        }
    }else if (moveView.frame.origin.y + moveView.frame.size.height >= windowHight - 40)
    {
        if (moveView.frame.origin.x < 0) {
            [moveView setCenter:(CGPoint){moveView.frame.size.width/2,windowHight - moveView.frame.size.height/2}];
            _locationTag = kLocationTag_left;
        }else if (moveView.frame.origin.x + moveView.frame.size.width > windowWidth) {
            [moveView setCenter:(CGPoint){windowWidth - moveView.frame.size.width/2,windowHight - moveView.frame.size.height/2}];
            _locationTag = kLocationTag_right;
        }else
        {
            [moveView setCenter:(CGPoint){moveView.center.x,windowHight - moveView.frame.size.height/2}];
            _locationTag = kLocationTag_bottom;
        }
    }else
    {
        if (moveView.frame.origin.x + moveView.frame.size.width/2 < windowWidth/2) {
            if (moveView.frame.origin.x !=0) {
                [moveView setCenter:(CGPoint){moveView.frame.size.width/2,moveView.center.y}];
            }
            _locationTag = kLocationTag_left;
        }else
        {
            if (moveView.frame.origin.x + moveView.frame.size.width != windowWidth) {
                [moveView setCenter:(CGPoint){windowWidth - moveView.frame.size.width/2,moveView.center.y}];
            }
            _locationTag = kLocationTag_right;
        }
    }
}

#pragma mark UITapGestureRecognizer
- (void)tapImgV:(UITapGestureRecognizer*)tapGestureRecognizer
{
    
    //    IDShowExceptionInfo *viewCtrl = [[IDShowExceptionInfo alloc]init];
    //    UIWindow *mainWindow = [[[UIApplication sharedApplication] delegate] window];
    //    UINavigationController *rootViewCtl = (UINavigationController*)mainWindow.rootViewController;
    //    [rootViewCtl pushViewController:viewCtrl animated:TRUE];
    //        [self hiddenSuspension];
    //    _boardWindow.hidden=YES;
    
    _boardView.hidden=YES;
    window.hidden=NO;
    [UIView animateWithDuration:0.5 animations:^{
        window.frame =CGRectMake(0, SCREEN_Y, SCREEN_WIDTH, SCREEN_HEIGHT);
    }];
    
    
    NSLog(@"&&&&__-------------ture----------%@",window);
    
    
}
-(void)hiddenSuspension{
    _boardView.hidden=YES;
}
-(void)showSuspension{
    _boardView.hidden=NO;
}

-(void)comeBack{
    //    [view removeFromSuperview];
    _boardView.hidden=NO;
    [UIView animateWithDuration:0.5 animations:^{
        window.frame=CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT);
    } completion:^(BOOL finished) {
        if (finished) {
            window.hidden=YES;
        }
    }];
}




#pragma mark - 移动和停止menu图片
- (void)setImgaeNameWithMove:(BOOL)isMove
{
    if (isMove) {
        [_floatImageView setImage:[UIImage imageNamed:@"btn_home_move"]];
    }else
    {
        [_floatImageView setImage:[UIImage imageNamed:@"btn_home_move"]];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
