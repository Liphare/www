//
//  LoginViewController.h
//  P.xiaoshuo
//
//  Created by 王开政 on 16/2/29.
//  Copyright (c) 2016年 Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController
@property (strong, nonatomic) IBOutlet UITextField *nameLable;
@property (strong, nonatomic) IBOutlet UITextField *pwdLable;
@property (strong, nonatomic) IBOutlet UITextField *verificationLable;
@property (strong, nonatomic) IBOutlet UIButton *verifitionPhoto;
- (IBAction)verifitionPhotoAction:(id)sender;
- (IBAction)loginAction:(id)sender;
- (IBAction)registerAction:(id)sender;

@property (nonatomic, retain) NSMutableArray *logs;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property(copy,nonatomic)NSString *verifition;
@end
