//
//  PersonViewController.m
//  P.xiaoshuo
//
//  Created by 王开政 on 16/3/1.
//  Copyright (c) 2016年 Wang. All rights reserved.
//

#import "PersonViewController.h"
#import "AppDelegate.h"
#import "dateBase.h"
#import "LoginViewController.h"
#import "updatePwdViewController.h"
#import "aboutUsViewController.h"
@interface PersonViewController ()

@end

@implementation PersonViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    AppDelegate *del = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    self.nameLable.text =del.name;
    NSArray *array = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *str = [array objectAtIndex:0];
    NSString *path = [str stringByAppendingPathComponent:del.photo];
    NSData *data1 = [NSData dataWithContentsOfFile:path];
    UIImage * img1 = [[UIImage alloc]initWithData:data1];
    self.photoView.image = img1;
    // Do any additional setup after loading the view from its nib.
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
//上传图片按钮
- (IBAction)photoAc:(id)sender
{
    UIImagePickerController *imagePicher = [[UIImagePickerController alloc]init];
    imagePicher.delegate = self;
    imagePicher.editing =YES;
    [self presentViewController:imagePicher animated:YES completion:nil];
}

- (IBAction)updatePwd:(id)sender
{
//    dateBase *date = [[dateBase alloc]init];
    
    updatePwdViewController *updateView = [[updatePwdViewController alloc]initWithNibName:@"updatePwdViewController" bundle:nil];
    [self presentViewController:updateView animated:YES completion:nil];
}

- (IBAction)checkToUpdate:(id)sender
{
    
    [UIView animateWithDuration:1.5 animations:^{
        self.lable.alpha =1;
    }
                        completion:^(BOOL finished)
    {
       self.lable.alpha = 0;
    }];
}

- (IBAction)aboutUs:(id)sender
{
    aboutUsViewController *aboutUsView = [[aboutUsViewController alloc]initWithNibName:@"aboutUsViewController" bundle:nil];
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:aboutUsView];
    [self presentViewController:nav animated:YES completion:nil];
}

- (IBAction)set:(id)sender {
}

- (IBAction)logOut:(id)sender
{
    UIAlertController *alertView = [UIAlertController alertControllerWithTitle:@"提示" message:@"是否确认退出" preferredStyle:UIAlertControllerStyleAlert];
     UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action)
                               {
                                   LoginViewController *viewControl = [[LoginViewController alloc]initWithNibName:@"LoginViewController" bundle:nil];
                                   
                                   [self presentViewController:viewControl animated:YES completion:nil];
                               }];
    
    [alertView addAction:okAction];
    [alertView addAction:cancelAction];
    [self presentViewController:alertView animated:YES completion:nil];
   

    
}

//从相册中选图片
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo
{
    self.photoView.image =image;
    dateBase * obj = [[dateBase alloc]init];
    [obj updatePhoto:self.nameLable.text ForName:self.nameLable.text];
        NSArray *array = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *str = [array objectAtIndex:0];
    NSData *imgdata = UIImagePNGRepresentation(self.photoView.image);
    NSString *path = [str stringByAppendingPathComponent:self.nameLable.text];
    BOOL result = [imgdata writeToFile:path atomically:YES];
    if (result)
    {
        NSLog(@" ok");
    }

    [self dismissViewControllerAnimated:YES completion:nil];
    
}
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
