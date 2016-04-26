//
//  ReadViewController.m
//  P.xiaoshuo
//
//  Created by 王开政 on 16/3/18.
//  Copyright (c) 2016年 Wang. All rights reserved.
//

#import "ReadViewController.h"
#import "dateBase.h"
#import "AppDelegate.h"

@interface ReadViewController ()
@end


@implementation ReadViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    AppDelegate *del = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    dateBase *db = [[dateBase alloc]init];
    del.index =[[[db getBookListMassage]objectAtIndex:del.indexrow] bookMark].intValue;
    self.fontSize = 12;
    self.shu = 2;
    self.textView = [[UITextView alloc]initWithFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height)];
   
    [self.view addSubview:self.textView];
     self.textView.layoutManager.allowsNonContiguousLayout = NO;
    [[UIApplication sharedApplication] setStatusBarHidden:TRUE];
    self.textView.editable = NO;
    self.textView.scrollEnabled = NO;
    
    
    self.label = [[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width/3, self.view.frame.size.height/2, 120, 40)];
        self.label.backgroundColor = [UIColor colorWithRed:255/255.f green:208/255.f blue:119/255.f alpha:1];
    self.label.textAlignment = NSTextAlignmentCenter;
    self.label.alpha = 0; //添加提示框
    self.label.layer.cornerRadius = 10;
    self.label.layer.masksToBounds = YES;
    [self.textView addSubview:self.label];

//    添加菜单栏
    self.viewTop = [[UIView alloc]initWithFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y - 50, self.view.frame.size.width, 50)];
    //    CGFloat y =self.view.frame.origin.y - 160;
   self.viewDown = [[UIView alloc]initWithFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.size.height , self.view.frame.size.width,80)];
    
    self.viewTop.backgroundColor = [UIColor darkGrayColor];
    self.viewDown.backgroundColor = [UIColor darkGrayColor];
    [self.textView addSubview:self.viewTop];
    [self.textView addSubview:self.viewDown];
    
    UIButton *backBtn = [[UIButton alloc]initWithFrame:CGRectMake(self.viewTop.frame.origin.x, self.viewTop.frame.size.height - 40 , 40, 30)];
    UIButton *listenBtn = [[UIButton alloc]initWithFrame:CGRectMake(self.viewTop.frame.size.width - 41, self.viewTop.frame.size.height - 40, 40, 30)];
    UIButton *stopBtn = [[UIButton alloc]initWithFrame:CGRectMake(self.viewTop.frame.size.width - 82, self.viewTop.frame.size.height - 40, 40, 30)];
    [backBtn setTitle:@"返回" forState:UIControlStateNormal];
    [listenBtn setTitle:@"听书" forState:UIControlStateNormal];
    [stopBtn setTitle:@"暂停" forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [listenBtn addTarget:self action:@selector(startTalking) forControlEvents:UIControlEventTouchUpInside];
    [stopBtn addTarget:self action:@selector(stopSpeech) forControlEvents:(UIControlEventTouchUpInside)];
    [self.viewTop addSubview:backBtn];
    [self.viewTop addSubview:listenBtn];
    [self.viewTop addSubview:stopBtn];
    UIButton *fontBtn = [[UIButton alloc]initWithFrame:CGRectMake(self.viewDown.frame.origin.x, self.viewDown.frame.size.height - 60, 50, 40)];
    UIButton *modBtn = [[UIButton alloc]initWithFrame:CGRectMake(self.viewDown.frame.size.width - 45, self.viewDown.frame.size.height - 60, 50, 40)];
    
    [modBtn setBackgroundImage:[UIImage imageNamed:@"模式"] forState:UIControlStateNormal];
    [fontBtn setBackgroundImage:[UIImage imageNamed:@"字体"] forState:UIControlStateNormal];
    [modBtn addTarget:self action:@selector(modle) forControlEvents:UIControlEventTouchUpInside];
    [fontBtn addTarget:self action:@selector(changeFont) forControlEvents:UIControlEventTouchUpInside];
    [self.viewDown addSubview:fontBtn];
    [self.viewDown addSubview:modBtn];
    //添加进度条
    self.slider = [[UISlider alloc]initWithFrame:CGRectMake(self.viewDown.frame.origin.x + 50, self.viewDown.frame.size.height / 3, self.viewDown.frame.size.width - 100, 30)];
     self.slider.maximumTrackTintColor = [UIColor whiteColor];
    [ self.slider addTarget:self action:@selector(sliderAC:) forControlEvents:UIControlEventValueChanged];
    [self.viewDown addSubview: self.slider];
    self.lab1 = [[UILabel alloc]initWithFrame:CGRectMake(self.viewDown.frame.size.width-100, self.viewDown.frame.size.height*2/3, 60, 40)];
   
    self.lab2 = [[UILabel alloc]initWithFrame:CGRectMake(self.viewDown.frame.size.width-160, self.viewDown.frame.size.height*2/3, 60, 40)];
    self.lab1.textColor = [UIColor whiteColor];
    self.lab2.textColor = [UIColor whiteColor];
    self.lab2.textAlignment =NSTextAlignmentRight;
    [self.viewDown addSubview:self.lab1];
    [self.viewDown addSubview:self.lab2];
    //添加字体栏
    self.fontView = [[UIView alloc]initWithFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.size.height , self.view.frame.size.width, 50)];
    self.fontView.backgroundColor = [UIColor darkGrayColor];
    [self.view addSubview:self.fontView];
    UIButton *btn1 = [[UIButton alloc]initWithFrame:CGRectMake(self.fontView.frame.origin.x + 10, 10, 30, 30)];
    
    UIButton *btn2 = [[UIButton alloc]initWithFrame:CGRectMake(self.fontView.frame.origin.x + 50, 10, 30, 30)];
    [btn1 setBackgroundImage:[UIImage imageNamed:@"a-"] forState:UIControlStateNormal];
    [btn2 setBackgroundImage:[UIImage imageNamed:@"a+"] forState:UIControlStateNormal];
    [btn1 addTarget:self action:@selector(adFont) forControlEvents:UIControlEventTouchUpInside];
    [btn2 addTarget:self action:@selector(subFont) forControlEvents:UIControlEventTouchUpInside];
    [self.fontView addSubview:btn1];
    [self.fontView addSubview:btn2];
    
    // 获取图书
    NSArray *array = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *str = [array objectAtIndex:0];
    
   
    NSString *path = [str stringByAppendingPathComponent:del.bookName];
    //    左右滑动
    UISwipeGestureRecognizer *swipeGestureToRight=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeImage:)];
    //
    swipeGestureToRight.direction=UISwipeGestureRecognizerDirectionRight;//默认为向右轻扫
    [self.view addGestureRecognizer:swipeGestureToRight];
    
    UISwipeGestureRecognizer *swipeGestureToLeft=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeImage:)];
    swipeGestureToLeft.direction=UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:swipeGestureToLeft];
