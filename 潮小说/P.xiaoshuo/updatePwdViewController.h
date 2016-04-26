//
//  updatePwdViewController.h
//  P.xiaoshuo
//
//  Created by 王开政 on 16/3/2.
//  Copyright (c) 2016年 Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface updatePwdViewController : UIViewController
@property (strong, nonatomic) IBOutlet UITextField *oldPwd;
@property (strong, nonatomic) IBOutlet UITextField *repeatPwd;
@property (strong, nonatomic) IBOutlet UITextField *newpwd;
@property (strong, nonatomic) IBOutlet UILabel *lable1;
@property (strong, nonatomic) IBOutlet UILabel *lable2;
@property (strong, nonatomic) IBOutlet UILabel *lable3;
- (IBAction)saveAc:(id)sender;
- (IBAction)backAc:(id)sender;



@end
