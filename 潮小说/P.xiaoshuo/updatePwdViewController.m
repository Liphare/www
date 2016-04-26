//
//  updatePwdViewController.m
//  P.xiaoshuo
//
//  Created by 王开政 on 16/3/2.
//  Copyright (c) 2016年 Wang. All rights reserved.
//

#import "updatePwdViewController.h"
#import "AppDelegate.h"
#import "dateBase.h"
@interface updatePwdViewController ()<UITextFieldDelegate>

@end

@implementation updatePwdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"修改密码界面背景.jpg"]];
    self.oldPwd.delegate = self;
    self.newpwd.delegate = self;
    self.repeatPwd.delegate = self;
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.oldPwd resignFirstResponder];
    [self.newpwd resignFirstResponder];
    [self.repeatPwd resignFirstResponder];
}
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    return YES;
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    AppDelegate *del = (AppDelegate *)[[UIApplication sharedApplication ]delegate];
    if (textField == self.oldPwd)
    {
        if ([self.oldPwd.text isEqualToString: del.pwd])
        {
            self.lable1.alpha = 0;
        }
        else
        {
            self.lable1.alpha = 1;
        }
    }
    else if (textField == self.newpwd)
    {
        if (self.newpwd.text.length >= 8)
        {
            self.lable2.alpha = 0;
        }
        else
        {
            self.lable2.alpha = 1;
        }
    }
    else if (textField ==self.repeatPwd)
    {
        if ([self.repeatPwd.text isEqualToString:self.newpwd.text])
        {
            self.lable3.alpha = 0;
        }
        else
        {
            self.lable3.alpha = 1;
        }
    }
    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)saveAc:(id)sender
{
  

   AppDelegate *del = (AppDelegate *)[[UIApplication sharedApplication ]delegate];

//    if (self.oldPwd.alpha ==1 || self.newpwd.alpha ==1 || self.repeatPwd.alpha ==1)
//    {
////        [sender setEnabled:NO];
//    }
     if ([self.oldPwd.text isEqualToString: del.pwd])
    {
        dateBase *date = [[dateBase alloc]init];
        
        [date updatePwd:self.newpwd.text ForName:del.name];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    
}

- (IBAction)backAc:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
