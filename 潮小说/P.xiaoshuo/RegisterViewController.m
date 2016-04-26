//
//  RegisterViewController.m
//  P.xiaoshuo
//
//  Created by 王开政 on 16/2/29.
//  Copyright (c) 2016年 Wang. All rights reserved.
//

#import "RegisterViewController.h"
#import "ASIFormDataRequest.h"
@interface RegisterViewController ()<UITextFieldDelegate>

@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"注册界面背景.jpg"]];
    self.RegName.delegate =self;
    self.RegPwd.delegate = self;
    self.RegRepeatPwd.delegate =self;
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.RegName resignFirstResponder];
    [self.RegPwd resignFirstResponder];
    [self.RegRepeatPwd resignFirstResponder];
}
//设置编辑开始
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    return YES;
}
//编辑开始时调用
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    
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
    dateBase *date = [[dateBase alloc]init];
    if (textField == self.RegName)
    {
        if (self.RegName.text.length == 0)
        {
            UIAlertView *view = [[UIAlertView alloc]initWithTitle:@"提示" message:@"用户名不能为空" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
            [view show];
        }
        else
     {
        NSMutableArray *array = [date getMassage:@"person"];
        for (int i = 0; i < array.count; i ++)
        {
            if ([self.RegName.text isEqualToString:[[array objectAtIndex:i] name]])
            {
                UIAlertView * view = [[UIAlertView alloc]initWithTitle:@"提示" message:@"用户名已存在" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
                [ view show];

            }
        }
     }
    }
    else if (textField == self.RegPwd)
    {
        if (self.RegPwd.text.length < 8)
        {
            UIAlertView * view = [[UIAlertView alloc]initWithTitle:@"提示" message:@"密码太短" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
            [ view show];

        }
    }
    else if (textField == self.RegRepeatPwd)
    {
        if (![self.RegPwd.text isEqualToString:self.RegRepeatPwd.text])
        {
            UIAlertView * view = [[UIAlertView alloc]initWithTitle:@"提示" message:@"密码不一致" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
            [ view show];

        }
    }
    
    
        NSTimeInterval animationDuration = 0.30f;
        [UIView beginAnimations:@ "ResizeForKeyboard"  context:nil];
        [UIView setAnimationDuration:animationDuration];
        
        //恢复屏幕
        self.view.frame = CGRectMake(0.0f, 0.0f, self.view.frame.size.width, self.view.frame.size.height); //64-216
        
        [UIView commitAnimations];
    
    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)RegSaveAC:(id)sender
{
    if (self.RegName.text.length == 0 ||self.RegPwd.text.length ==0 ||self.RegRepeatPwd.text.length == 0)
    {
        UIAlertView * view = [[UIAlertView alloc]initWithTitle:@"提示" message:@"用户名或密码不能为空" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
        [ view show];
    }
    else if (self.RegPwd.text.length < 8 || self.RegRepeatPwd.text.length < 8)
    {
        UIAlertView * view = [[UIAlertView alloc]initWithTitle:@"提示" message:@"密码太短" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
        [ view show];
       
    }
    else
    {
        NSString *dataStr = [NSString stringWithFormat:@"http://localhost/insert.php?number=%@&pwd=%d&photo=photo",self.RegName.text,self.RegPwd.text.intValue];
        NSURL *url = [NSURL URLWithString:dataStr];
        ASIFormDataRequest *request = [[ASIFormDataRequest alloc]initWithURL:url];
      
        
        [request setRequestMethod:@"GET"];
        [request setDelegate:self];
        [request startSynchronous];
     dateBase *date = [[dateBase alloc]init];
    [date insertInformation:@"person" andName:self.RegName.text andPwd:self.RegPwd.text withPhotoName:@"photo"];
    
    
    [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (IBAction)RegBackAc:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