//    点击手势
    UITapGestureRecognizer *singleRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(single:)];
    singleRecognizer.numberOfTapsRequired = 1;
     [self.textView addGestureRecognizer:singleRecognizer];
    
    self.textView.backgroundColor = [UIColor whiteColor];
    self.textView.font =[UIFont boldSystemFontOfSize:20];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    NSDictionary *fileAttributes = [fileManager attributesOfItemAtPath:path error:&error];
    self.handle = [NSFileHandle fileHandleForReadingAtPath:path];
    self. off = [[fileAttributes objectForKey:NSFileSize] unsignedLongLongValue];
    
    self.pageindex  = [[NSMutableArray alloc]init];
    NSNumber *number = [NSNumber numberWithInteger:0];
    [self.pageindex addObject:number];
    self.num = [self page: self.handle andoffset:0];
    NSString *markStr = [str stringByAppendingPathComponent:@"bookMarkArrayfile"];
    NSString *markName = [del.bookName substringFromIndex:9];//把bookName截去
    self.markPath = [markStr stringByAppendingPathComponent:markName];
    NSString *mark = [@"bookMarkArrayfile" stringByAppendingPathComponent:markName];

    BOOL exi =[self isFileExisted:mark];
    if (!exi)//判断本地有无分页结果
    {
      // 没有 ，先分100页，剩下的开多线程做
       for (; self.num < self.off; )
      {
        number = [NSNumber numberWithInteger:self.num];
        [self.pageindex addObject:number];
        self.num = [self page: self.handle andoffset:self.num];
        if (self.pageindex.count == 100)
        {
            break;
        }
        
      }
    // 然后保存到本地
        
        NSData *markData = [NSKeyedArchiver archivedDataWithRootObject:self.pageindex];
        [markData writeToFile:self.markPath atomically:YES];
       
    }
//    有  直接获取
    NSData *markdata = [NSData dataWithContentsOfFile:self.markPath];
    self.pageindex = [NSKeyedUnarchiver unarchiveObjectWithData:markdata];
   
