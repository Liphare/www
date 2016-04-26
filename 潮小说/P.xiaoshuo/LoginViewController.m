//
//  LoginViewController.m
//  P.xiaoshuo
//
//  Created by 王开政 on 16/2/29.
//  Copyright (c) 2016年 Wang. All rights reserved.
//

#import "LoginViewController.h"
#import <sqlite3.h>
#import "dateBase.h"
#import "Informaton.h"
#import "RegisterViewController.h"
#import "HomeViewController.h"
#import "BookCollectionViewController.h"
#import "PersonViewController.h"
#import "AppDelegate.h"
#import "Reachability.h"
@interface LoginViewController ()<UITextFieldDelegate>

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    AppDelegate *del = (AppDelegate *)[[UIApplication sharedApplication ]delegate];
    self.nameLable.delegate = self;
    self.pwdLable.delegate =self;
    self.verificationLable.delegate = self;
    dateBase *date = [[dateBase alloc]init];
    [date createDB]; //调用方法建数据库
    [date createTable:@"person"];//调用方法建表
    [date createTable:@"Massage"];
    Reachability *r = [Reachability reachabilityWithHostName:@"www.baidu.com"];
    if ([r currentReachabilityStatus] == NotReachable)
    {
        del.networkSign = NO;
    }
        // Do any additional setup after loading the view from its nib.
}
//界面消失时保存用户名和密码，便于传值
-(void)viewDidDisappear:(BOOL)animated
{
    
    AppDelegate *del = (AppDelegate *)[[UIApplication sharedApplication ]delegate];
    del.name = self.nameLable.text;
    del.pwd = self.pwdLable.text;
    
    
    
    
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
//设置编辑开始
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    return YES;
}
//编辑开始时调用
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self.nameLable canBecomeFirstResponder];
    NSTimeInterval animationDuration = 0.3;
    [UIView beginAnimations:@ "ResizeForKeyboard"  context:nil];
    [UIView setAnimationDuration:animationDuration];
    
    //将视图的Y坐标向上移动，以使下面腾出地方用于软键盘的显示
    self.view.frame = CGRectMake(0, -100, self.view.frame.size.width, self.view.frame.size.height); //64-216
    
    [UIView commitAnimations];
}
//设置编辑结束
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    return YES;
}
//编辑结束时调用
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@ "ResizeForKeyboard"  context:nil];
    [UIView setAnimationDuration:animationDuration];
    
    //恢复屏幕
    self.view.frame = CGRectMake(0.0f, 0.0f, self.view.frame.size.width, self.view.frame.size.height); //64-216
    
    [UIView commitAnimations];
}      
//点击空白处隐藏键盘
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.nameLable resignFirstResponder];
    [self.pwdLable resignFirstResponder];
    [self.verificationLable resignFirstResponder];
  
}
//获取验证码
- (IBAction)verifitionPhotoAction:(id)sender

{
    NSMutableArray *arr = [[NSMutableArray alloc]init];
   
    for (int i = 0; i < 10; i ++)
    {
        [arr addObject:[NSString stringWithFormat:@"%d",i]];
    }
    for (char i = 'a'; i <='z'; i ++)
    {
        [arr addObject:[NSString stringWithFormat:@"%c",i]];
        
    }
    for (char i = 'A'; i <= 'Z'; i ++)
    {
        [arr addObject:[NSString stringWithFormat:@"%c",i]];
    }
    NSMutableArray *array = [[NSMutableArray alloc]init];
    for (int i = 0; i < 4; i ++)
    {
        int n = arc4random()%62;
        
        
        [array addObject:[arr objectAtIndex:n]];
        self.verifition = [array componentsJoinedByString:@""];//不区分大小写
    }
    [self.verifitionPhoto setTitle:self.verifition forState:UIControlStateNormal];

    
}
//登陆按钮的实现
- (IBAction)loginAction:(id)sender

{
    AppDelegate *del = (AppDelegate *)[[UIApplication sharedApplication ]delegate];
    dateBase *date = [[dateBase alloc]init];
    NSMutableArray *array = [[NSMutableArray alloc]init];
    array = [date getMassage:@"person"];
    int i = 0;
    for (int i = 0; i < array.count; i ++)
    {
        NSString *str = [[array objectAtIndex:i] name];
        if ([str isEqualToString:self.nameLable.text])
        {
            if ([self.pwdLable.text isEqualToString:[[array objectAtIndex:i] pwd]]&&
                [self.verificationLable.text caseInsensitiveCompare: self.verifition] == NSOrderedSame)//不区别大小写比较
            {
                del.photo = [[array objectAtIndex:i] photo];
                [self presentViewController:[self put] animated:YES completion:nil];
                return;
            }
            
            else
            {
                UIAlertView * view = [[UIAlertView alloc]initWithTitle:@"提示" message:@"密码或验证码错误" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
                [ view show];
            }
           
            
        }
        if (i ==array.count)
        {
            
            UIAlertView * view = [[UIAlertView alloc]initWithTitle:@"提示" message:@"用户名不存在" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
            [ view show];
            
            
        }
        }
    
    }
//封装推出界面的方法
-(UITabBarController *)put
{
    AppDelegate *del = (AppDelegate *)[[UIApplication sharedApplication ]delegate];
    HomeViewController *homeView = [[HomeViewController alloc]initWithNibName:@"HomeViewController" bundle:nil];
    UINavigationController *nav1 = [[UINavigationController alloc]initWithRootViewController:homeView];
    [nav1 setNavigationBarHidden:YES];
    nav1.tabBarItem.image = [UIImage imageNamed:@"首页"];
   BookCollectionViewController *bookView = [[BookCollectionViewController alloc]initWithNibName:@"BookCollectionViewController" bundle:nil];
    UINavigationController *nav2 = [[UINavigationController alloc]initWithRootViewController:bookView];
    nav2.tabBarItem.image = [UIImage imageNamed:@"书架"];
    [nav2 setNavigationBarHidden:YES];//隐藏导航栏
    PersonViewController *presonView = [[PersonViewController alloc]initWithNibName:@"PersonViewController" bundle:nil];
    UINavigationController *nav3 = [[UINavigationController alloc]initWithRootViewController:presonView];
    nav3.tabBarItem.image = [UIImage imageNamed:@"个人中心"];
    [nav3 setNavigationBarHidden:YES];//隐藏导航栏
    NSArray *array = [[NSArray alloc]initWithObjects:nav1,nav2,nav3, nil];
    del.barControl = [[UITabBarController alloc]init];
    del.barControl.viewControllers = array;
    return del.barControl;
}
//注册按钮的实现
- (IBAction)registerAction:(id)sender
{
    RegisterViewController *viewControl = [[RegisterViewController alloc]initWithNibName:@"RegisterViewController" bundle:nil];
    [self presentViewController:viewControl animated:YES completion:nil];
    
    
}
@end
