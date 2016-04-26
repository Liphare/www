//
//  HomeViewController.h
//  P.xiaoshuo
//
//  Created by 王开政 on 16/3/1.
//  Copyright (c) 2016年 Wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SystemConfiguration/SystemConfiguration.h>
#import <CFNetwork/CFNetwork.h>
#import "RefreshView.h"
@interface HomeViewController : UIViewController<NSURLConnectionDataDelegate>

//@property (weak, nonatomic) IBOutlet UIScrollView *titleScrollView;
///* 内容滚动条 */
//@property (weak, nonatomic) IBOutlet UIScrollView *contentScrollView;
@property (nonatomic, retain) UIScrollView *scrollView;
@property (nonatomic, retain) NSArray *typeArray;
@property (nonatomic,retain) RefreshView *refreshView;
@property (retain, nonatomic) NSMutableData *mutImageData;
@property (retain, nonatomic) NSMutableData *mutbookData1;
@property (retain, nonatomic) NSMutableData *mutbookData2;
@property (nonatomic,retain) UIButton *btn;
@property (nonatomic,retain) UIImage *img;
@property (nonatomic,retain) NSString*bookstring;
@property (nonatomic,retain) NSURLConnection *con;
@property (nonatomic,retain) NSURLConnection *bookcon1;
@property (nonatomic,retain) NSURLConnection *bookcon2;
@property (nonatomic,assign)long long currentLength1;
@property (nonatomic,assign)long long sumLength1;
@property (nonatomic,assign)long long currentLength2;
@property (nonatomic,assign)long long sumLength2;
@property (retain, nonatomic) UIProgressView *progress1;
@property (retain, nonatomic) UIProgressView *progress2;
@property (nonatomic, retain) NSMutableDictionary *bookimgdic;
@property (nonatomic, retain) NSMutableDictionary *buttondic;
@property (nonatomic, retain) NSMutableArray *bookloadarray;
@property (nonatomic, retain) NSMutableArray *bookimgloadarray;
@property (nonatomic,copy) NSString *bookImg;
@property (nonatomic,copy) NSString *bookma1;
@property (nonatomic,copy) NSString *bookma2;
@property (nonatomic,copy) NSString *bookim1;
@property (nonatomic,copy) NSString *bookim2;
@end
