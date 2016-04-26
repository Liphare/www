//
//  RegisterViewController.h
//  P.xiaoshuo
//
//  Created by 王开政 on 16/2/29.
//  Copyright (c) 2016年 Wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "dateBase.h"
#import "Informaton.h"
@interface RegisterViewController : UIViewController
@property (strong, nonatomic) IBOutlet UITextField *RegName;
@property (strong, nonatomic) IBOutlet UITextField *RegPwd;
@property (strong, nonatomic) IBOutlet UITextField *RegRepeatPwd;
- (IBAction)RegSaveAC:(id)sender;
- (IBAction)RegBackAc:(id)sender;

@end