//    显示某页内容
    NSNumber * sss1 =[self.pageindex objectAtIndexedSubscript:del.index];
    NSNumber * sss2 =[self.pageindex objectAtIndexedSubscript:del.index +1];
    [ self.handle seekToFileOffset:sss1.intValue ];
    NSData *data = [ self.handle readDataOfLength:sss2.intValue - sss1.intValue];
    NSString *iStr =[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    self.textView.text =iStr;
    self.lab2.text = [NSString stringWithFormat:@"%d",del.index];
    //设置进度条范围
    self.slider.maximumValue = self.pageindex.count-2;
    self.slider.minimumValue = 0;
//    开多线程
    self.thread = [[NSThread alloc] initWithTarget:self selector:@selector(run) object:nil];
    if ([[self.pageindex objectAtIndex:self.pageindex.count-1] intValue] < self.off)
    {
        [self.thread start];
    }
    self.slider.value = del.index;
}
-(void)run
{
    self.num =[[self.pageindex objectAtIndex:self.pageindex.count-1]intValue] ;
    NSNumber *number = [NSNumber numberWithInteger:self.num];
    for (; self.num < self.off; )
    {
        if ([self.thread isCancelled])
        {
            [NSThread exit];
        }

        self.num = [self page: self.handle andoffset:self.num];
        number = [NSNumber numberWithInteger:self.num];
        [self.pageindex addObject:number];
        NSData *markData = [NSKeyedArchiver archivedDataWithRootObject:self.pageindex];
        [markData writeToFile:self.markPath atomically:YES];

    }
    NSLog(@"ppp==%lu",(unsigned long)self.pageindex.count);
    self.slider.maximumValue = self.pageindex.count-2;
    NSLog(@"%f",self.slider.maximumValue);
    NSLog(@"多线程");
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)back//保存书签并返回书架
{
    dateBase*db = [[dateBase alloc]init];
    AppDelegate *del = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    [db updatebookList:del.bookName andbookMark:[NSString stringWithFormat:@"%d",del.index]];
    if ([self.thread isExecuting])
    {
        [self.thread cancel];
    }
    
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void) startTalking//开始
{
    AppDelegate *del = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    NSNumber * sss1 =[self.pageindex objectAtIndexedSubscript:del.index];
    NSNumber * sss2 =[self.pageindex objectAtIndexedSubscript:del.index +1];
    [ self.handle seekToFileOffset:sss1.intValue ];
    NSData *data = [ self.handle readDataOfLength:sss2.intValue - sss1.intValue];
    NSString *iStr =[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];

    AVSpeechUtterance* utter = [[AVSpeechUtterance alloc] initWithString:iStr];
    utter.voice = [AVSpeechSynthesisVoice voiceWithLanguage:@"zh-CN"];
    [utter setRate:0.2f];
    AVSpeechSynthesizer *talked = del.talker;
    if([talked isSpeaking])
    {
        [talked stopSpeakingAtBoundary:AVSpeechBoundaryImmediate];
        AVSpeechUtterance *utterance = [AVSpeechUtterance speechUtteranceWithString:@""];
        [talked speakUtterance:utterance];
        [talked stopSpeakingAtBoundary:AVSpeechBoundaryImmediate];
    }

    if (!del.talker) {
        del.talker = [AVSpeechSynthesizer new];
    }
    del.talker.delegate = self;
    [del.talker speakUtterance:utter];
}
- (void)stopSpeech//暂停
{
    AppDelegate *del = (AppDelegate *)[[UIApplication sharedApplication]delegate];

    AVSpeechSynthesizer *talked = del.talker;
    if([talked isSpeaking])
    {
        [talked stopSpeakingAtBoundary:AVSpeechBoundaryImmediate];
        AVSpeechUtterance *utterance = [AVSpeechUtterance speechUtteranceWithString:@""];
        [talked speakUtterance:utterance];
        [talked stopSpeakingAtBoundary:AVSpeechBoundaryImmediate];
    }
    dateBase*db = [[dateBase alloc]init];
    [db updatebookList:del.bookName andbookMark:[NSString stringWithFormat:@"%d",del.index]];
}
- (void)speechSynthesizer:(AVSpeechSynthesizer *)synthesizer didFinishSpeechUtterance:(AVSpeechUtterance *)utteranc
{
    AppDelegate *del = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    

    if (del.index < self.pageindex.count - 1)
    {
        del.index += 1;
        del.talker.delegate = self;
        NSNumber * sss1 =[self.pageindex objectAtIndexedSubscript:del.index];
        NSNumber * sss2 =[self.pageindex objectAtIndexedSubscript:del.index +1];
        [ self.handle seekToFileOffset:sss1.intValue ];
        NSData *data = [ self.handle readDataOfLength:sss2.intValue - sss1.intValue];
        NSString *iStr =[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        AVSpeechUtterance *utter = [[AVSpeechUtterance alloc] initWithString:iStr];
        utter.voice = [AVSpeechSynthesisVoice voiceWithLanguage:@"zh-CN"];
        [utter setRate:0.2f];
        if (!del.talker) {
            del.talker = [AVSpeechSynthesizer new];
        }
        [del.talker speakUtterance:utter];
    }

}
-(void)modle//夜间模式
{
    if (self.textView.backgroundColor == [UIColor whiteColor])
    {
        self.textView.backgroundColor = [UIColor blackColor];
        [self.textView setTextColor:[UIColor whiteColor]];
    }
    else
    {
    self.textView.backgroundColor = [UIColor whiteColor];
    [self.textView setTextColor:[UIColor blackColor]];
    }
}
-(void)changeFont//字体按钮n
{
    self.fontView.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.size.height - 131, self.view.frame.size.width, 50);
}
//-(void)adFont//加字体
//{
//    self.fontSize = self.fontSize +2;
//    self.textView.font =[UIFont fontWithName:self.text size:self.fontSize];
//    [self page];
//}
-(unsigned long long)page:(NSFileHandle *)handle andoffset:(unsigned long long)offset
{
    NSUInteger midlength = 0;
    [handle seekToFileOffset:offset];//跳到指定文件的偏移量
    NSString *iStr;
    for (int j = 0; j < 3; j ++)
    {
    NSUInteger length = 1100;
    [handle seekToFileOffset:offset];
    NSData *data = [handle readDataOfLength:length + j];
    iStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    if (iStr)
        {
            NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
            paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
            NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:self.textView.font, NSFontAttributeName, paragraphStyle.copy, NSParagraphStyleAttributeName, nil];
            CGSize pageTextSize = [iStr boundingRectWithSize:CGSizeMake(self.textView.bounds.size.width-10, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
           
            while (pageTextSize.height > self.textView.frame.size.height)
            {
                length = length - 1;
                [handle seekToFileOffset:offset];
                NSData *data = [handle readDataOfLength:length + j];
                
                
           iStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
          if (iStr)
                {
                    midlength = length;
                   pageTextSize = [iStr boundingRectWithSize:CGSizeMake(self.textView.bounds.size.width-10, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
                }
            }
            break;
        }
        
    }
    offset= [handle offsetInFile];
    return offset;
    
}
//隐藏d当前页面的状态栏
-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleDefault;
    //    UIStatusBarStyleDefault = 0;  黑色文字 ，浅色背景时使用
    //    UIStatusBarStyleLightContent = 1; 白色文字，深色背景时使用
}
-(BOOL)prefersStatusBarHidden
{
    return YES;
}
-(void)sliderAC:(UISlider *)sender
{
   AppDelegate *del = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    del.index = sender.value;
    if (del.index == sender.maximumValue)
    {
        
        
        NSNumber * sss1 =[self.pageindex objectAtIndexedSubscript:del.index];
        [ self.handle seekToFileOffset:sss1.intValue ];
        
        NSData *data = [ self.handle readDataOfLength:self.off - sss1.intValue];
        NSString *iStr =[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        self.lab2.text = [NSString stringWithFormat:@"%d",del.index];
        self.textView.text =iStr;
        return;
    }
    NSNumber * sss1 =[self.pageindex objectAtIndexedSubscript:del.index];
    NSNumber * sss2 =[self.pageindex objectAtIndexedSubscript:del.index +1];
    [ self.handle seekToFileOffset:sss1.intValue ];
    
    NSData *data = [ self.handle readDataOfLength:sss2.intValue - sss1.intValue];
    NSString *iStr =[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    self.lab2.text = [NSString stringWithFormat:@"%d",del.index];
    self.textView.text =iStr;
}
//点击事件
-(void)single:(UITapGestureRecognizer *)gesture
{
    
     self.lab1.text = [@"/" stringByAppendingString:[NSString stringWithFormat:@"%lu",(unsigned long)self.pageindex.count -2]];
   
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationTransition:UIViewAnimationTransitionNone forView:self.view cache:YES];
    
   
    if (self.viewTop.frame.origin.y == self.view.frame.origin.y - 50)
    {
       
        self.viewTop.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y , self.view.frame.size.width, 50);
        self.viewDown.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.size.height - 80, self.view.frame.size.width, 80);
        
    }
    else
    {
        self.viewTop.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y -50, self.view.frame.size.width, 50);
        self.viewDown.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.size.height , self.view.frame.size.width, 80);
       
    }
    if (self.fontView.frame.origin.y ==self.view.frame.size.height - 131) {
        self.fontView.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.size.height , self.view.frame.size.width, 50);
        }
    
  [UIView commitAnimations];
    
}
//左右滑动手势
-(void)swipeImage:(UISwipeGestureRecognizer *)gesture
{
    AppDelegate *del = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    //direction记录的轻扫的方向
    if (gesture.direction==UISwipeGestureRecognizerDirectionRight)
    {
        
    //向右
        if (del.index == 0)
        {
            [UIView animateWithDuration:1.5 animations:^{
                self.label.alpha =1;
                self.label.text = @"已是第一页";
            }
                             completion:^(BOOL finished)
             {
                 self.label.alpha = 0;
             }];
            return;
        }
        del.index--;
        
        NSNumber * sss1 =[self.pageindex objectAtIndexedSubscript:del.index];
        NSNumber * sss2 =[self.pageindex objectAtIndexedSubscript:del.index +1];
        [ self.handle seekToFileOffset:sss1.intValue ];
        
        NSData *data = [ self.handle readDataOfLength:sss2.intValue - sss1.intValue];
        NSString *iStr =[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        self.textView.text =iStr;
        self.slider.value = del.index;
        [self transitionWithType:@"pageCurl" WithSubtype:kCATransitionFromLeft ForView:self.textView];
    }
    else if(gesture.direction==UISwipeGestureRecognizerDirectionLeft)
    {
    //向左
        NSLog(@"del===%d",del.index);
       
        NSLog(@"ppp==%lu",(unsigned long)self.pageindex.count);
        if (del.index == self.pageindex.count -3)
        {
            NSNumber * sss1 =[self.pageindex objectAtIndexedSubscript:del.index+1];
            [ self.handle seekToFileOffset:sss1.intValue ];
            
            NSData *data = [ self.handle readDataOfLength:self.off - sss1.intValue];
            NSString *iStr =[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            [self transitionWithType:@"pageCurl" WithSubtype:kCATransitionFromRight ForView:self.textView];
            del.index =(int)self.pageindex.count -2;
            self.textView.text =iStr;
            self.lab2.text = [NSString stringWithFormat:@"%d",del.index];
            return;
        }

        if (del.index ==self.pageindex.count-2)
        {
            [UIView animateWithDuration:1.5 animations:^{
                self.label.alpha =1;
                self.label.text = @"已是最后一页";
            }
                             completion:^(BOOL finished)
             {
                 self.label.alpha = 0;
             }];
            return;
        }
        
        del.index++;
        
        NSNumber * sss1 =[self.pageindex objectAtIndexedSubscript:del.index];
        NSNumber * sss2 =[self.pageindex objectAtIndexedSubscript:del.index +1];
        [ self.handle seekToFileOffset:sss1.intValue ];
        
        NSData *data = [ self.handle readDataOfLength:sss2.intValue - sss1.intValue];
        NSString *iStr =[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        self.textView.text =iStr;
        self.slider.value = del.index;
        [self transitionWithType:@"pageCurl" WithSubtype:kCATransitionFromRight ForView:self.textView];//从右边翻动
//        [self animationWithView:self.view WithAnimationTransition:UIViewAnimationTransitionCurlUp];从右下角向上卷动
    }
    self.lab2.text = [NSString stringWithFormat:@"%d",del.index];
}
#pragma CATransition动画实现
- (void) transitionWithType:(NSString *) type WithSubtype:(NSString *) subtype ForView : (UIView *) view
{
    //创建CATransition对象
    CATransition *animation = [CATransition animation];
    
    //设置运动时间
    animation.duration = 0.5;
    
    //设置运动type
    animation.type = type;
    if (subtype != nil) {
        
        //设置子类
        animation.subtype = subtype;
    }
    
    //设置运动速度
    animation.timingFunction = UIViewAnimationOptionCurveEaseInOut;
    
    [view.layer addAnimation:animation forKey:@"animation"];
}



#pragma UIView实现动画
- (void) animationWithView : (UIView *)view WithAnimationTransition : (UIViewAnimationTransition) transition
{
         [UIView animateWithDuration:0.5 animations:^{
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [UIView setAnimationTransition:transition forView:view cache:YES];
    }];
}
-(BOOL)isFileExisted:(NSString *)fileName
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if(![fileManager fileExistsAtPath:[self getFilePath:fileName]])
    {
        return NO;
    }
    
    
    return YES;
}
- (NSString *)getFilePath:(NSString *)fileName{
    NSArray *array = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [[array objectAtIndex:0] stringByAppendingPathComponent:fileName];
    
    return path;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
 