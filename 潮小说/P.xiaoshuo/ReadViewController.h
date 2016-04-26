//
//  ReadViewController.h
//  P.xiaoshuo
//
//  Created by 王开政 on 16/3/18.
//  Copyright (c) 2016年 Wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
@interface ReadViewController : UIViewController <AVSpeechSynthesizerDelegate>

@property (nonatomic, retain) UITextView *textView;
@property (nonatomic,retain) UIView *viewTop;
@property (nonatomic,retain) UIView *viewDown;
@property (nonatomic, retain)  UIView *fontView;
@property (nonatomic, copy) NSString *text;
@property (nonatomic, assign) NSInteger CharsNumbers;
@property (nonatomic, assign) NSInteger PageNumbers;
@property (nonatomic, assign) NSInteger i;
@property (nonatomic, assign) NSInteger number;
@property (nonatomic, assign) NSInteger leftnumber;
@property (nonatomic, assign) CGFloat fontSize;
@property (nonatomic, assign) NSInteger shu ;
@property (nonatomic,copy) NSString *firstPage;
@property (nonatomic,assign)  NSInteger num;
@property (nonatomic,assign) NSInteger off;
@property (nonatomic, retain) NSMutableArray *pageindex;
@property (nonatomic, retain) NSFileHandle *handle;
@property (nonatomic, retain) UISlider *slider;
@property (nonatomic, retain) UILabel *label;
@property (nonatomic, retain) UILabel *lab1;
@property (nonatomic, retain) UILabel *lab2;
@property (nonatomic, retain) NSString *markPath;
@property (nonatomic, retain) NSThread *thread;

@end
