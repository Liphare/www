//
//  PersonViewController.h
//  P.xiaoshuo
//
//  Created by 王开政 on 16/3/1.
//  Copyright (c) 2016年 Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PersonViewController : UIViewController<UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (strong, nonatomic) IBOutlet UIImageView *photoView;
@property (strong, nonatomic) IBOutlet UILabel *nameLable;
- (IBAction)photoAc:(id)sender;
- (IBAction)updatePwd:(id)sender;
- (IBAction)checkToUpdate:(id)sender;
- (IBAction)aboutUs:(id)sender;
- (IBAction)set:(id)sender;
- (IBAction)logOut:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *lable;

@end
